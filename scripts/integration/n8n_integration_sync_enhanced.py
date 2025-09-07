#!/usr/bin/env python3
"""
N8N Integration Sync - Enhanced Version
======================================

Complete integration sync system to fetch N8N integrations from your self-hosted 
instance, transform them with logos and metadata, and sync to catalog-edge-db.

Features:
- Direct N8N API integration with spinner.saastify.ai
- Complete metadata extraction with logos and credentials  
- Channel master database synchronization
- Multi-tenant support with dynamic expressions
- Comprehensive error handling and logging

Usage:
    python n8n_integration_sync_enhanced.py sync --n8n-url https://spinner.saastify.ai --api-key YOUR_KEY
    python n8n_integration_sync_enhanced.py validate --dry-run
    python n8n_integration_sync_enhanced.py status
"""

import os
import json
import requests
import psycopg2
import psycopg2.extras
import logging
import argparse
import re
from datetime import datetime
from typing import Dict, List, Optional, Any, Union
from urllib.parse import urljoin, urlparse
import time
from dataclasses import dataclass, asdict

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@dataclass
class ChannelData:
    """Data structure for channel information"""
    channel_key: str
    channel_name: str
    base_url: Optional[str]
    docs_url: Optional[str]
    channel_logo_url: Optional[str]
    default_channel_config: Dict[str, Any]
    capabilities: Dict[str, Any]
    auth_methods: List[str]
    credential_schema: Optional[Dict[str, Any]]

@dataclass
class SyncResult:
    """Sync operation results"""
    total_fetched: int = 0
    total_transformed: int = 0
    inserted: int = 0
    updated: int = 0
    skipped: int = 0
    errors: int = 0
    error_messages: List[str] = None
    
    def __post_init__(self):
        if self.error_messages is None:
            self.error_messages = []

