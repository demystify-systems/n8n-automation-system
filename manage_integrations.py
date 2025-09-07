#!/usr/bin/env python3
"""
Complete N8N Integration Management Script
==========================================

This script provides a complete workflow to:
1. Fetch all n8n integrations with metadata
2. Process and analyze them  
3. Sync to your catalog-edge-db database
4. Generate reports and summaries

Usage:
  python manage_integrations.py --help
  python manage_integrations.py fetch --sample-only  # Demo with sample data
  python manage_integrations.py sync processed_file.json --db-host HOST --db-user USER --db-password PASS
  python manage_integrations.py full-sync --n8n-url URL --api-key KEY --db-host HOST --db-user USER --db-password PASS
"""

import os
import sys
import json
import argparse
import logging
from datetime import datetime
from pathlib import Path

# Add current directory to path for imports
sys.path.append(str(Path(__file__).parent))

try:
    from fetch_n8n_integrations import N8NIntegrationFetcher
    from sync_integrations_to_db_clean import IntegrationDatabaseSync
except ImportError as e:
    print(f"Import error: {e}")
    print("Please ensure fetch_n8n_integrations.py and sync_integrations_to_db_clean.py are in the same directory")
    sys.exit(1)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class IntegrationManager:
    """Complete integration management system"""
    
    def __init__(self):
        self.timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    
    def fetch_integrations(self, n8n_url: str, api_key: str, sample_only: bool = False):
        """Fetch integrations from n8n API"""
        logger.info("=" * 60)
        logger.info("STEP 1: FETCHING N8N INTEGRATIONS")
        logger.info("=" * 60)
        
        # Create fetcher
        fetcher = N8NIntegrationFetcher(n8n_url, api_key)
        
        if sample_only:
            logger.info("Using sample data for demonstration")
            raw_nodes = fetcher._create_sample_nodes()
        else:
            logger.info(f"Fetching integrations from {n8n_url}")
            raw_nodes = fetcher.fetch_all_nodes()
        
        # Process and analyze
        processed_nodes = fetcher.process_node_metadata(raw_nodes)
        analysis = fetcher.analyze_integrations(processed_nodes)
        mapping_suggestions = fetcher.create_database_mapping_suggestions(processed_nodes)
        
        # Save files
        files = fetcher.save_to_files(raw_nodes, processed_nodes, analysis, mapping_suggestions)
        
        logger.info(f"Fetch completed: {len(processed_nodes)} integrations processed")
        return files
    
    def sync_to_database(self, processed_file: str, db_config: dict, update_existing: bool = False):
        """Sync processed integrations to database"""
        logger.info("=" * 60)
        logger.info("STEP 2: SYNCING TO DATABASE")
        logger.info("=" * 60)
        
        # Create sync instance
        sync = IntegrationDatabaseSync(db_config)
        
        # Validate database schema
        if not sync.validate_database_schema():
            raise Exception("Database schema validation failed")
        
        # Load and sync data
        integrations = sync.load_processed_data(processed_file)
        results = sync.sync_to_saas_channel_master(integrations, update_existing)
        
        # Get summary
        summary = sync.get_sync_summary()
        
        logger.info("Sync completed successfully")
        return results, summary
    
    def full_sync(self, n8n_url: str, api_key: str, db_config: dict, 
                  sample_only: bool = False, update_existing: bool = False):
        """Complete fetch and sync workflow"""
        logger.info("=" * 80)
        logger.info("N8N INTEGRATION MANAGEMENT - FULL SYNC")
        logger.info("=" * 80)
        
        try:
            # Step 1: Fetch integrations
            files = self.fetch_integrations(n8n_url, api_key, sample_only)
            processed_file = files['processed']
            
            # Step 2: Sync to database
            results, summary = self.sync_to_database(processed_file, db_config, update_existing)
            
            # Step 3: Generate final report
            self.generate_final_report(files, results, summary)
            
            return True
            
        except Exception as e:\n            logger.error(f\"Full sync failed: {e}\")\n            return False\n    \n    def generate_final_report(self, files: dict, sync_results: dict, db_summary: dict):\n        \"\"\"Generate a comprehensive final report\"\"\"\n        logger.info(\"=\" * 60)\n        logger.info(\"FINAL REPORT\")\n        logger.info(\"=\" * 60)\n        \n        print(\"\\n🚀 N8N INTEGRATION MANAGEMENT COMPLETED\")\n        print(\"\" * 80)\n        \n        print(\"📊 INTEGRATION PROCESSING:\")\n        print(f\"  • Raw integrations fetched: Available in {files['raw']}\")\n        print(f\"  • Processed integrations: Available in {files['processed']}\")\n        print(f\"  • Analysis report: Available in {files['analysis']}\")\n        print(f\"  • Database mapping: Available in {files['mapping']}\")\n        \n        print(\"\\n💾 DATABASE SYNC RESULTS:\")\n        print(f\"  • Channels inserted: {sync_results['inserted']}\")\n        print(f\"  • Channels updated: {sync_results['updated']}\")\n        print(f\"  • Channels skipped: {sync_results['skipped']}\")\n        print(f\"  • Errors: {sync_results['errors']}\")\n        \n        print(f\"\\n🎯 FINAL DATABASE STATE:\")\n        print(f\"  • Total channels: {db_summary['total_channels']}\")\n        \n        if db_summary['sample_channels']:\n            print(\"\\n📋 SAMPLE CHANNELS:\")\n            for ch in db_summary['sample_channels'][:8]:\n                category = ch['category'] or 'Unknown'\n                print(f\"  • {ch['channel_key']}: {ch['channel_name']} ({category})\")\n        \n        print(\"\\n\" + \"=\" * 80)\n        print(\"✅ INTEGRATION MANAGEMENT SYSTEM READY!\")\n        print(\"\\nNext Steps:\")\n        print(\"1. 🔧 Deploy your admin portal for channel management\")\n        print(\"2. 👥 Build user portal for self-service installations\")\n        print(\"3. 🔗 Configure webhook endpoints in your application\")\n        print(\"4. 🔐 Set up credential management system\")\n        print(\"5. 📈 Monitor usage and execution analytics\")\n        print(\"=\" * 80)\n\ndef create_argument_parser():\n    \"\"\"Create command line argument parser\"\"\"\n    parser = argparse.ArgumentParser(\n        description='Complete N8N Integration Management System',\n        formatter_class=argparse.RawDescriptionHelpFormatter,\n        epilog=\"\"\"\nExamples:\n  # Fetch integrations only (with sample data)\n  python manage_integrations.py fetch --sample-only\n  \n  # Fetch from real n8n instance\n  python manage_integrations.py fetch --n8n-url http://localhost:5678 --api-key your-key\n  \n  # Sync to database only\n  python manage_integrations.py sync processed_file.json --db-host HOST --db-user USER --db-password PASS\n  \n  # Complete workflow (fetch + sync)\n  python manage_integrations.py full-sync --sample-only --db-host HOST --db-user USER --db-password PASS\n  \n  # Real production sync\n  python manage_integrations.py full-sync --n8n-url URL --api-key KEY --db-host HOST --db-user USER --db-password PASS\n        \"\"\"\n    )\n    \n    subparsers = parser.add_subparsers(dest='command', help='Available commands')\n    \n    # Fetch command\n    fetch_parser = subparsers.add_parser('fetch', help='Fetch integrations from n8n')\n    fetch_parser.add_argument('--n8n-url', default=os.getenv('N8N_BASE_URL', 'http://localhost:5678'),\n                            help='N8N base URL')\n    fetch_parser.add_argument('--api-key', default=os.getenv('N8N_API_KEY', ''),\n                            help='N8N API key')\n    fetch_parser.add_argument('--sample-only', action='store_true',\n                            help='Use sample data only (for demo)')\n    \n    # Sync command\n    sync_parser = subparsers.add_parser('sync', help='Sync processed data to database')\n    sync_parser.add_argument('processed_file', help='Path to processed integrations JSON file')\n    sync_parser.add_argument('--db-host', required=True, help='Database host')\n    sync_parser.add_argument('--db-port', default='5432', help='Database port')\n    sync_parser.add_argument('--db-name', default='catalog-edge-db', help='Database name')\n    sync_parser.add_argument('--db-user', required=True, help='Database user')\n    sync_parser.add_argument('--db-password', required=True, help='Database password')\n    sync_parser.add_argument('--update', action='store_true', help='Update existing entries')\n    \n    # Full sync command\n    full_sync_parser = subparsers.add_parser('full-sync', help='Complete fetch and sync workflow')\n    full_sync_parser.add_argument('--n8n-url', default=os.getenv('N8N_BASE_URL', 'http://localhost:5678'),\n                                 help='N8N base URL')\n    full_sync_parser.add_argument('--api-key', default=os.getenv('N8N_API_KEY', ''),\n                                 help='N8N API key')\n    full_sync_parser.add_argument('--sample-only', action='store_true',\n                                 help='Use sample data only (for demo)')\n    full_sync_parser.add_argument('--db-host', required=True, help='Database host')\n    full_sync_parser.add_argument('--db-port', default='5432', help='Database port')\n    full_sync_parser.add_argument('--db-name', default='catalog-edge-db', help='Database name')\n    full_sync_parser.add_argument('--db-user', required=True, help='Database user')\n    full_sync_parser.add_argument('--db-password', required=True, help='Database password')\n    full_sync_parser.add_argument('--update', action='store_true', help='Update existing entries')\n    \n    # Status command\n    status_parser = subparsers.add_parser('status', help='Check database status')\n    status_parser.add_argument('--db-host', required=True, help='Database host')\n    status_parser.add_argument('--db-port', default='5432', help='Database port')\n    status_parser.add_argument('--db-name', default='catalog-edge-db', help='Database name')\n    status_parser.add_argument('--db-user', required=True, help='Database user')\n    status_parser.add_argument('--db-password', required=True, help='Database password')\n    \n    return parser\n\ndef main():\n    \"\"\"Main execution function\"\"\"\n    parser = create_argument_parser()\n    args = parser.parse_args()\n    \n    if not args.command:\n        parser.print_help()\n        return\n    \n    manager = IntegrationManager()\n    \n    try:\n        if args.command == 'fetch':\n            if not args.sample_only and not args.api_key:\n                logger.error(\"N8N API key is required unless using --sample-only\")\n                return\n            \n            files = manager.fetch_integrations(args.n8n_url, args.api_key or 'sample', args.sample_only)\n            print(f\"\\n✅ Integration fetch completed!\")\n            print(f\"Processed file: {files['processed']}\")\n            print(f\"Use this file with the 'sync' command to sync to database\")\n            \n        elif args.command == 'sync':\n            if not os.path.exists(args.processed_file):\n                logger.error(f\"Processed file not found: {args.processed_file}\")\n                return\n                \n            db_config = {\n                'host': args.db_host,\n                'port': int(args.db_port),\n                'database': args.db_name,\n                'user': args.db_user,\n                'password': args.db_password\n            }\n            \n            results, summary = manager.sync_to_database(args.processed_file, db_config, args.update)\n            print(f\"\\n✅ Database sync completed!\")\n            print(f\"Inserted: {results['inserted']}, Updated: {results['updated']}\")\n            \n        elif args.command == 'full-sync':\n            if not args.sample_only and not args.api_key:\n                logger.error(\"N8N API key is required unless using --sample-only\")\n                return\n                \n            db_config = {\n                'host': args.db_host,\n                'port': int(args.db_port),\n                'database': args.db_name,\n                'user': args.db_user,\n                'password': args.db_password\n            }\n            \n            success = manager.full_sync(\n                args.n8n_url, \n                args.api_key or 'sample',\n                db_config,\n                args.sample_only,\n                args.update\n            )\n            \n            if success:\n                print(\"\\n🎉 Full sync completed successfully!\")\n            else:\n                print(\"\\n❌ Full sync failed. Check logs above.\")\n                return\n                \n        elif args.command == 'status':\n            db_config = {\n                'host': args.db_host,\n                'port': int(args.db_port),\n                'database': args.db_name,\n                'user': args.db_user,\n                'password': args.db_password\n            }\n            \n            sync = IntegrationDatabaseSync(db_config)\n            if sync.validate_database_schema():\n                summary = sync.get_sync_summary()\n                print(f\"\\n✅ Database connection successful!\")\n                print(f\"Total channels: {summary['total_channels']}\")\n                if summary['sample_channels']:\n                    print(\"Sample channels:\")\n                    for ch in summary['sample_channels'][:5]:\n                        print(f\"  • {ch['channel_key']}: {ch['channel_name']}\")\n            else:\n                print(\"\\n❌ Database validation failed\")\n                \n    except KeyboardInterrupt:\n        logger.info(\"Operation cancelled by user\")\n    except Exception as e:\n        logger.error(f\"Operation failed: {e}\")\n        sys.exit(1)\n\nif __name__ == \"__main__\":\n    main()
