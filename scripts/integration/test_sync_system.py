#!/usr/bin/env python3
"""
Test Script for N8N Integration Sync System
==========================================

This script validates that the sync system is working correctly
and can be used to test various components before running a full sync.

Features:
- Test database connectivity
- Test N8N API connectivity  
- Validate transformation logic
- Test SQL generation
- Generate sample data for testing

Usage:
    python test_sync_system.py --test-all
    python test_sync_system.py --test-db
    python test_sync_system.py --test-api --n8n-url URL --api-key KEY
    python test_sync_system.py --test-transform
"""

import os
import sys
import argparse
import json
from datetime import datetime

# Add current directory to path
sys.path.append(os.path.dirname(__file__))

try:
    from n8n_integration_sync_enhanced import N8NIntegrationSyncEnhanced, create_db_config, create_n8n_config
    from generate_sql_inserts import SQLInsertGenerator
except ImportError as e:
    print(f"❌ Import error: {e}")
    print("Make sure n8n_integration_sync_enhanced.py and generate_sql_inserts.py exist in the same directory")
    sys.exit(1)

class SyncSystemTester:
    """Test suite for the N8N integration sync system"""
    
    def __init__(self):
        self.results = {
            'database': {'status': 'not_tested', 'details': []},
            'n8n_api': {'status': 'not_tested', 'details': []},
            'transformation': {'status': 'not_tested', 'details': []},
            'sql_generation': {'status': 'not_tested', 'details': []},
        }
    
    def test_database_connectivity(self, db_config: dict) -> bool:
        """Test database connection and schema validation"""
        print("🔍 Testing database connectivity...")
        
        try:
            sync_system = N8NIntegrationSyncEnhanced(db_config, {})
            
            # Test basic connection
            conn = sync_system.get_database_connection()
            cursor = conn.cursor()
            cursor.execute("SELECT version()")
            version = cursor.fetchone()[0]
            
            self.results['database']['details'].append(f"✅ Connected to PostgreSQL: {version}")
            
            # Test schema validation
            if sync_system.validate_database_schema():
                self.results['database']['details'].append("✅ Database schema validation passed")
            else:
                self.results['database']['details'].append("❌ Database schema validation failed")
                self.results['database']['status'] = 'failed'
                return False
            
            # Test sync status query
            status = sync_system.get_sync_status()
            if 'error' not in status:
                self.results['database']['details'].append(f"✅ Current channels in DB: {status['total_channels']}")
            else:
                self.results['database']['details'].append(f"⚠️ Sync status error: {status['error']}")
            
            conn.close()
            self.results['database']['status'] = 'passed'
            return True
            
        except Exception as e:
            self.results['database']['details'].append(f"❌ Database test failed: {e}")
            self.results['database']['status'] = 'failed'
            return False
    
    def test_n8n_api_connectivity(self, n8n_config: dict) -> bool:
        """Test N8N API connection and data fetching"""
        print("🔍 Testing N8N API connectivity...")
        
        try:
            sync_system = N8NIntegrationSyncEnhanced({}, n8n_config)
            
            # Test API connection
            integrations = sync_system.fetch_n8n_integrations()
            
            if integrations:
                self.results['n8n_api']['details'].append(f"✅ Fetched {len(integrations)} integrations from N8N API")
                
                # Test sample integration structure
                sample = integrations[0] if integrations else {}
                required_fields = ['name', 'displayName']
                missing_fields = [field for field in required_fields if field not in sample]
                
                if missing_fields:
                    self.results['n8n_api']['details'].append(f"⚠️ Missing fields in sample integration: {missing_fields}")
                else:
                    self.results['n8n_api']['details'].append("✅ Integration structure looks good")
                
                # Show sample integrations
                sample_names = [i.get('displayName', i.get('name', 'Unknown')) for i in integrations[:5]]
                self.results['n8n_api']['details'].append(f"📋 Sample integrations: {', '.join(sample_names)}")
                
            else:
                self.results['n8n_api']['details'].append("⚠️ No integrations fetched (using fallback data)")
            
            self.results['n8n_api']['status'] = 'passed'
            return True
            
        except Exception as e:
            self.results['n8n_api']['details'].append(f"❌ N8N API test failed: {e}")
            self.results['n8n_api']['status'] = 'failed'
            return False
    
    def test_transformation_logic(self) -> bool:
        """Test integration data transformation"""
        print("🔍 Testing data transformation logic...")
        
        try:
            sync_system = N8NIntegrationSyncEnhanced({}, {})
            
            # Create sample integration data
            sample_integration = {
                'name': 'n8n-nodes-base.slack',
                'displayName': 'Slack',
                'description': 'Consume the Slack API',
                'version': 1,
                'credentials': [{
                    'name': 'slackApi',
                    'displayName': 'Slack API',
                    'properties': [
                        {'name': 'token', 'displayName': 'Token', 'type': 'string', 'required': True}
                    ]
                }],
                'properties': [
                    {
                        'displayName': 'Resource',
                        'name': 'resource',
                        'type': 'options',
                        'options': [
                            {'name': 'Channel', 'value': 'channel'},
                            {'name': 'Message', 'value': 'message'}
                        ]
                    }
                ]
            }
            
            # Test transformation
            channel = sync_system.transform_integration_to_channel(sample_integration)
            
            if channel:
                self.results['transformation']['details'].append("✅ Successfully transformed sample integration")
                self.results['transformation']['details'].append(f"📋 Channel Key: {channel.channel_key}")
                self.results['transformation']['details'].append(f"📋 Channel Name: {channel.channel_name}")
                self.results['transformation']['details'].append(f"📋 Category: {channel.capabilities.get('category', 'Unknown')}")
                self.results['transformation']['details'].append(f"📋 Auth Methods: {', '.join(channel.auth_methods)}")
                
                # Test logo generation
                if channel.channel_logo_url:
                    self.results['transformation']['details'].append(f"✅ Logo URL generated: {channel.channel_logo_url}")
                else:
                    self.results['transformation']['details'].append("⚠️ No logo URL generated")
                
                # Test credential schema
                if channel.credential_schema:
                    self.results['transformation']['details'].append("✅ Credential schema generated")
                else:
                    self.results['transformation']['details'].append("⚠️ No credential schema generated")
                
            else:
                self.results['transformation']['details'].append("❌ Failed to transform sample integration")
                self.results['transformation']['status'] = 'failed'
                return False
            
            self.results['transformation']['status'] = 'passed'
            return True
            
        except Exception as e:
            self.results['transformation']['details'].append(f"❌ Transformation test failed: {e}")
            self.results['transformation']['status'] = 'failed'
            return False
    
    def test_sql_generation(self) -> bool:
        """Test SQL generation functionality"""
        print("🔍 Testing SQL generation...")
        
        try:
            # Use existing integration data
            sync_system = N8NIntegrationSyncEnhanced({}, {})
            integrations = sync_system._get_fallback_integrations()
            
            # Transform to channels (just first few for testing)
            test_channels = []
            for integration in integrations[:3]:  # Test with first 3
                channel = sync_system.transform_integration_to_channel(integration)
                if channel:
                    test_channels.append(channel)
            
            if not test_channels:
                self.results['sql_generation']['details'].append("❌ No channels available for SQL testing")
                self.results['sql_generation']['status'] = 'failed'
                return False
            
            # Test SQL generation
            generator = SQLInsertGenerator("test_output.sql")
            
            # Test INSERT statement generation
            insert_sql, rollback_sql = generator.create_insert_statement(test_channels[0])
            if 'INSERT INTO saas_channel_master' in insert_sql:
                self.results['sql_generation']['details'].append("✅ INSERT statement generated successfully")
            else:
                self.results['sql_generation']['details'].append("❌ INSERT statement generation failed")
                self.results['sql_generation']['status'] = 'failed'
                return False
            
            # Test UPSERT statement generation
            upsert_sql = generator.create_upsert_statement(test_channels[0])
            if 'ON CONFLICT (channel_key) DO UPDATE' in upsert_sql:
                self.results['sql_generation']['details'].append("✅ UPSERT statement generated successfully")
            else:
                self.results['sql_generation']['details'].append("❌ UPSERT statement generation failed")
            
            # Test JSON formatting
            sample_data = {'key': 'value', 'nested': {'test': True}}
            formatted_json = generator.format_jsonb(sample_data)
            if "'key'" in formatted_json and "'value'" in formatted_json:
                self.results['sql_generation']['details'].append("✅ JSONB formatting working correctly")
            else:
                self.results['sql_generation']['details'].append("❌ JSONB formatting failed")
            
            self.results['sql_generation']['details'].append(f"📋 Tested with {len(test_channels)} sample channels")
            self.results['sql_generation']['status'] = 'passed'
            return True
            
        except Exception as e:
            self.results['sql_generation']['details'].append(f"❌ SQL generation test failed: {e}")
            self.results['sql_generation']['status'] = 'failed'
            return False
    
    def run_all_tests(self, db_config: dict = None, n8n_config: dict = None) -> bool:
        """Run all tests"""
        print("🚀 Running all N8N Integration Sync System tests...\n")
        
        all_passed = True
        
        # Test database if config provided
        if db_config:
            if not self.test_database_connectivity(db_config):
                all_passed = False
        else:
            print("⏭️  Skipping database test (no config provided)")
        
        print()
        
        # Test N8N API if config provided
        if n8n_config and n8n_config.get('api_key'):
            if not self.test_n8n_api_connectivity(n8n_config):
                all_passed = False
        else:
            print("⏭️  Skipping N8N API test (no API key provided)")
        
        print()
        
        # Test transformation (always run)
        if not self.test_transformation_logic():
            all_passed = False
        
        print()
        
        # Test SQL generation (always run)  
        if not self.test_sql_generation():
            all_passed = False
        
        return all_passed
    
    def print_results(self):
        """Print test results summary"""
        print("\n" + "="*60)
        print("N8N INTEGRATION SYNC SYSTEM TEST RESULTS")
        print("="*60)
        
        for test_name, result in self.results.items():
            status_icon = {
                'passed': '✅',
                'failed': '❌', 
                'not_tested': '⏭️'
            }.get(result['status'], '❓')
            
            print(f"\n{status_icon} {test_name.upper().replace('_', ' ')}: {result['status']}")
            
            for detail in result['details']:
                print(f"   {detail}")
        
        print("\n" + "="*60)
        
        # Overall result
        failed_tests = [name for name, result in self.results.items() if result['status'] == 'failed']
        passed_tests = [name for name, result in self.results.items() if result['status'] == 'passed']
        
        if failed_tests:
            print(f"❌ OVERALL RESULT: {len(failed_tests)} test(s) failed: {', '.join(failed_tests)}")
            print("Please review the errors above and fix before running sync operations.")
        else:
            print(f"✅ OVERALL RESULT: All {len(passed_tests)} test(s) passed!")
            print("The N8N Integration Sync System is ready for use.")

