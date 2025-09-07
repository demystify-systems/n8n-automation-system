#!/usr/bin/env python3
"""
N8N Integration Database Sync
============================

This script takes the processed n8n integration data and syncs it to your
catalog-edge-db database using the proper schema mappings.

Features:
- Loads processed integration data from JSON files
- Maps n8n metadata to saas_channel_master schema
- Creates proper credential schemas
- Generates default flow definitions
- Handles conflicts and updates
- Provides detailed logging and progress tracking
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
        
        # Use docs_url
        docs_url = integration.get('docs_url', '')
        
        # Use icon_url
        icon_url = integration.get('icon_url', '')
        
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
        
        # Use capabilities
        capabilities = integration.get('capabilities', {})
        
        # Add credential schema to capabilities
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
            'docs_url': docs_url,
            'channel_logo_url': icon_url,
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
        results = {
            'inserted': 0,
            'updated': 0,
            'skipped': 0,
            'errors': 0
        }
        
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
                            update_sql = \"\"\"\n                            UPDATE saas_channel_master SET\n                                channel_name = %(channel_name)s,\n                                base_url = %(base_url)s,\n                                docs_url = %(docs_url)s,\n                                channel_logo_url = %(channel_logo_url)s,\n                                default_channel_config = %(default_channel_config)s::jsonb,\n                                capabilities = %(capabilities)s::jsonb,\n                                updated_at = NOW()\n                            WHERE channel_key = %(channel_key)s\n                            \"\"\"\n                            \n                            cursor.execute(update_sql, channel_data)\n                            results['updated'] += 1\n                            logger.info(f\"Updated channel: {channel_key}\")\n                        else:\n                            results['skipped'] += 1\n                            logger.info(f\"Skipped existing channel: {channel_key} (use --update to update)\")\n                    else:\n                        # Insert new channel\n                        insert_sql = \"\"\"\n                        INSERT INTO saas_channel_master (\n                            channel_key, channel_name, base_url, docs_url,\n                            channel_logo_url, default_channel_config, capabilities\n                        ) VALUES (\n                            %(channel_key)s, %(channel_name)s, %(base_url)s, %(docs_url)s,\n                            %(channel_logo_url)s, %(default_channel_config)s::jsonb, %(capabilities)s::jsonb\n                        )\n                        \"\"\"\n                        \n                        cursor.execute(insert_sql, channel_data)\n                        results['inserted'] += 1\n                        logger.info(f\"Inserted new channel: {channel_key}\")\n                        \n                except Exception as e:\n                    logger.error(f\"Error processing integration {integration.get('display_name', 'unknown')}: {e}\")\n                    results['errors'] += 1\n                    continue\n            \n            conn.commit()\n            logger.info(f\"Channel sync completed: {results}\")\n            \n        except Exception as e:\n            conn.rollback()\n            logger.error(f\"Channel sync failed: {e}\")\n            raise\n        finally:\n            conn.close()\n        \n        return results\n    \n    def create_default_flow_definitions(self, integrations: List[Dict[str, Any]], \n                                      update_existing: bool = False) -> Dict[str, int]:\n        \"\"\"Create default flow definitions for integrations\"\"\"\n        \n        conn = self.get_database_connection()\n        results = {\n            'flows_created': 0,\n            'flow_defs_created': 0,\n            'skipped': 0,\n            'errors': 0\n        }\n        \n        try:\n            cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)\n            \n            # Get existing channels with their IDs\n            cursor.execute(\"SELECT channel_id, channel_key FROM saas_channel_master\")\n            channels = {row['channel_key']: row['channel_id'] for row in cursor.fetchall()}\n            \n            for integration in integrations:\n                try:\n                    channel_key = integration.get('channel_key', '')\n                    channel_id = channels.get(channel_key)\n                    \n                    if not channel_id:\n                        logger.warning(f\"Channel {channel_key} not found in database, skipping flow definitions\")\n                        results['skipped'] += 1\n                        continue\n                    \n                    # Create flows for each operation\n                    operations = integration.get('capabilities', {}).get('operations', [])\n                    \n                    for operation in operations:\n                        # Create n8n flow template first\n                        flow_name = f\"{integration.get('display_name', '')} {operation.title()}\"\n                        \n                        # Check if n8n flow already exists\n                        cursor.execute(\n                            \"SELECT n8n_flow_id FROM saas_n8n_flows WHERE name = %s AND version = 'v1.0'\",\n                            (flow_name,)\n                        )\n                        existing_flow = cursor.fetchone()\n                        \n                        if existing_flow and not update_existing:\n                            n8n_flow_id = existing_flow['n8n_flow_id']\n                        else:\n                            # Create basic workflow template\n                            workflow_json = self._create_workflow_template(\n                                integration, operation\n                            )\n                            \n                            credentials_schema = {}\n                            for cred in integration.get('credentials', []):\n                                cred_name = cred.get('name', '')\n                                schema = self._create_credential_schema(cred)\n                                if schema:\n                                    credentials_schema[cred_name] = schema\n                            \n                            if existing_flow and update_existing:\n                                # Update existing flow\n                                update_flow_sql = \"\"\"\n                                UPDATE saas_n8n_flows SET\n                                    n8n_workflow_json = %s::jsonb,\n                                    credentials_schema = %s::jsonb,\n                                    default_config = %s::jsonb\n                                WHERE n8n_flow_id = %s\n                                \"\"\"\n                                \n                                cursor.execute(update_flow_sql, (\n                                    json.dumps(workflow_json),\n                                    json.dumps(credentials_schema),\n                                    json.dumps(integration.get('default_config', {})),\n                                    existing_flow['n8n_flow_id']\n                                ))\n                                n8n_flow_id = existing_flow['n8n_flow_id']\n                            else:\n                                # Insert new flow\n                                flow_insert_sql = \"\"\"\n                                INSERT INTO saas_n8n_flows (\n                                    name, version, channel_key, operation, \n                                    n8n_workflow_json, default_config, credentials_schema\n                                ) VALUES (\n                                    %s, 'v1.0', %s, %s, %s::jsonb, %s::jsonb, %s::jsonb\n                                ) RETURNING n8n_flow_id\n                                \"\"\"\n                                \n                                cursor.execute(flow_insert_sql, (\n                                    flow_name,\n                                    channel_key,\n                                    operation,\n                                    json.dumps(workflow_json),\n                                    json.dumps(integration.get('default_config', {})),\n                                    json.dumps(credentials_schema)\n                                ))\n                                \n                                n8n_flow_id = cursor.fetchone()[0]\n                                results['flows_created'] += 1\n                        \n                        # Check if flow definition already exists\n                        cursor.execute(\"\"\"\n                            SELECT flow_def_id FROM saas_channel_master_flow_defs \n                            WHERE channel_id = %s AND operation = %s AND exec_type = 'n8n'\n                        \"\"\", (channel_id, operation))\n                        \n                        existing_def = cursor.fetchone()\n                        \n                        if existing_def and not update_existing:\n                            continue\n                        \n                        # Get default schedule for operation\n                        schedule = self._get_default_schedule(operation)\n                        \n                        default_config = {\n                            'timeout': 30000,\n                            'retry_attempts': 3,\n                            'batch_size': 100,\n                            'operation_metadata': {\n                                'description': f\"Default {operation} operation for {integration.get('display_name', '')}\",\n                                'resources': [r.get('value') for r in integration.get('resources', [])]\n                            }\n                        }\n                        \n                        if existing_def and update_existing:\n                            # Update existing definition\n                            update_def_sql = \"\"\"\n                            UPDATE saas_channel_master_flow_defs SET\n                                n8n_flow_id = %s,\n                                default_schedule_cron = %s,\n                                default_config = %s::jsonb,\n                                updated_at = NOW()\n                            WHERE flow_def_id = %s\n                            \"\"\"\n                            \n                            cursor.execute(update_def_sql, (\n                                n8n_flow_id,\n                                schedule,\n                                json.dumps(default_config),\n                                existing_def['flow_def_id']\n                            ))\n                        else:\n                            # Insert new flow definition\n                            def_insert_sql = \"\"\"\n                            INSERT INTO saas_channel_master_flow_defs (\n                                channel_id, operation, exec_type, n8n_flow_id,\n                                default_schedule_cron, default_config\n                            ) VALUES (\n                                %s, %s, 'n8n', %s, %s, %s::jsonb\n                            )\n                            \"\"\"\n                            \n                            cursor.execute(def_insert_sql, (\n                                channel_id,\n                                operation,\n                                n8n_flow_id,\n                                schedule,\n                                json.dumps(default_config)\n                            ))\n                            \n                            results['flow_defs_created'] += 1\n                        \n                        logger.info(f\"Created flow definition: {channel_key}.{operation}\")\n                        \n                except Exception as e:\n                    logger.error(f\"Error creating flow definitions for {integration.get('display_name', 'unknown')}: {e}\")\n                    results['errors'] += 1\n                    continue\n            \n            conn.commit()\n            logger.info(f\"Flow definition sync completed: {results}\")\n            \n        except Exception as e:\n            conn.rollback()\n            logger.error(f\"Flow definition sync failed: {e}\")\n            raise\n        finally:\n            conn.close()\n        \n        return results\n    \n    def _create_workflow_template(self, integration: Dict[str, Any], operation: str) -> Dict[str, Any]:\n        \"\"\"Create a basic n8n workflow template\"\"\"\n        \n        node_type = integration.get('node_type', '')\n        display_name = integration.get('display_name', '')\n        channel_key = integration.get('channel_key', '').lower()\n        \n        workflow = {\n            \"meta\": {\n                \"instanceId\": f\"template-{channel_key}-{operation}\"\n            },\n            \"nodes\": [\n                {\n                    \"parameters\": {\n                        \"httpMethod\": \"POST\",\n                        \"path\": f\"/{channel_key}/{operation}\",\n                        \"responseMode\": \"onReceived\",\n                        \"options\": {}\n                    },\n                    \"id\": \"webhook-trigger\",\n                    \"name\": \"Webhook Trigger\",\n                    \"type\": \"n8n-nodes-base.webhook\",\n                    \"typeVersion\": 1,\n                    \"position\": [300, 300],\n                    \"webhookId\": f\"{channel_key}-{operation}-webhook\"\n                },\n                {\n                    \"parameters\": {\n                        \"jsCode\": \"// Load credentials dynamically\\nconst saasEdgeId = $json.saas_edge_id;\\nconst channelKey = '\" + channel_key.upper() + \"';\\n\\n// This will be replaced with actual credential lookup\\nreturn { saasEdgeId, channelKey, operation: '\" + operation + \"' };\"\n                    },\n                    \"id\": \"credential-loader\",\n                    \"name\": \"Load Credentials\",\n                    \"type\": \"n8n-nodes-base.code\",\n                    \"typeVersion\": 2,\n                    \"position\": [500, 300]\n                },\n                {\n                    \"parameters\": {\n                        \"operation\": operation,\n                        \"additionalFields\": {\n                            \"timeout\": 30000,\n                            \"retryAttempts\": 3\n                        }\n                    },\n                    \"id\": f\"{node_type}-node\",\n                    \"name\": f\"{display_name} {operation.title()}\",\n                    \"type\": node_type,\n                    \"typeVersion\": integration.get('version', 1),\n                    \"position\": [700, 300]\n                }\n            ],\n            \"connections\": {\n                \"Webhook Trigger\": {\n                    \"main\": [\n                        [\n                            {\n                                \"node\": \"Load Credentials\",\n                                \"type\": \"main\",\n                                \"index\": 0\n                            }\n                        ]\n                    ]\n                },\n                \"Load Credentials\": {\n                    \"main\": [\n                        [\n                            {\n                                \"node\": f\"{display_name} {operation.title()}\",\n                                \"type\": \"main\",\n                                \"index\": 0\n                            }\n                        ]\n                    ]\n                }\n            },\n            \"pinData\": {},\n            \"settings\": {\n                \"executionOrder\": \"v1\"\n            },\n            \"staticData\": {},\n            \"tags\": [\n                {\n                    \"createdAt\": datetime.now().isoformat(),\n                    \"updatedAt\": datetime.now().isoformat(),\n                    \"id\": f\"tag-{channel_key}\",\n                    \"name\": channel_key.upper()\n                }\n            ],\n            \"triggerCount\": 1,\n            \"updatedAt\": datetime.now().isoformat(),\n            \"versionId\": \"1\"\n        }\n        \n        return workflow\n    \n    def _get_default_schedule(self, operation: str) -> Optional[str]:\n        \"\"\"Get default cron schedule for operation\"\"\"\n        schedules = {\n            'get': '*/15 * * * *',      # Every 15 minutes\n            'getAll': '0 */4 * * *',    # Every 4 hours\n            'create': None,              # On-demand\n            'update': '*/30 * * * *',   # Every 30 minutes\n            'delete': None,              # On-demand\n            'sync': '*/10 * * * *',     # Every 10 minutes\n            'import': '0 */6 * * *',    # Every 6 hours\n            'export': '0 2 * * *',      # Daily at 2 AM\n            'post': None,               # On-demand (for messaging)\n            'send': None                # On-demand (for emails)\n        }\n        \n        return schedules.get(operation.lower(), '0 * * * *')  # Default: hourly\n    \n    def validate_database_schema(self) -> bool:\n        \"\"\"Validate that required database tables exist\"\"\"\n        conn = self.get_database_connection()\n        \n        try:\n            cursor = conn.cursor()\n            \n            required_tables = [\n                'saas_channel_master',\n                'saas_n8n_flows',\n                'saas_channel_master_flow_defs',\n                'saas_channel_installations'\n            ]\n            \n            for table in required_tables:\n                cursor.execute(\n                    \"SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = %s)\",\n                    (table,)\n                )\n                exists = cursor.fetchone()[0]\n                \n                if not exists:\n                    logger.error(f\"Required table {table} does not exist\")\n                    return False\n            \n            logger.info(\"Database schema validation passed\")\n            return True\n            \n        except Exception as e:\n            logger.error(f\"Database schema validation failed: {e}\")\n            return False\n        finally:\n            conn.close()\n    \n    def get_sync_summary(self) -> Dict[str, Any]:\n        \"\"\"Get summary of current database state\"\"\"\n        conn = self.get_database_connection()\n        \n        try:\n            cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)\n            \n            # Count channels\n            cursor.execute(\"SELECT COUNT(*) as total FROM saas_channel_master\")\n            total_channels = cursor.fetchone()['total']\n            \n            # Count flows\n            cursor.execute(\"SELECT COUNT(*) as total FROM saas_n8n_flows\")\n            total_flows = cursor.fetchone()['total']\n            \n            # Count flow definitions\n            cursor.execute(\"SELECT COUNT(*) as total FROM saas_channel_master_flow_defs\")\n            total_flow_defs = cursor.fetchone()['total']\n            \n            # Get top categories\n            cursor.execute(\"\"\"\n                SELECT \n                    capabilities->>'category' as category,\n                    COUNT(*) as count\n                FROM saas_channel_master \n                WHERE capabilities->>'category' IS NOT NULL\n                GROUP BY capabilities->>'category'\n                ORDER BY count DESC\n                LIMIT 10\n            \"\"\")\n            top_categories = cursor.fetchall()\n            \n            # Get channels by auth type\n            cursor.execute(\"\"\"\n                SELECT \n                    jsonb_array_elements_text(capabilities->'auth_types') as auth_type,\n                    COUNT(*) as count\n                FROM saas_channel_master \n                WHERE capabilities->'auth_types' IS NOT NULL\n                GROUP BY auth_type\n                ORDER BY count DESC\n            \"\"\")\n            auth_types = cursor.fetchall()\n            \n            return {\n                'total_channels': total_channels,\n                'total_flows': total_flows,\n                'total_flow_definitions': total_flow_defs,\n                'top_categories': [dict(row) for row in top_categories],\n                'auth_types': [dict(row) for row in auth_types],\n                'timestamp': datetime.now().isoformat()\n            }\n            \n        except Exception as e:\n            logger.error(f\"Failed to get sync summary: {e}\")\n            raise\n        finally:\n            conn.close()\n\ndef main():\n    \"\"\"Main execution function\"\"\"\n    parser = argparse.ArgumentParser(description='Sync processed n8n integrations to database')\n    parser.add_argument('processed_file', help='Path to processed integrations JSON file')\n    parser.add_argument('--db-host', default=os.getenv('DB_HOST'), help='Database host')\n    parser.add_argument('--db-port', default=os.getenv('DB_PORT', '5432'), help='Database port')\n    parser.add_argument('--db-name', default=os.getenv('DB_NAME', 'catalog-edge-db'), help='Database name')\n    parser.add_argument('--db-user', default=os.getenv('DB_USER'), help='Database user')\n    parser.add_argument('--db-password', default=os.getenv('DB_PASSWORD'), help='Database password')\n    parser.add_argument('--update', action='store_true', help='Update existing entries')\n    parser.add_argument('--create-flows', action='store_true', help='Create default flow definitions')\n    parser.add_argument('--validate-only', action='store_true', help='Only validate database schema')\n    \n    args = parser.parse_args()\n    \n    # Validate required arguments\n    if not args.validate_only and not os.path.exists(args.processed_file):\n        logger.error(f\"Processed file not found: {args.processed_file}\")\n        return\n    \n    db_config = {\n        'host': args.db_host,\n        'port': int(args.db_port),\n        'database': args.db_name,\n        'user': args.db_user,\n        'password': args.db_password\n    }\n    \n    # Validate database configuration\n    missing_config = [key for key, value in db_config.items() if not value]\n    if missing_config:\n        logger.error(f\"Missing database configuration: {missing_config}\")\n        return\n    \n    try:\n        # Create sync instance\n        sync = IntegrationDatabaseSync(db_config)\n        \n        # Validate database schema\n        if not sync.validate_database_schema():\n            logger.error(\"Database schema validation failed\")\n            return\n        \n        if args.validate_only:\n            logger.info(\"Database schema validation passed\")\n            summary = sync.get_sync_summary()\n            print(\"\\nCurrent Database State:\")\n            print(f\"  Channels: {summary['total_channels']}\")\n            print(f\"  Flows: {summary['total_flows']}\")\n            print(f\"  Flow Definitions: {summary['total_flow_definitions']}\")\n            return\n        \n        # Load processed data\n        integrations = sync.load_processed_data(args.processed_file)\n        \n        # Sync channels\n        logger.info(\"Syncing channels to saas_channel_master...\")\n        channel_results = sync.sync_to_saas_channel_master(integrations, args.update)\n        \n        # Create flow definitions if requested\n        flow_results = {'flows_created': 0, 'flow_defs_created': 0}\n        if args.create_flows:\n            logger.info(\"Creating default flow definitions...\")\n            flow_results = sync.create_default_flow_definitions(integrations, args.update)\n        \n        # Get final summary\n        summary = sync.get_sync_summary()\n        \n        # Print results\n        print(\"\\n\" + \"=\"*60)\n        print(\"DATABASE SYNC COMPLETED\")\n        print(\"=\"*60)\n        print(f\"Channel Results:\")\n        print(f\"  • Inserted: {channel_results['inserted']}\")\n        print(f\"  • Updated: {channel_results['updated']}\")\n        print(f\"  • Skipped: {channel_results['skipped']}\")\n        print(f\"  • Errors: {channel_results['errors']}\")\n        \n        if args.create_flows:\n            print(f\"\\nFlow Results:\")\n            print(f\"  • N8N Flows Created: {flow_results['flows_created']}\")\n            print(f\"  • Flow Definitions Created: {flow_results['flow_defs_created']}\")\n        \n        print(f\"\\nFinal Database State:\")\n        print(f\"  • Total Channels: {summary['total_channels']}\")\n        print(f\"  • Total Flows: {summary['total_flows']}\")\n        print(f\"  • Total Flow Definitions: {summary['total_flow_definitions']}\")\n        \n        if summary['top_categories']:\n            print(f\"\\nTop Categories:\")\n            for cat in summary['top_categories'][:5]:\n                print(f\"  • {cat['category']}: {cat['count']} channels\")\n        \n        print(\"=\"*60)\n        \n    except Exception as e:\n        logger.error(f\"Sync failed: {e}\")\n        raise\n\nif __name__ == \"__main__\":\n    main()