class N8NIntegrationSyncEnhanced:
    """Enhanced N8N integration synchronization system"""
    
    # Logo URL mapping for popular services
    LOGO_URL_MAPPING = {
        'slack': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/slack.svg',
        'shopify': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/shopify.svg',
        'github': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/github.svg',
        'gmail': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/gmail.svg',
        'discord': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/discord.svg',
        'stripe': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/stripe.svg',
        'hubspot': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/hubspot.svg',
        'salesforce': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/salesforce.svg',
        'twitter': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/twitter.svg',
        'linkedin': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/linkedin.svg',
        'facebook': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/facebook.svg',
        'google': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
        'microsoft': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/microsoft.svg',
        'openai': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/openai.svg',
        'youtube': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/youtube.svg',
        'pinterest': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/pinterest.svg',
        'reddit': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/reddit.svg',
        'trello': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/trello.svg',
        'notion': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/notion.svg',
        'airtable': 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/airtable.svg',
    }
    
    # Service categorization mapping
    CATEGORY_MAPPING = {
        # Communication
        'slack': ('Communication', 'Team Chat'),
        'discord': ('Communication', 'Team Chat'),
        'telegram': ('Communication', 'Messaging'),
        'teams': ('Communication', 'Team Chat'),
        'gmail': ('Communication', 'Email'),
        'outlook': ('Communication', 'Email'),
        'sendgrid': ('Communication', 'Email'),
        'twilio': ('Communication', 'SMS/Voice'),
        
        # Sales & E-commerce
        'shopify': ('Sales', 'E-Commerce'),
        'stripe': ('Sales', 'Payment Processing'),
        'woocommerce': ('Sales', 'E-Commerce'),
        'paypal': ('Sales', 'Payment Processing'),
        'square': ('Sales', 'Payment Processing'),
        'quickbooks': ('Sales', 'Accounting'),
        'xero': ('Sales', 'Accounting'),
        'ebay': ('Sales', 'E-Commerce'),
        'amazon': ('Sales', 'E-Commerce'),
        
        # Marketing & CRM
        'hubspot': ('Marketing', 'CRM'),
        'salesforce': ('Marketing', 'CRM'),
        'pipedrive': ('Marketing', 'CRM'),
        'mailchimp': ('Marketing', 'Email Marketing'),
        'intercom': ('Marketing', 'Customer Support'),
        'zendesk': ('Marketing', 'Customer Support'),
        'typeform': ('Marketing', 'Forms'),
        'calendly': ('Marketing', 'Scheduling'),
        
        # Productivity
        'google': ('Productivity', 'Google Workspace'),
        'microsoft': ('Productivity', 'Microsoft 365'),
        'notion': ('Productivity', 'Knowledge Management'),
        'airtable': ('Productivity', 'Database'),
        'trello': ('Productivity', 'Project Management'),
        'asana': ('Productivity', 'Project Management'),
        'monday': ('Productivity', 'Project Management'),
        'dropbox': ('Productivity', 'File Storage'),
        'googledrive': ('Productivity', 'File Storage'),
        
        # Social Media
        'twitter': ('Social Media', 'Social Networking'),
        'linkedin': ('Social Media', 'Professional Networking'),
        'facebook': ('Social Media', 'Social Networking'),
        'instagram': ('Social Media', 'Social Networking'),
        'youtube': ('Social Media', 'Video Platform'),
        'pinterest': ('Social Media', 'Visual Platform'),
        'reddit': ('Social Media', 'Forum'),
        
        # AI & Machine Learning
        'openai': ('AI', 'Language Models'),
        'anthropic': ('AI', 'Language Models'),
        'huggingface': ('AI', 'Machine Learning'),
        'replicate': ('AI', 'Machine Learning'),
        
        # Development
        'github': ('Development', 'Version Control'),
        'gitlab': ('Development', 'Version Control'),
        'jira': ('Development', 'Issue Tracking'),
        'jenkins': ('Development', 'CI/CD'),
        'aws': ('Development', 'Cloud Infrastructure'),
        'googlecloud': ('Development', 'Cloud Infrastructure'),
        'azure': ('Development', 'Cloud Infrastructure'),
        
        # Analytics
        'googleanalytics': ('Analytics', 'Web Analytics'),
        'mixpanel': ('Analytics', 'Product Analytics'),
        'segment': ('Analytics', 'Customer Data Platform'),
    }
    
    # Base URL mapping for services
    BASE_URL_MAPPING = {
        'slack': 'https://slack.com/api',
        'shopify': 'https://admin.shopify.com/admin/api',
        'github': 'https://api.github.com',
        'stripe': 'https://api.stripe.com',
        'hubspot': 'https://api.hubapi.com',
        'salesforce': 'https://login.salesforce.com',
        'google': 'https://www.googleapis.com',
        'microsoft': 'https://graph.microsoft.com',
        'twitter': 'https://api.twitter.com',
        'linkedin': 'https://api.linkedin.com',
        'facebook': 'https://graph.facebook.com',
        'openai': 'https://api.openai.com',
    }
    
    def __init__(self, db_config: Dict[str, str], n8n_config: Optional[Dict[str, str]] = None):
        """Initialize the sync system"""
        self.db_config = db_config
        self.n8n_config = n8n_config or {}
        
        # Initialize HTTP session for N8N API
        self.session = requests.Session()
        if n8n_config and n8n_config.get('api_key'):
            self.session.headers.update({
                'X-N8N-API-KEY': n8n_config['api_key'],
                'Content-Type': 'application/json'
            })
        
        logger.info("N8N Integration Sync Enhanced initialized")
    
    def get_database_connection(self):
        """Get database connection with proper configuration"""
        try:
            conn = psycopg2.connect(**self.db_config)
            conn.autocommit = False
            return conn
        except Exception as e:
            logger.error(f"Database connection failed: {e}")
            raise
    
    def fetch_n8n_integrations(self) -> List[Dict[str, Any]]:
        """Fetch all integrations from N8N instance"""
        if not self.n8n_config.get('base_url'):
            logger.warning("No N8N URL configured, using fallback data")
            return self._get_fallback_integrations()
        
        try:
            url = f"{self.n8n_config['base_url'].rstrip('/')}/api/v1/node-types"
            logger.info(f"Fetching integrations from {url}")
            
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            
            integrations = response.json()
            logger.info(f"Successfully fetched {len(integrations)} integrations from N8N")
            return integrations
            
        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to fetch from N8N API: {e}")
            logger.info("Using fallback integration data")
            return self._get_fallback_integrations()
    
    def _get_fallback_integrations(self) -> List[Dict[str, Any]]:
        """Get fallback integration data from COMPLETE_N8N_INTEGRATIONS_200.json"""
        try:
            fallback_file = os.path.join(os.path.dirname(__file__), '../../COMPLETE_N8N_INTEGRATIONS_200.json')
            if not os.path.exists(fallback_file):
                fallback_file = 'COMPLETE_N8N_INTEGRATIONS_200.json'
            
            with open(fallback_file, 'r') as f:
                data = json.load(f)
            
            # Convert the simplified format to N8N node format
            integrations = []
            for item in data.get('integrations', []):
                node_data = {
                    'name': item['node_type'],
                    'displayName': item['display_name'],
                    'description': f"{item['display_name']} integration for {item['category']}",
                    'version': 1,
                    'defaults': {'name': item['display_name']},
                    'codex': {
                        'categories': [item['category']],
                        'subcategories': {item['category']: [item['subcategory']]}
                    },
                    'credentials': [{
                        'name': f"{item['display_name'].lower().replace(' ', '')}Api",
                        'displayName': f"{item['display_name']} API",
                        'properties': self._generate_credential_properties(item['auth_type'])
                    }]
                }
                integrations.append(node_data)
            
            logger.info(f"Loaded {len(integrations)} integrations from fallback data")
            return integrations
            
        except Exception as e:
            logger.error(f"Failed to load fallback data: {e}")
            return []
    
    def _generate_credential_properties(self, auth_type: str) -> List[Dict[str, Any]]:
        """Generate credential properties based on auth type"""
        if auth_type == 'oauth2':
            return [
                {'name': 'clientId', 'displayName': 'Client ID', 'type': 'string', 'required': True},
                {'name': 'clientSecret', 'displayName': 'Client Secret', 'type': 'string', 'required': True, 'typeOptions': {'password': True}},
                {'name': 'accessToken', 'displayName': 'Access Token', 'type': 'string', 'required': True, 'typeOptions': {'password': True}}
            ]
        elif auth_type == 'api_key':
            return [
                {'name': 'apiKey', 'displayName': 'API Key', 'type': 'string', 'required': True, 'typeOptions': {'password': True}}
            ]
        elif auth_type == 'username_password':
            return [
                {'name': 'username', 'displayName': 'Username', 'type': 'string', 'required': True},
                {'name': 'password', 'displayName': 'Password', 'type': 'string', 'required': True, 'typeOptions': {'password': True}}
            ]
        else:
            return [
                {'name': 'credentials', 'displayName': 'Credentials', 'type': 'string', 'required': True, 'typeOptions': {'password': True}}
            ]
    
    def transform_integration_to_channel(self, integration: Dict[str, Any]) -> Optional[ChannelData]:
        """Transform N8N integration data to channel master format"""
        try:
            # Extract basic info
            node_name = integration.get('name', '')
            display_name = integration.get('displayName', '')
            description = integration.get('description', '')
            
            if not node_name or not display_name:
                logger.warning(f"Skipping integration with missing name or display name")
                return None
            
            # Generate channel_key from node name
            channel_key = self._generate_channel_key(node_name)
            if not channel_key:
                return None
            
            # Extract category and subcategory
            category, subcategory = self._categorize_integration(node_name, integration)
            
            # Generate logo URL
            logo_url = self._generate_logo_url(node_name, channel_key)
            
            # Generate base URL and docs URL
            base_url = self._generate_base_url(node_name, channel_key)
            docs_url = self._generate_docs_url(node_name, integration)
            
            # Extract credentials and build schema
            credentials = integration.get('credentials', [])
            auth_methods = self._extract_auth_methods(credentials)
            credential_schema = self._build_credential_schema(credentials)
            
            # Build capabilities
            capabilities = self._build_capabilities(integration, category, subcategory)
            
            # Build default config
            default_config = {
                'category': category,
                'subcategory': subcategory,
                'description': description,
                'node_name': node_name,
                'version': integration.get('version', 1),
                'supports_webhook': self._supports_webhook(integration),
                'rate_limits': self._extract_rate_limits(integration)
            }
            
            return ChannelData(
                channel_key=channel_key,
                channel_name=display_name,
                base_url=base_url,
                docs_url=docs_url,
                channel_logo_url=logo_url,
                default_channel_config=default_config,
                capabilities=capabilities,
                auth_methods=auth_methods,
                credential_schema=credential_schema
            )
            
        except Exception as e:
            logger.error(f"Error transforming integration {integration.get('name', 'unknown')}: {e}")
            return None
    
    def _generate_channel_key(self, node_name: str) -> Optional[str]:
        """Generate channel key from node name"""
        if not node_name.startswith('n8n-nodes-base.'):
            return None
        
        # Extract the service name
        service_name = node_name.replace('n8n-nodes-base.', '')
        
        # Convert to uppercase and handle special cases
        channel_key = service_name.upper()
        
        # Handle special mappings
        special_mappings = {
            'GOOGLEDRIVE': 'GOOGLE_DRIVE',
            'GOOGLESHEETS': 'GOOGLE_SHEETS',
            'GOOGLEDOCS': 'GOOGLE_DOCS',
            'GOOGLECALENDAR': 'GOOGLE_CALENDAR',
            'GOOGLEANALYTICS': 'GOOGLE_ANALYTICS',
            'MICROSOFTTEAMS': 'MICROSOFT_TEAMS',
            'MICROSOFTOUTLOOK': 'MICROSOFT_OUTLOOK',
            'MICROSOFTONEDRIVE': 'MICROSOFT_ONEDRIVE',
            'MICROSOFTEXCEL': 'MICROSOFT_EXCEL',
            'ACTIVECAMPAIGN': 'ACTIVE_CAMPAIGN',
            'CONSTANTCONTACT': 'CONSTANT_CONTACT',
            'CAMPAIGNMONITOR': 'CAMPAIGN_MONITOR',
        }
        
        return special_mappings.get(channel_key, channel_key)
    
    def _categorize_integration(self, node_name: str, integration: Dict[str, Any]) -> tuple[str, str]:
        """Categorize integration based on node name and metadata"""
        # Extract service name
        service_name = node_name.replace('n8n-nodes-base.', '').lower()
        
        # Check predefined mappings
        for key, (category, subcategory) in self.CATEGORY_MAPPING.items():
            if key in service_name:
                return category, subcategory
        
        # Check codex information
        codex = integration.get('codex', {})
        categories = codex.get('categories', [])
        if categories:
            main_category = categories[0]
            subcategories = codex.get('subcategories', {}).get(main_category, [])
            subcategory = subcategories[0] if subcategories else 'General'
            return main_category, subcategory
        
        # Default fallback
        return 'Integration', 'General'
    
    def _generate_logo_url(self, node_name: str, channel_key: str) -> Optional[str]:
        """Generate logo URL for the integration"""
        service_name = node_name.replace('n8n-nodes-base.', '').lower()
        
        # Check predefined logo mappings
        for key, logo_url in self.LOGO_URL_MAPPING.items():
            if key in service_name:
                return logo_url
        
        # Generate CDN URL for common services
        return f"https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/{service_name}.svg"
    
    def _generate_base_url(self, node_name: str, channel_key: str) -> Optional[str]:
        """Generate base API URL for the service"""
        service_name = node_name.replace('n8n-nodes-base.', '').lower()
        
        # Check predefined mappings
        for key, base_url in self.BASE_URL_MAPPING.items():
            if key in service_name:
                return base_url
        
        return None
    
    def _generate_docs_url(self, node_name: str, integration: Dict[str, Any]) -> Optional[str]:
        """Generate documentation URL"""
        # Check for existing documentation URL in codex
        codex = integration.get('codex', {})
        resources = codex.get('resources', {})
        primary_docs = resources.get('primaryDocumentation', [])
        
        if primary_docs and isinstance(primary_docs, list) and len(primary_docs) > 0:
            return primary_docs[0].get('url')
        
        # Generate N8N docs URL
        service_name = node_name.replace('n8n-nodes-base.', '')
        return f"https://docs.n8n.io/integrations/builtin/app-nodes/{node_name}/"
    
    def _extract_auth_methods(self, credentials: List[Dict[str, Any]]) -> List[str]:
        """Extract authentication methods from credentials"""
        auth_methods = []
        
        for cred in credentials:
            properties = cred.get('properties', [])
            
            # Detect OAuth2
            if any('oauth' in prop.get('name', '').lower() or 
                   'client' in prop.get('name', '').lower() for prop in properties):
                auth_methods.append('oauth2')
            
            # Detect API Key
            elif any('api' in prop.get('name', '').lower() and 
                    'key' in prop.get('name', '').lower() for prop in properties):
                auth_methods.append('api_key')
            
            # Detect Basic Auth
            elif any('username' in prop.get('name', '').lower() or 
                    'password' in prop.get('name', '').lower() for prop in properties):
                auth_methods.append('basic_auth')
        
        return list(set(auth_methods)) if auth_methods else ['api_key']
    
    def _build_credential_schema(self, credentials: List[Dict[str, Any]]) -> Optional[Dict[str, Any]]:
        """Build JSON schema for credentials"""
        if not credentials:
            return None
        
        schema = {
            'type': 'object',
            'properties': {},
            'required': [],
            'additionalProperties': False
        }
        
        for cred in credentials:
            cred_name = cred.get('name', 'default')
            properties = cred.get('properties', [])
            
            cred_schema = {
                'type': 'object',
                'properties': {},
                'required': [],
                'description': cred.get('displayName', cred_name)
            }
            
            for prop in properties:
                prop_name = prop.get('name', '')
                if not prop_name:
                    continue
                
                prop_schema = {
                    'type': 'string',
                    'description': prop.get('displayName', prop_name),
                }
                
                # Handle password fields
                if prop.get('typeOptions', {}).get('password'):
                    prop_schema['format'] = 'password'
                
                # Handle default values
                if 'default' in prop:
                    prop_schema['default'] = prop['default']
                
                cred_schema['properties'][prop_name] = prop_schema
                
                # Mark required fields
                if prop.get('required', False):
                    cred_schema['required'].append(prop_name)
            
            schema['properties'][cred_name] = cred_schema
        
        return schema
    
    def _build_capabilities(self, integration: Dict[str, Any], category: str, subcategory: str) -> Dict[str, Any]:
        """Build capabilities object for the integration"""
        capabilities = {
            'category': category,
            'subcategory': subcategory,
            'supported_operations': [],
            'supported_resources': [],
            'features': []
        }
        
        # Extract operations from properties
        properties = integration.get('properties', [])
        for prop in properties:
            if prop.get('name') == 'operation':
                options = prop.get('options', [])
                capabilities['supported_operations'] = [
                    {'name': opt.get('name', ''), 'value': opt.get('value', ''), 'description': opt.get('description', '')}
                    for opt in options
                ]
            elif prop.get('name') == 'resource':
                options = prop.get('options', [])
                capabilities['supported_resources'] = [
                    {'name': opt.get('name', ''), 'value': opt.get('value', '')}
                    for opt in options
                ]
        
        # Add common features based on category
        if category == 'Communication':
            capabilities['features'].extend(['messaging', 'notifications'])
        elif category == 'Sales':
            capabilities['features'].extend(['transactions', 'inventory'])
        elif category == 'Marketing':
            capabilities['features'].extend(['campaigns', 'analytics'])
        elif category == 'Productivity':
            capabilities['features'].extend(['collaboration', 'automation'])
        
        return capabilities
    
    def _supports_webhook(self, integration: Dict[str, Any]) -> bool:
        """Check if integration supports webhooks"""
        # Simple heuristic - check if webhook is mentioned in properties
        properties = integration.get('properties', [])
        return any('webhook' in str(prop).lower() for prop in properties)
    
    def _extract_rate_limits(self, integration: Dict[str, Any]) -> Dict[str, Any]:
        """Extract rate limiting information"""
        # Default rate limits based on service type
        return {
            'requests_per_minute': 100,
            'burst_limit': 200,
            'daily_limit': 10000
        }
    
    def sync_to_database(self, channels: List[ChannelData], update_existing: bool = False) -> SyncResult:
        """Sync channel data to database"""
        result = SyncResult()
        result.total_transformed = len(channels)
        
        conn = self.get_database_connection()
        
        try:
            cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            
            for channel in channels:
                try:
                    # Check if channel exists
                    cursor.execute(
                        "SELECT channel_id, updated_at FROM saas_channel_master WHERE channel_key = %s",
                        (channel.channel_key,)
                    )
                    existing = cursor.fetchone()
                    
                    if existing:
                        if update_existing:
                            # Update existing
                            update_sql = """
                            UPDATE saas_channel_master SET
                                channel_name = %s,
                                base_url = %s,
                                docs_url = %s,
                                channel_logo_url = %s,
                                default_channel_config = %s::jsonb,
                                capabilities = %s::jsonb,
                                updated_at = NOW()
                            WHERE channel_key = %s
                            """
                            
                            cursor.execute(update_sql, (
                                channel.channel_name,
                                channel.base_url,
                                channel.docs_url,
                                channel.channel_logo_url,
                                json.dumps(channel.default_channel_config),
                                json.dumps(channel.capabilities),
                                channel.channel_key
                            ))
                            result.updated += 1
                            logger.info(f"Updated channel: {channel.channel_key}")
                        else:
                            result.skipped += 1
                            logger.debug(f"Skipped existing channel: {channel.channel_key}")
                    else:
                        # Insert new channel
                        insert_sql = """
                        INSERT INTO saas_channel_master (
                            channel_key, channel_name, base_url, docs_url,
                            channel_logo_url, default_channel_config, capabilities
                        ) VALUES (
                            %s, %s, %s, %s, %s, %s::jsonb, %s::jsonb
                        )
                        """
                        
                        cursor.execute(insert_sql, (
                            channel.channel_key,
                            channel.channel_name,
                            channel.base_url,
                            channel.docs_url,
                            channel.channel_logo_url,
                            json.dumps(channel.default_channel_config),
                            json.dumps(channel.capabilities)
                        ))
                        result.inserted += 1
                        logger.info(f"Inserted new channel: {channel.channel_key}")
                
                except Exception as e:
                    error_msg = f"Error processing channel {channel.channel_key}: {e}"
                    logger.error(error_msg)
                    result.errors += 1
                    result.error_messages.append(error_msg)
            
            conn.commit()
            logger.info(f"Database sync completed: {asdict(result)}")
            
        except Exception as e:
            conn.rollback()
            error_msg = f"Database sync failed: {e}"
            logger.error(error_msg)
            result.error_messages.append(error_msg)
            raise
        finally:
            conn.close()
        
        return result
    
    def validate_database_schema(self) -> bool:
        """Validate database schema"""
        required_tables = [
            'saas_channel_master',
            'saas_n8n_flows',
            'saas_channel_master_flow_defs',
            'saas_channel_installations'
        ]
        
        conn = self.get_database_connection()
        try:
            cursor = conn.cursor()
            
            for table in required_tables:
                cursor.execute(
                    "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = %s)",
                    (table,)
                )
                if not cursor.fetchone()[0]:
                    logger.error(f"Required table {table} does not exist")
                    return False
            
            logger.info("Database schema validation passed")
            return True
            
        except Exception as e:
            logger.error(f"Database schema validation failed: {e}")
            return False
        finally:
            conn.close()
    
    def get_sync_status(self) -> Dict[str, Any]:
        """Get current sync status from database"""
        conn = self.get_database_connection()
        try:
            cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            
            # Count channels by category
            cursor.execute("""
                SELECT 
                    capabilities->>'category' as category,
                    COUNT(*) as count
                FROM saas_channel_master 
                WHERE capabilities->>'category' IS NOT NULL
                GROUP BY capabilities->>'category'
                ORDER BY count DESC
            """)
            categories = cursor.fetchall()
            
            # Get total count
            cursor.execute("SELECT COUNT(*) as total FROM saas_channel_master")
            total = cursor.fetchone()['total']
            
            # Get recent additions
            cursor.execute("""
                SELECT channel_key, channel_name, created_at
                FROM saas_channel_master 
                ORDER BY created_at DESC 
                LIMIT 10
            """)
            recent = cursor.fetchall()
            
            return {
                'total_channels': total,
                'categories': [dict(cat) for cat in categories],
                'recent_additions': [dict(rec) for rec in recent],
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Failed to get sync status: {e}")
            return {'error': str(e)}
        finally:
            conn.close()
    
    def full_sync(self, update_existing: bool = False) -> SyncResult:
        """Perform full synchronization"""
        logger.info("Starting full integration sync...")
        
        result = SyncResult()
        
        try:
            # Step 1: Fetch integrations
            logger.info("Step 1: Fetching integrations from N8N...")
            integrations = self.fetch_n8n_integrations()
            result.total_fetched = len(integrations)
            
            if not integrations:
                logger.warning("No integrations fetched")
                return result
            
            # Step 2: Transform integrations
            logger.info("Step 2: Transforming integrations to channel format...")
            channels = []
            for integration in integrations:
                channel = self.transform_integration_to_channel(integration)
                if channel:
                    channels.append(channel)
            
            logger.info(f"Successfully transformed {len(channels)} integrations")
            
            # Step 3: Sync to database
            logger.info("Step 3: Syncing to database...")
            sync_result = self.sync_to_database(channels, update_existing)
            
            # Merge results
            result.total_transformed = sync_result.total_transformed
            result.inserted = sync_result.inserted
            result.updated = sync_result.updated
            result.skipped = sync_result.skipped
            result.errors = sync_result.errors
            result.error_messages.extend(sync_result.error_messages)
            
            logger.info(f"Full sync completed: {asdict(result)}")
            return result
            
        except Exception as e:
            error_msg = f"Full sync failed: {e}"
            logger.error(error_msg)
            result.error_messages.append(error_msg)
            result.errors += 1
            return result

def create_db_config() -> Dict[str, str]:
    """Create database configuration from environment variables"""
    return {
        'host': os.getenv('DB_HOST', 'localhost'),
        'port': int(os.getenv('DB_PORT', '5432')),
        'database': os.getenv('DB_NAME', 'catalog-edge-db'),
        'user': os.getenv('DB_USER', 'postgres'),
        'password': os.getenv('DB_PASSWORD', '')
    }

def create_n8n_config() -> Dict[str, str]:
    """Create N8N configuration from environment variables"""
    return {
        'base_url': os.getenv('N8N_BASE_URL', 'https://spinner.saastify.ai'),
        'api_key': os.getenv('N8N_API_KEY', '')
    }

def print_results(result: SyncResult):
    """Print formatted sync results"""
    print("\n" + "="*60)
    print("N8N INTEGRATION SYNC RESULTS")
    print("="*60)
    print(f"Fetched from N8N:     {result.total_fetched}")
    print(f"Successfully transformed: {result.total_transformed}")
    print(f"Inserted new:         {result.inserted}")
    print(f"Updated existing:     {result.updated}")
    print(f"Skipped:             {result.skipped}")
    print(f"Errors:              {result.errors}")
    
    if result.error_messages:
        print("\nError Messages:")
        for i, error in enumerate(result.error_messages[:5], 1):
            print(f"  {i}. {error}")
        if len(result.error_messages) > 5:
            print(f"  ... and {len(result.error_messages) - 5} more errors")
    
    print("="*60)

def main():
    """Main CLI interface"""
    parser = argparse.ArgumentParser(
        description='N8N Integration Sync - Enhanced Version',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Full sync with your N8N instance
  python n8n_integration_sync_enhanced.py sync --n8n-url https://spinner.saastify.ai --api-key YOUR_KEY
  
  # Dry run to see what would be synced
  python n8n_integration_sync_enhanced.py sync --dry-run
  
  # Update existing entries
  python n8n_integration_sync_enhanced.py sync --update
  
  # Check database status
  python n8n_integration_sync_enhanced.py status
  
  # Validate database schema
  python n8n_integration_sync_enhanced.py validate
        """
    )
    
    subparsers = parser.add_subparsers(dest='command', help='Available commands')
    
    # Sync command
    sync_parser = subparsers.add_parser('sync', help='Sync integrations to database')
    sync_parser.add_argument('--n8n-url', help='N8N instance URL')
    sync_parser.add_argument('--api-key', help='N8N API key')
    sync_parser.add_argument('--update', action='store_true', help='Update existing entries')
    sync_parser.add_argument('--dry-run', action='store_true', help='Preview changes without database writes')
    
    # Database connection options
    sync_parser.add_argument('--db-host', help='Database host')
    sync_parser.add_argument('--db-port', help='Database port')
    sync_parser.add_argument('--db-name', help='Database name')
    sync_parser.add_argument('--db-user', help='Database user')
    sync_parser.add_argument('--db-password', help='Database password')
    
    # Status command
    status_parser = subparsers.add_parser('status', help='Show current sync status')
    
    # Validate command  
    validate_parser = subparsers.add_parser('validate', help='Validate database schema')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        return
    
    try:
        # Create database config
        db_config = create_db_config()
        if args.command == 'sync':
            # Override with command line arguments
            if args.db_host:
                db_config['host'] = args.db_host
            if args.db_port:
                db_config['port'] = int(args.db_port)
            if args.db_name:
                db_config['database'] = args.db_name
            if args.db_user:
                db_config['user'] = args.db_user
            if args.db_password:
                db_config['password'] = args.db_password
        
        # Create N8N config
        n8n_config = create_n8n_config()
        if args.command == 'sync':
            if args.n8n_url:
                n8n_config['base_url'] = args.n8n_url
            if args.api_key:
                n8n_config['api_key'] = args.api_key
        
        # Validate database configuration
        missing_db_config = [key for key, value in db_config.items() if not value and key != 'port']
        if missing_db_config:
            print(f"❌ Missing database configuration: {missing_db_config}")
            print("Please set environment variables or use command line arguments")
            return
        
        # Initialize sync system
        sync_system = N8NIntegrationSyncEnhanced(db_config, n8n_config)
        
        # Execute commands
        if args.command == 'validate':
            print("🔍 Validating database schema...")
            if sync_system.validate_database_schema():
                print("✅ Database schema validation passed")
            else:
                print("❌ Database schema validation failed")
                return
        
        elif args.command == 'status':
            print("📊 Getting sync status...")
            status = sync_system.get_sync_status()
            if 'error' in status:
                print(f"❌ Error getting status: {status['error']}")
                return
            
            print(f"\n📈 Total Channels: {status['total_channels']}")
            print("\n📊 Categories:")
            for cat in status['categories']:
                print(f"  • {cat['category']}: {cat['count']} channels")
            
            print(f"\n🕒 Recent Additions:")
            for rec in status['recent_additions'][:5]:
                print(f"  • {rec['channel_key']}: {rec['channel_name']} ({rec['created_at'][:10]})")
        
        elif args.command == 'sync':
            if args.dry_run:
                print("🔍 DRY RUN MODE - No database changes will be made")
                
                # Just validate and show what would be synced
                if not sync_system.validate_database_schema():
                    print("❌ Database schema validation failed")
                    return
                
                # Fetch and show integrations
                integrations = sync_system.fetch_n8n_integrations()
                print(f"📥 Would fetch {len(integrations)} integrations from N8N")
                
                # Show sample transformations
                sample_size = min(5, len(integrations))
                print(f"\n🔄 Sample transformations (showing {sample_size}):")
                for i, integration in enumerate(integrations[:sample_size]):
                    channel = sync_system.transform_integration_to_channel(integration)
                    if channel:
                        print(f"  {i+1}. {channel.channel_key}: {channel.channel_name} ({channel.capabilities.get('category', 'Unknown')})")
                    else:
                        print(f"  {i+1}. Failed to transform: {integration.get('name', 'unknown')}")
                
                print(f"\n✨ Would process {len(integrations)} total integrations")
                return
            
            # Validate schema first
            if not sync_system.validate_database_schema():
                print("❌ Database schema validation failed")
                print("Please ensure your catalog-edge-db schema is deployed")
                return
            
            # Perform sync
            print("🚀 Starting full integration sync...")
            result = sync_system.full_sync(args.update)
            print_results(result)
            
            if result.errors == 0:
                print("✅ Sync completed successfully!")
            else:
                print("⚠️  Sync completed with errors")
    
    except KeyboardInterrupt:
        print("\n⏹️  Sync interrupted by user")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    main()
