#!/usr/bin/env python3
"""
N8N Integration Database Sync
============================

This script takes the processed n8n integration data and syncs it to your
catalog-edge-db database using the proper schema mappings.
"""

import os
import json
import psycopg2
import psycopg2.extras
import logging
from datetime import datetime
from typing import Dict, List, Optional, Any
import argparse

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class IntegrationDatabaseSync:
    """Syncs processed n8n integration data to catalog-edge-db"""
    
    def __init__(self, db_config: Dict[str, str]):
        """Initialize with database configuration"""
        self.db_config = db_config
        logger.info("Initialized Integration Database Sync")
    
    def get_database_connection(self):
        """Get database connection"""
        try:
            conn = psycopg2.connect(**self.db_config)
            conn.autocommit = False
            return conn
        except Exception as e:
            logger.error(f"Database connection failed: {e}")
            raise
    
    def load_processed_data(self, processed_file: str) -> List[Dict[str, Any]]:
        """Load processed integration data from JSON file"""
        try:
            with open(processed_file, 'r') as f:
                data = json.load(f)
            
            integrations = data.get('integrations', [])
            logger.info(f"Loaded {len(integrations)} integrations from {processed_file}")
            return integrations
            
        except Exception as e:
            logger.error(f"Failed to load processed data: {e}")
            raise
    
    def transform_to_channel_master(self, integration: Dict[str, Any]) -> Dict[str, Any]:
        """Transform integration data to saas_channel_master format"""
        
        # Extract base information
        channel_key = integration.get('channel_key', '')
        channel_name = integration.get('display_name', '')
        description = integration.get('description', '')
        
        # Determine base_url from credentials
        base_url = None
        credentials = integration.get('credentials', [])
        if credentials:
            first_cred = credentials[0]
            doc_url = first_cred.get('documentation_url', '')
            if doc_url and not doc_url.startswith('https://docs.n8n.io'):
                # Use the API documentation URL as base_url
                if 'api.slack.com' in doc_url:
                    base_url = 'https://api.slack.com'
                elif 'shopify.dev' in doc_url:
                    base_url = 'https://admin.shopify.com/admin/api'
                elif 'developers.google.com' in doc_url:
                    base_url = 'https://gmail.googleapis.com'
                elif 'platform.openai.com' in doc_url:
                    base_url = 'https://api.openai.com'
        
        # Create enhanced default configuration
        default_config = integration.get('default_config', {})
        default_config.update({
            'category': integration.get('category', ''),
            'subcategory': integration.get('subcategory', ''),
            'description': description,
            'resources': [r.get('value') for r in integration.get('resources', [])],
            'node_metadata': {
                'total_properties': integration.get('metadata', {}).get('total_properties', 0),
                'has_oauth': integration.get('metadata', {}).get('has_oauth', False),
                'has_webhook_support': integration.get('metadata', {}).get('has_webhook_support', False)
            }
        })
        
        # Use capabilities and add credential schemas
        capabilities = integration.get('capabilities', {})
        credential_schemas = {}
        for cred in credentials:
            cred_name = cred.get('name', '')
            schema = self._create_credential_schema(cred)
            if schema:
                credential_schemas[cred_name] = schema
        
        if credential_schemas:
            capabilities['credential_schemas'] = credential_schemas
        
        return {
            'channel_key': channel_key,
            'channel_name': channel_name,
            'base_url': base_url,
            'docs_url': integration.get('docs_url', ''),
            'channel_logo_url': integration.get('icon_url', ''),
            'default_channel_config': json.dumps(default_config),
            'capabilities': json.dumps(capabilities)
        }
    
    def _create_credential_schema(self, credential: Dict[str, Any]) -> Dict[str, Any]:
        """Create JSON schema for credential"""
        properties = credential.get('properties', [])
        if not properties:
            return None
        
        schema = {
            'type': 'object',
            'properties': {},
            'required': [],
            'description': credential.get('display_name', ''),
            'documentation_url': credential.get('documentation_url', '')
        }
        
        for prop in properties:
            prop_name = prop.get('name', '')
            if not prop_name:
                continue
                
            schema['properties'][prop_name] = {
                'type': 'string',
                'description': prop.get('display_name', ''),
                'format': 'password' if prop.get('sensitive', False) else 'text',
                'default': prop.get('default', '')
            }
            
            if prop.get('required', False):
                schema['required'].append(prop_name)
        
        return schema
    
    def sync_to_saas_channel_master(self, integrations: List[Dict[str, Any]], 
                                   update_existing: bool = False) -> Dict[str, int]:
        """Sync integrations to saas_channel_master table"""
        
        conn = self.get_database_connection()
        results = {'inserted': 0, 'updated': 0, 'skipped': 0, 'errors': 0}
        
        try:
            cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            
            for integration in integrations:
                try:
                    # Transform data
                    channel_data = self.transform_to_channel_master(integration)
                    channel_key = channel_data['channel_key']
                    
                    if not channel_key:
                        logger.warning(f"Skipping integration with empty channel_key: {integration.get('display_name', 'unknown')}")
                        results['skipped'] += 1
                        continue
                    
                    # Check if channel already exists
                    cursor.execute(
                        "SELECT channel_id, updated_at FROM saas_channel_master WHERE channel_key = %s",
                        (channel_key,)
                    )
                    existing = cursor.fetchone()
                    
                    if existing:
                        if update_existing:
                            # Update existing channel
                            update_sql = """
                            UPDATE saas_channel_master SET
                                channel_name = %(channel_name)s,
                                base_url = %(base_url)s,
                                docs_url = %(docs_url)s,
                                channel_logo_url = %(channel_logo_url)s,
                                default_channel_config = %(default_channel_config)s::jsonb,
                                capabilities = %(capabilities)s::jsonb,
                                updated_at = NOW()
                            WHERE channel_key = %(channel_key)s
                            """
                            
                            cursor.execute(update_sql, channel_data)
                            results['updated'] += 1
                            logger.info(f"Updated channel: {channel_key}")
                        else:
                            results['skipped'] += 1
                            logger.info(f"Skipped existing channel: {channel_key}")
                    else:
                        # Insert new channel
                        insert_sql = """
                        INSERT INTO saas_channel_master (
                            channel_key, channel_name, base_url, docs_url,
                            channel_logo_url, default_channel_config, capabilities
                        ) VALUES (
                            %(channel_key)s, %(channel_name)s, %(base_url)s, %(docs_url)s,
                            %(channel_logo_url)s, %(default_channel_config)s::jsonb, %(capabilities)s::jsonb
                        )
                        """
                        
                        cursor.execute(insert_sql, channel_data)
                        results['inserted'] += 1
                        logger.info(f"Inserted new channel: {channel_key}")
                        
                except Exception as e:
                    logger.error(f"Error processing integration {integration.get('display_name', 'unknown')}: {e}")
                    results['errors'] += 1
                    continue
            
            conn.commit()
            logger.info(f"Channel sync completed: {results}")
            
        except Exception as e:
            conn.rollback()
            logger.error(f"Channel sync failed: {e}")
            raise
        finally:
            conn.close()
        
        return results
    
    def validate_database_schema(self) -> bool:
        """Validate that required database tables exist"""
        conn = self.get_database_connection()
        
        try:
            cursor = conn.cursor()
            
            required_tables = [
                'saas_channel_master',
                'saas_n8n_flows',
                'saas_channel_master_flow_defs',
                'saas_channel_installations'
            ]
            
            for table in required_tables:
                cursor.execute(
                    "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = %s)",
                    (table,)
                )
                exists = cursor.fetchone()[0]
                
                if not exists:
                    logger.error(f"Required table {table} does not exist")
                    return False
            
            logger.info("Database schema validation passed")
            return True
            
        except Exception as e:
            logger.error(f"Database schema validation failed: {e}")
            return False
        finally:
            conn.close()
    
    def get_sync_summary(self) -> Dict[str, Any]:
        """Get summary of current database state"""
        conn = self.get_database_connection()
        
        try:
            cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            
            # Count channels
            cursor.execute("SELECT COUNT(*) as total FROM saas_channel_master")
            total_channels = cursor.fetchone()['total']
            
            # Get sample channels for verification
            cursor.execute("""
                SELECT channel_key, channel_name, 
                       capabilities->>'category' as category
                FROM saas_channel_master 
                ORDER BY created_at DESC 
                LIMIT 10
            """)
            sample_channels = cursor.fetchall()
            
            return {
                'total_channels': total_channels,
                'sample_channels': [dict(row) for row in sample_channels],
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Failed to get sync summary: {e}")
            raise
        finally:
            conn.close()

def main():
    """Main execution function"""
    parser = argparse.ArgumentParser(description='Sync processed n8n integrations to database')
    parser.add_argument('processed_file', help='Path to processed integrations JSON file')
    parser.add_argument('--db-host', default=os.getenv('DB_HOST'), help='Database host')
    parser.add_argument('--db-port', default=os.getenv('DB_PORT', '5432'), help='Database port')
    parser.add_argument('--db-name', default=os.getenv('DB_NAME', 'catalog-edge-db'), help='Database name')
    parser.add_argument('--db-user', default=os.getenv('DB_USER'), help='Database user')
    parser.add_argument('--db-password', default=os.getenv('DB_PASSWORD'), help='Database password')
    parser.add_argument('--update', action='store_true', help='Update existing entries')
    parser.add_argument('--validate-only', action='store_true', help='Only validate database schema')
    
    args = parser.parse_args()
    
    # Validate required arguments
    if not args.validate_only and not os.path.exists(args.processed_file):
        logger.error(f"Processed file not found: {args.processed_file}")
        return
    
    db_config = {
        'host': args.db_host,
        'port': int(args.db_port),
        'database': args.db_name,
        'user': args.db_user,
        'password': args.db_password
    }
    
    # Validate database configuration
    missing_config = [key for key, value in db_config.items() if not value]
    if missing_config:
        logger.error(f"Missing database configuration: {missing_config}")
        logger.error("Please set environment variables or use command line arguments")
        return
    
    try:
        # Create sync instance
        sync = IntegrationDatabaseSync(db_config)
        
        # Validate database schema
        if not sync.validate_database_schema():
            logger.error("Database schema validation failed")
            logger.error("Please ensure your catalog-edge-db schema is deployed")
            return
        
        if args.validate_only:
            logger.info("Database schema validation passed")
            summary = sync.get_sync_summary()
            print("\nCurrent Database State:")
            print(f"  Total Channels: {summary['total_channels']}")
            if summary['sample_channels']:
                print("  Sample Channels:")
                for ch in summary['sample_channels'][:5]:
                    print(f"    • {ch['channel_key']}: {ch['channel_name']}")
            return
        
        # Load processed data
        integrations = sync.load_processed_data(args.processed_file)
        
        # Sync channels
        logger.info("Syncing channels to saas_channel_master...")
        channel_results = sync.sync_to_saas_channel_master(integrations, args.update)
        
        # Get final summary
        summary = sync.get_sync_summary()
        
        # Print results
        print("\n" + "="*60)
        print("DATABASE SYNC COMPLETED")
        print("="*60)
        print(f"Results:")
        print(f"  • Inserted: {channel_results['inserted']}")
        print(f"  • Updated: {channel_results['updated']}")
        print(f"  • Skipped: {channel_results['skipped']}")
        print(f"  • Errors: {channel_results['errors']}")
        
        print(f"\nFinal Database State:")
        print(f"  • Total Channels: {summary['total_channels']}")
        
        if summary['sample_channels']:
            print("\nSample Synced Channels:")
            for ch in summary['sample_channels'][:5]:
                category = ch['category'] or 'Unknown'
                print(f"  • {ch['channel_key']}: {ch['channel_name']} ({category})")
        
        print("="*60)
        
        if channel_results['inserted'] > 0:
            print(f"\n✅ Successfully synced {channel_results['inserted']} new integrations!")
            print("Next steps:")
            print("1. Review the channels in your database")
            print("2. Configure platform-level credentials in your admin portal")
            print("3. Test the installation workflow with your users")
        
    except Exception as e:
        logger.error(f"Sync failed: {e}")
        raise

if __name__ == "__main__":
    main()