def main():
    """Main CLI interface"""
    parser = argparse.ArgumentParser(
        description='Test N8N Integration Sync System',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Test everything with environment variables
  python test_sync_system.py --test-all
  
  # Test only database connectivity
  python test_sync_system.py --test-db
  
  # Test N8N API connectivity
  python test_sync_system.py --test-api --n8n-url https://spinner.saastify.ai --api-key YOUR_KEY
  
  # Test only transformation logic
  python test_sync_system.py --test-transform
  
  # Test only SQL generation
  python test_sync_system.py --test-sql
        """
    )
    
    # Test selection
    parser.add_argument('--test-all', action='store_true', help='Run all tests')
    parser.add_argument('--test-db', action='store_true', help='Test database connectivity only')
    parser.add_argument('--test-api', action='store_true', help='Test N8N API connectivity only')
    parser.add_argument('--test-transform', action='store_true', help='Test transformation logic only')
    parser.add_argument('--test-sql', action='store_true', help='Test SQL generation only')
    
    # Connection options
    parser.add_argument('--n8n-url', help='N8N instance URL')
    parser.add_argument('--api-key', help='N8N API key')
    parser.add_argument('--db-host', help='Database host')
    parser.add_argument('--db-user', help='Database user')
    parser.add_argument('--db-password', help='Database password')
    parser.add_argument('--db-name', help='Database name')
    
    args = parser.parse_args()
    
    # If no specific test is requested, run all tests
    if not any([args.test_all, args.test_db, args.test_api, args.test_transform, args.test_sql]):
        args.test_all = True
    
    try:
        tester = SyncSystemTester()
        
        # Prepare configurations
        db_config = None
        n8n_config = None
        
        # Get database config from args or environment
        if args.test_all or args.test_db:
            db_config = create_db_config()
            if args.db_host:
                db_config['host'] = args.db_host
            if args.db_user:
                db_config['user'] = args.db_user
            if args.db_password:
                db_config['password'] = args.db_password
            if args.db_name:
                db_config['database'] = args.db_name
        
        # Get N8N config from args or environment
        if args.test_all or args.test_api:
            n8n_config = create_n8n_config()
            if args.n8n_url:
                n8n_config['base_url'] = args.n8n_url
            if args.api_key:
                n8n_config['api_key'] = args.api_key
        
        # Run tests based on selection
        if args.test_all:
            tester.run_all_tests(db_config, n8n_config)
        else:
            if args.test_db and db_config:
                tester.test_database_connectivity(db_config)
            if args.test_api and n8n_config:
                tester.test_n8n_api_connectivity(n8n_config)
            if args.test_transform:
                tester.test_transformation_logic()
            if args.test_sql:
                tester.test_sql_generation()
        
        # Print results
        tester.print_results()
        
    except KeyboardInterrupt:
        print("\n⏹️  Tests interrupted by user")
    except Exception as e:
        print(f"❌ Test system error: {e}")
        raise

if __name__ == "__main__":
    main()
