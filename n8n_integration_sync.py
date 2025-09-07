#!/usr/bin/env python3
"""
N8N Integration Sync Script
============================

This script fetches all available n8n node types (integrations) and transforms them
to match your catalog-edge-db schema for channel management.

Features:
- Fetches n8n node metadata via API
- Transforms to saas_channel_master format
- Creates default flow definitions
- Handles credential schemas
- Multi-tenant ready
"""

import os
import json
import requests
import psycopg2
import psycopg2.extras
from datetime import datetime
from typing import Dict, List, Optional, Any
import logging
from dataclasses import dataclass

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@dataclass
class N8NNodeInfo:
    """Structure for n8n node information"""
    node_type: str
    display_name: str
    description: str
    category: str
    subcategory: Optional[str]
    icon: Optional[str]
    credentials: List[Dict[str, Any]]
    properties: List[Dict[str, Any]]
    defaults: Dict[str, Any]
    version: str

class N8NIntegrationSync:
    """Main class for syncing n8n integrations to catalog-edge-db"""
    
    def __init__(self, n8n_base_url: str, n8n_api_key: str, db_config: Dict[str, str]):
        """Initialize with n8n and database configurations"""
        self.n8n_base_url = n8n_base_url.rstrip('/')
        self.n8n_api_key = n8n_api_key
        self.db_config = db_config
        
        # Configure requests session
        self.session = requests.Session()
        self.session.headers.update({
            'X-N8N-API-KEY': n8n_api_key,
            'Content-Type': 'application/json'
        })
        
        logger.info(f"Initialized N8N Integration Sync for {n8n_base_url}")
    
    def get_database_connection(self):
        """Get database connection"""
        try:
            conn = psycopg2.connect(**self.db_config)
            conn.autocommit = False
            return conn
        except Exception as e:
            logger.error(f"Database connection failed: {e}")
            raise
    
    def fetch_n8n_node_types(self) -> List[Dict[str, Any]]:
        """Fetch all available n8n node types"""
        try:
            response = self.session.get(f"{self.n8n_base_url}/api/v1/nodes")
            response.raise_for_status()
            
            nodes_data = response.json()
            logger.info(f"Fetched {len(nodes_data)} node types from n8n")
            return nodes_data
            
        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to fetch n8n nodes: {e}")
            raise
    
    def parse_node_info(self, node_data: Dict[str, Any]) -> N8NNodeInfo:
        """Parse n8n node data into structured format"""
        node_type = node_data.get('name', '')
        display_name = node_data.get('displayName', node_type)
        description = node_data.get('description', '')
        
        # Extract category information
        category = 'Integration'  # Default category
        subcategory = None
        
        if 'codex' in node_data:
            codex = node_data['codex']
            category = codex.get('categories', ['Integration'])[0]
            subcategory = codex.get('subcategories', [None])[0] if codex.get('subcategories') else None
        
        # Extract icon
        icon = node_data.get('icon')
        if isinstance(icon, dict):
            icon = icon.get('file') or icon.get('fontAwesome')
        
        # Extract credentials
        credentials = node_data.get('credentials', [])
        
        # Extract properties/parameters
        properties = node_data.get('properties', [])
        
        # Create defaults
        defaults = self._extract_default_values(properties)
        
        version = node_data.get('version', '1')
        
        return N8NNodeInfo(
            node_type=node_type,
            display_name=display_name,
            description=description,
            category=category,
            subcategory=subcategory,
            icon=icon,
            credentials=credentials,
            properties=properties,
            defaults=defaults,
            version=str(version)
        )
    
    def _extract_default_values(self, properties: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Extract default values from node properties"""
        defaults = {}
        for prop in properties:
            name = prop.get('name')
            default = prop.get('default')
            if name and default is not None:
                defaults[name] = default
        return defaults
    
    def transform_to_channel_format(self, node_info: N8NNodeInfo) -> Dict[str, Any]:
        """Transform n8n node info to saas_channel_master format"""
        
        # Generate channel key from node type
        channel_key = self._generate_channel_key(node_info.node_type)
        
        # Determine capabilities based on node properties
        capabilities = self._determine_capabilities(node_info)
        
        # Create default configuration
        default_config = {
            'node_type': node_info.node_type,
            'version': node_info.version,
            'defaults': node_info.defaults,
            'timeout': 30000,
            'retry_attempts': 3
        }
        
        # Generate documentation URL
        docs_url = f"https://docs.n8n.io/integrations/builtin/app-nodes/{node_info.node_type.replace('n8n-nodes-base.', '')}/"
        
        return {
            'channel_key': channel_key,
            'channel_name': node_info.display_name,
            'base_url': None,  # Will be filled from node-specific configuration
            'docs_url': docs_url,
            'channel_logo_url': self._generate_icon_url(node_info.icon),
            'default_channel_config': json.dumps(default_config),
            'capabilities': json.dumps(capabilities)
        }
    
    def _generate_channel_key(self, node_type: str) -> str:
        """Generate a channel key from node type"""
        # Remove n8n-nodes-base. prefix and convert to uppercase
        key = node_type.replace('n8n-nodes-base.', '').upper()
        
        # Handle special cases
        special_mappings = {
            'HTTP REQUEST': 'HTTP_REQUEST',
            'WEBHOOK': 'WEBHOOK',
            'GMAIL': 'GMAIL',
            'SLACK': 'SLACK',
            'SHOPIFY': 'SHOPIFY',
            'EBAY': 'EBAY',
            'AMAZON': 'AMAZON',
            'FACEBOOK': 'FACEBOOK',
            'TWITTER': 'TWITTER',
            'OPENAI': 'OPENAI',
            'ANTHROPIC': 'ANTHROPIC'
        }
        
        return special_mappings.get(key, key)
    
    def _determine_capabilities(self, node_info: N8NNodeInfo) -> Dict[str, Any]:
        """Determine capabilities from node properties"""
        capabilities = {
            'supports': [],
            'node_type': node_info.node_type,
            'category': node_info.category,
            'subcategory': node_info.subcategory,
            'auth_types': [],
            'rate_limits': {
                'requests_per_minute': 60,  # Default
                'burst_limit': 120
            },
            'webhooks_supported': False,
            'operations': []
        }
        
        # Analyze properties to determine supported operations
        for prop in node_info.properties:
            prop_name = prop.get('name', '').lower()
            prop_options = prop.get('options', [])
            
            if prop_name in ['operation', 'resource']:
                for option in prop_options:
                    if isinstance(option, dict):
                        operation = option.get('value', '')
                        if operation:
                            capabilities['operations'].append(operation)
                            
                            # Map operations to standard capabilities
                            if operation in ['create', 'insert', 'add']:
                                capabilities['supports'].append('create')
                            elif operation in ['get', 'getAll', 'list', 'search']:
                                capabilities['supports'].append('read')
                            elif operation in ['update', 'modify', 'edit']:
                                capabilities['supports'].append('update')
                            elif operation in ['delete', 'remove']:
                                capabilities['supports'].append('delete')
        
        # Determine auth types from credentials
        for cred in node_info.credentials:
            cred_type = cred.get('name', '').lower()
            if 'oauth' in cred_type:
                capabilities['auth_types'].append('oauth2')
            elif 'api' in cred_type and 'key' in cred_type:
                capabilities['auth_types'].append('api_key')
            elif 'basic' in cred_type or 'username' in cred_type:
                capabilities['auth_types'].append('basic_auth')
            elif 'jwt' in cred_type or 'token' in cred_type:
                capabilities['auth_types'].append('bearer_token')
        
        # Check if webhook-capable
        if node_info.node_type == 'n8n-nodes-base.webhook':
            capabilities['webhooks_supported'] = True
        
        # Remove duplicates
        capabilities['supports'] = list(set(capabilities['supports']))
        capabilities['auth_types'] = list(set(capabilities['auth_types']))
        capabilities['operations'] = list(set(capabilities['operations']))
        
        return capabilities
    
    def _generate_icon_url(self, icon: Optional[str]) -> Optional[str]:
        """Generate icon URL from icon information"""
        if not icon:
            return None
        
        if icon.startswith('http'):
            return icon
        
        # For font awesome icons
        if icon.startswith('fa:'):
            return f"https://fontawesome.com/icons/{icon[3:]}"
        
        # For n8n file icons
        return f"https://raw.githubusercontent.com/n8n-io/n8n/master/packages/nodes-base/nodes/{icon}"
    
    def create_channel_master_entries(self, node_infos: List[N8NNodeInfo]) -> int:
        """Create entries in saas_channel_master table"""
        conn = self.get_database_connection()
        inserted_count = 0
        
        try:
            cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            
            for node_info in node_infos:
                channel_data = self.transform_to_channel_format(node_info)
                
                # Check if channel already exists
                cursor.execute(
                    "SELECT channel_id FROM saas_channel_master WHERE channel_key = %s",
                    (channel_data['channel_key'],)
                )
                
                if cursor.fetchone():
                    logger.info(f"Channel {channel_data['channel_key']} already exists, skipping")
                    continue
                
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
                inserted_count += 1
                logger.info(f"Inserted channel: {channel_data['channel_key']}")
            
            conn.commit()
            logger.info(f"Successfully inserted {inserted_count} new channels")
            
        except Exception as e:
            conn.rollback()
            logger.error(f"Error inserting channels: {e}")
            raise
        finally:
            conn.close()
        
        return inserted_count
    
    def create_default_flow_definitions(self, node_infos: List[N8NNodeInfo]) -> int:
        """Create default flow definitions for popular integrations"""
        conn = self.get_database_connection()
        created_count = 0
        
        try:
            cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            
            # Get existing channels
            cursor.execute("SELECT channel_id, channel_key, capabilities FROM saas_channel_master")
            channels = {row['channel_key']: row for row in cursor.fetchall()}
            
            for node_info in node_infos:
                channel_key = self._generate_channel_key(node_info.node_type)
                
                if channel_key not in channels:
                    continue
                
                channel = channels[channel_key]
                capabilities = json.loads(channel['capabilities'])
                
                # Create flow definitions for each supported operation
                for operation in capabilities.get('operations', []):
                    # Check if flow definition already exists
                    cursor.execute("""
                        SELECT flow_def_id FROM saas_channel_master_flow_defs 
                        WHERE channel_id = %s AND operation = %s AND exec_type = 'n8n'
                    """, (channel['channel_id'], operation))
                    
                    if cursor.fetchone():
                        continue
                    
                    # Create basic n8n workflow template
                    workflow_json = self._create_basic_workflow_template(node_info, operation)
                    
                    # Insert n8n flow first
                    flow_insert_sql = """
                    INSERT INTO saas_n8n_flows (
                        name, version, channel_key, operation, 
                        n8n_workflow_json, default_config, credentials_schema
                    ) VALUES (
                        %s, %s, %s, %s, %s::jsonb, %s::jsonb, %s::jsonb
                    ) RETURNING n8n_flow_id
                    """
                    
                    flow_name = f"{node_info.display_name} {operation.title()}"
                    credentials_schema = self._create_credentials_schema(node_info)
                    
                    cursor.execute(flow_insert_sql, (
                        flow_name, 'v1.0', channel_key, operation,
                        json.dumps(workflow_json),
                        json.dumps(node_info.defaults),
                        json.dumps(credentials_schema)
                    ))
                    
                    n8n_flow_id = cursor.fetchone()[0]
                    
                    # Create flow definition
                    def_insert_sql = """
                    INSERT INTO saas_channel_master_flow_defs (
                        channel_id, operation, exec_type, n8n_flow_id,
                        default_schedule_cron, default_config
                    ) VALUES (
                        %s, %s, 'n8n', %s, %s, %s::jsonb
                    )
                    """
                    
                    schedule = self._get_default_schedule(operation)
                    default_config = {
                        'timeout': 30000,
                        'retry_attempts': 3,
                        'batch_size': 100
                    }
                    
                    cursor.execute(def_insert_sql, (
                        channel['channel_id'], operation, n8n_flow_id,
                        schedule, json.dumps(default_config)
                    ))
                    
                    created_count += 1
                    logger.info(f"Created flow definition: {channel_key}.{operation}")
            
            conn.commit()
            logger.info(f"Created {created_count} flow definitions")
            
        except Exception as e:
            conn.rollback()
            logger.error(f"Error creating flow definitions: {e}")
            raise
        finally:
            conn.close()
        
        return created_count
    
    def _create_basic_workflow_template(self, node_info: N8NNodeInfo, operation: str) -> Dict[str, Any]:
        """Create a basic n8n workflow template"""
        return {
            "nodes": [
                {
                    "parameters": {
                        "httpMethod": "POST",
                        "path": f"/{node_info.node_type.replace('n8n-nodes-base.', '')}/{operation}",
                        "responseMode": "onReceived",
                        "options": {}
                    },
                    "id": "webhook-trigger",
                    "name": "Webhook Trigger",
                    "type": "n8n-nodes-base.webhook",
                    "typeVersion": 1,
                    "position": [300, 300]
                },
                {
                    "parameters": {
                        "operation": operation,
                        **node_info.defaults
                    },
                    "id": f"{node_info.node_type}-node",
                    "name": node_info.display_name,
                    "type": node_info.node_type,
                    "typeVersion": int(node_info.version),
                    "position": [600, 300]
                }
            ],
            "connections": {
                "Webhook Trigger": {
                    "main": [[{
                        "node": node_info.display_name,
                        "type": "main",
                        "index": 0
                    }]]
                }
            }
        }
    
    def _create_credentials_schema(self, node_info: N8NNodeInfo) -> Dict[str, Any]:
        """Create credentials schema from node credentials"""
        schema = {
            "type": "object",
            "properties": {},
            "required": []
        }
        
        for cred in node_info.credentials:
            cred_name = cred.get('name', '')
            display_name = cred.get('displayName', cred_name)
            
            schema['properties'][cred_name] = {
                "type": "string",
                "description": f"{display_name} credentials",
                "format": "password" if "secret" in cred_name.lower() or "password" in cred_name.lower() else "text"
            }
            schema['required'].append(cred_name)
        
        return schema
    
    def _get_default_schedule(self, operation: str) -> str:
        """Get default cron schedule for operation"""
        schedules = {
            'get': '*/15 * * * *',      # Every 15 minutes
            'getAll': '0 */4 * * *',    # Every 4 hours
            'create': None,              # On-demand
            'update': '*/30 * * * *',   # Every 30 minutes
            'delete': None,              # On-demand
            'sync': '*/10 * * * *',     # Every 10 minutes
            'import': '0 */6 * * *',    # Every 6 hours
            'export': '0 2 * * *'       # Daily at 2 AM
        }
        
        return schedules.get(operation.lower(), '0 * * * *')  # Default: hourly
    
    def run_sync(self, filter_categories: Optional[List[str]] = None) -> Dict[str, int]:
        """Run the complete sync process"""
        logger.info("Starting n8n integration sync...")
        
        # Fetch node types
        raw_nodes = self.fetch_n8n_node_types()
        
        # Parse node information
        node_infos = []
        for node_data in raw_nodes:
            try:
                node_info = self.parse_node_info(node_data)
                
                # Filter by categories if specified
                if filter_categories and node_info.category not in filter_categories:
                    continue
                
                # Skip utility nodes
                if node_info.node_type.startswith('n8n-nodes-base.') and node_info.category not in ['Integration', 'App']:
                    continue
                
                node_infos.append(node_info)
                
            except Exception as e:
                logger.warning(f"Failed to parse node {node_data.get('name', 'unknown')}: {e}")
        
        logger.info(f"Parsed {len(node_infos)} integration nodes")
        
        # Sync to database
        channels_created = self.create_channel_master_entries(node_infos)
        flows_created = self.create_default_flow_definitions(node_infos)
        
        results = {
            'nodes_processed': len(node_infos),
            'channels_created': channels_created,
            'flows_created': flows_created
        }
        
        logger.info(f"Sync completed: {results}")
        return results

def main():
    """Main execution function"""
    # Configuration from environment variables
    n8n_config = {
        'base_url': os.getenv('N8N_BASE_URL', 'http://localhost:5678'),
        'api_key': os.getenv('N8N_API_KEY', '')
    }
    
    db_config = {
        'host': os.getenv('DB_HOST', 'localhost'),
        'port': int(os.getenv('DB_PORT', '5432')),
        'database': os.getenv('DB_NAME', 'catalog-edge-db'),
        'user': os.getenv('DB_USER', 'postgres'),
        'password': os.getenv('DB_PASSWORD', '')
    }
    
    # Validate configuration
    if not n8n_config['api_key']:
        logger.error("N8N_API_KEY environment variable is required")
        return
    
    if not db_config['password']:
        logger.error("DB_PASSWORD environment variable is required")
        return
    
    try:
        # Create sync instance
        sync = N8NIntegrationSync(
            n8n_base_url=n8n_config['base_url'],
            n8n_api_key=n8n_config['api_key'],
            db_config=db_config
        )
        
        # Filter to integration categories only
        filter_categories = ['Integration', 'App', 'Communication', 'Sales', 'Marketing']
        
        # Run sync
        results = sync.run_sync(filter_categories=filter_categories)
        
        print("\n" + "="*60)
        print("N8N INTEGRATION SYNC COMPLETED")
        print("="*60)
        print(f"Nodes Processed: {results['nodes_processed']}")
        print(f"Channels Created: {results['channels_created']}")
        print(f"Flow Definitions Created: {results['flows_created']}")
        print("="*60)
        
    except Exception as e:
        logger.error(f"Sync failed: {e}")
        raise

if __name__ == "__main__":
    main()
