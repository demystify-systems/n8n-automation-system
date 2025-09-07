#!/usr/bin/env python3
"""
SQL Insert File Generator for N8N Integrations
==============================================

This script generates SQL INSERT statements for N8N integrations to be inserted
into the catalog-edge-db schema. It can work with either live N8N API data or
fallback JSON data.

Features:
- Generates SQL INSERT statements for saas_channel_master table
- Creates proper JSONB formatted data
- Handles UUID generation and proper escaping
- Supports both individual and bulk insert formats
- Creates rollback scripts for easy cleanup

Usage:
    python generate_sql_inserts.py --output-file integration_inserts.sql
    python generate_sql_inserts.py --source api --n8n-url https://spinner.saastify.ai --api-key YOUR_KEY
    python generate_sql_inserts.py --source json --json-file COMPLETE_N8N_INTEGRATIONS_200.json
"""

import os
import sys
import json
import argparse
import logging
from datetime import datetime
from typing import Dict, List, Optional, Any
import uuid
import re

# Add the enhanced sync script to path for reusing transformation logic
sys.path.append(os.path.dirname(__file__))

try:
    from n8n_integration_sync_enhanced import N8NIntegrationSyncEnhanced, ChannelData
except ImportError:
    print("Error: Could not import N8NIntegrationSyncEnhanced. Make sure n8n_integration_sync_enhanced.py exists.")
    sys.exit(1)

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class SQLInsertGenerator:
    """Generates SQL INSERT statements for N8N integrations"""
    
    def __init__(self, output_file: str = None):
        self.output_file = output_file or f"n8n_channel_inserts_{datetime.now().strftime('%Y%m%d_%H%M%S')}.sql"
        self.rollback_file = self.output_file.replace('.sql', '_rollback.sql')
        
    def escape_sql_string(self, value: str) -> str:
        """Escape string for SQL"""
        if value is None:
            return 'NULL'
        return f"'{value.replace("'", "''")}'"
    
    def format_jsonb(self, data: Dict[str, Any]) -> str:
        """Format dictionary as JSONB string for PostgreSQL"""
        if not data:
            return "'{}'"
        
        json_str = json.dumps(data, indent=None, separators=(',', ':'))
        # Escape single quotes for SQL
        escaped_json = json_str.replace("'", "''")
        return f"'{escaped_json}'"
    
    def generate_uuid(self) -> str:
        """Generate a UUID string"""
        return str(uuid.uuid4())
    
    def create_insert_statement(self, channel: ChannelData) -> tuple[str, str]:
        """Create INSERT statement for a channel and its rollback"""
        
        # Generate UUID for this channel
        channel_id = self.generate_uuid()
        
        # Prepare values
        channel_key = self.escape_sql_string(channel.channel_key)
        channel_name = self.escape_sql_string(channel.channel_name)
        base_url = self.escape_sql_string(channel.base_url) if channel.base_url else 'NULL'
        docs_url = self.escape_sql_string(channel.docs_url) if channel.docs_url else 'NULL'
        logo_url = self.escape_sql_string(channel.channel_logo_url) if channel.channel_logo_url else 'NULL'
        default_config = self.format_jsonb(channel.default_channel_config)
        capabilities = self.format_jsonb(channel.capabilities)
        
        # Create INSERT statement
        insert_sql = f"""-- Insert {channel.channel_key}: {channel.channel_name}
INSERT INTO saas_channel_master (
    channel_id,
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities,
    created_at,
    updated_at
) VALUES (
    '{channel_id}',
    {channel_key},
    {channel_name},
    {base_url},
    {docs_url},
    {logo_url},
    {default_config}::jsonb,
    {capabilities}::jsonb,
    NOW(),
    NOW()
);"""
        
        # Create rollback statement
        rollback_sql = f"DELETE FROM saas_channel_master WHERE channel_key = {channel_key};"
        
        return insert_sql, rollback_sql
    
    def create_upsert_statement(self, channel: ChannelData) -> str:
        """Create UPSERT statement (INSERT with ON CONFLICT UPDATE)"""
        
        # Prepare values
        channel_key = self.escape_sql_string(channel.channel_key)
        channel_name = self.escape_sql_string(channel.channel_name)
        base_url = self.escape_sql_string(channel.base_url) if channel.base_url else 'NULL'
        docs_url = self.escape_sql_string(channel.docs_url) if channel.docs_url else 'NULL'
        logo_url = self.escape_sql_string(channel.channel_logo_url) if channel.channel_logo_url else 'NULL'
        default_config = self.format_jsonb(channel.default_channel_config)
        capabilities = self.format_jsonb(channel.capabilities)
        
        # Create UPSERT statement
        upsert_sql = f"""-- Upsert {channel.channel_key}: {channel.channel_name}
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities,
    created_at,
    updated_at
) VALUES (
    {channel_key},
    {channel_name},
    {base_url},
    {docs_url},
    {logo_url},
    {default_config}::jsonb,
    {capabilities}::jsonb,
    NOW(),
    NOW()
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();"""
        
        return upsert_sql
    
    def generate_file_header(self, channels_count: int, source: str) -> str:
        """Generate file header with metadata"""
        return f"""-- =========================================
-- N8N Integration Channel Master Inserts
-- =========================================
-- 
-- Generated: {datetime.now().isoformat()}
-- Source: {source}
-- Total Channels: {channels_count}
-- Target Table: saas_channel_master
-- Database: catalog-edge-db
--
-- Usage:
--   psql -h DB_HOST -U DB_USER -d catalog-edge-db -f {self.output_file}
--
-- Rollback:
--   psql -h DB_HOST -U DB_USER -d catalog-edge-db -f {self.rollback_file}
-- =========================================

-- Start transaction
BEGIN;

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Validate target table exists
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'saas_channel_master') THEN
        RAISE EXCEPTION 'Table saas_channel_master does not exist. Please run the catalog-edge-db migration first.';
    END IF;
END $$;

"""
    
    def generate_file_footer(self) -> str:
        """Generate file footer"""
        return """
-- Commit transaction
COMMIT;

-- =========================================
-- Verification Queries
-- =========================================

-- Check total count
SELECT COUNT(*) as total_channels FROM saas_channel_master;

-- Check channels by category
SELECT 
    capabilities->>'category' as category,
    COUNT(*) as count
FROM saas_channel_master 
WHERE capabilities->>'category' IS NOT NULL
GROUP BY capabilities->>'category'
ORDER BY count DESC;

-- Show recent additions
SELECT 
    channel_key,
    channel_name,
    capabilities->>'category' as category,
    created_at
FROM saas_channel_master 
ORDER BY created_at DESC 
LIMIT 10;
"""
    
    def generate_rollback_file_header(self, channels_count: int) -> str:
        """Generate rollback file header"""
        return f"""-- =========================================
-- N8N Integration Channel Master Rollback
-- =========================================
-- 
-- Generated: {datetime.now().isoformat()}
-- Total Channels to Remove: {channels_count}
-- Target Table: saas_channel_master
-- Database: catalog-edge-db
--
-- CAUTION: This will delete {channels_count} channel records!
--
-- Usage:
--   psql -h DB_HOST -U DB_USER -d catalog-edge-db -f {self.rollback_file}
-- =========================================

-- Start transaction
BEGIN;

"""
    
    def generate_rollback_file_footer(self) -> str:
        """Generate rollback file footer"""
        return """
-- Commit transaction
COMMIT;

-- Verification: Check remaining channels
SELECT COUNT(*) as remaining_channels FROM saas_channel_master;
"""
    
    def load_channels_from_api(self, n8n_config: Dict[str, str]) -> List[ChannelData]:
        """Load and transform channels from N8N API"""
        logger.info("Loading channels from N8N API...")
        
        # Use the enhanced sync system
        sync_system = N8NIntegrationSyncEnhanced({}, n8n_config)
        
        # Fetch integrations
        integrations = sync_system.fetch_n8n_integrations()
        logger.info(f"Fetched {len(integrations)} integrations from N8N API")
        
        # Transform to channels
        channels = []
        for integration in integrations:
            channel = sync_system.transform_integration_to_channel(integration)
            if channel:
                channels.append(channel)
        
        logger.info(f"Successfully transformed {len(channels)} integrations to channels")
        return channels
    
    def load_channels_from_json(self, json_file: str) -> List[ChannelData]:
        """Load and transform channels from JSON file"""
        logger.info(f"Loading channels from JSON file: {json_file}")
        
        # Use the enhanced sync system
        sync_system = N8NIntegrationSyncEnhanced({}, {})
        
        # Load integrations from JSON
        integrations = sync_system._get_fallback_integrations()
        logger.info(f"Loaded {len(integrations)} integrations from JSON")
        
        # Transform to channels
        channels = []
        for integration in integrations:
            channel = sync_system.transform_integration_to_channel(integration)
            if channel:
                channels.append(channel)
        
        logger.info(f"Successfully transformed {len(channels)} integrations to channels")
        return channels
    
    def generate_sql_file(self, channels: List[ChannelData], mode: str = 'insert') -> tuple[str, str]:
        """Generate SQL file with INSERT or UPSERT statements"""
        
        if not channels:
            raise ValueError("No channels provided for SQL generation")
        
        logger.info(f"Generating SQL file with {len(channels)} channels in {mode} mode")
        
        # Determine source
        source = "N8N API" if hasattr(self, '_api_source') else "JSON File"
        
        # Generate main SQL file
        with open(self.output_file, 'w') as f:
            # Write header
            f.write(self.generate_file_header(len(channels), source))
            
            # Write statements
            rollback_statements = []
            
            for i, channel in enumerate(channels, 1):
                logger.debug(f"Processing channel {i}/{len(channels)}: {channel.channel_key}")
                
                if mode == 'upsert':
                    # Generate UPSERT statement
                    upsert_sql = self.create_upsert_statement(channel)
                    f.write(f"\n{upsert_sql}\n")
                    
                    # For rollback with upserts, we can only delete
                    rollback_statements.append(f"DELETE FROM saas_channel_master WHERE channel_key = {self.escape_sql_string(channel.channel_key)};")
                    
                else:
                    # Generate INSERT statement
                    insert_sql, rollback_sql = self.create_insert_statement(channel)
                    f.write(f"\n{insert_sql}\n")
                    rollback_statements.append(rollback_sql)
            
            # Write footer
            f.write(self.generate_file_footer())
        
        # Generate rollback file
        with open(self.rollback_file, 'w') as f:
            # Write header
            f.write(self.generate_rollback_file_header(len(channels)))
            
            # Write rollback statements (in reverse order)
            for rollback_sql in reversed(rollback_statements):
                f.write(f"{rollback_sql}\n")
            
            # Write footer
            f.write(self.generate_rollback_file_footer())
        
        logger.info(f"Generated SQL files:")
        logger.info(f"  Main file: {self.output_file}")
        logger.info(f"  Rollback file: {self.rollback_file}")
        
        return self.output_file, self.rollback_file
    
    def generate_summary_report(self, channels: List[ChannelData]) -> str:
        """Generate summary report of channels"""
        if not channels:
            return "No channels to report on."
        
        # Count by category
        category_counts = {}
        auth_method_counts = {}
        
        for channel in channels:
            category = channel.capabilities.get('category', 'Unknown')
            category_counts[category] = category_counts.get(category, 0) + 1
            
            for auth in channel.auth_methods:
                auth_method_counts[auth] = auth_method_counts.get(auth, 0) + 1
        
        # Generate report
        report = f"""
N8N Integration SQL Generation Summary
=====================================

Total Channels: {len(channels)}
Generated Files: {self.output_file}, {self.rollback_file}
Timestamp: {datetime.now().isoformat()}

Categories:
{'-' * 50}"""
        
        for category, count in sorted(category_counts.items(), key=lambda x: x[1], reverse=True):
            report += f"\n  {category:<20}: {count:>3} channels"
        
        report += f"""

Authentication Methods:
{'-' * 50}"""
        
        for auth, count in sorted(auth_method_counts.items(), key=lambda x: x[1], reverse=True):
            report += f"\n  {auth:<20}: {count:>3} channels"
        
        report += f"""

Sample Channels:
{'-' * 50}"""
        
        for channel in channels[:10]:  # Show first 10
            report += f"\n  {channel.channel_key:<15}: {channel.channel_name} ({channel.capabilities.get('category', 'Unknown')})"
        
        if len(channels) > 10:
            report += f"\n  ... and {len(channels) - 10} more channels"
        
        report += f"""

Next Steps:
{'-' * 50}
1. Review the generated SQL file: {self.output_file}
2. Test with a small subset first (edit the file)
3. Run against your database:
   psql -h DB_HOST -U DB_USER -d catalog-edge-db -f {self.output_file}
4. Verify the results:
   SELECT COUNT(*) FROM saas_channel_master;
5. If needed, rollback:
   psql -h DB_HOST -U DB_USER -d catalog-edge-db -f {self.rollback_file}
"""
        
        return report

def main():
    """Main CLI interface"""
    parser = argparse.ArgumentParser(
        description='Generate SQL INSERT statements for N8N integrations',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Generate from JSON file (default)
  python generate_sql_inserts.py --output-file my_inserts.sql

  # Generate from live N8N API
  python generate_sql_inserts.py --source api --n8n-url https://spinner.saastify.ai --api-key YOUR_KEY

  # Generate UPSERT statements instead of INSERT
  python generate_sql_inserts.py --mode upsert

  # Specify custom JSON file
  python generate_sql_inserts.py --source json --json-file custom_integrations.json
        """
    )
    
    parser.add_argument('--output-file', '-o', 
                       help='Output SQL file path')
    parser.add_argument('--source', choices=['api', 'json'], default='json',
                       help='Data source: api (live N8N) or json (file)')
    parser.add_argument('--mode', choices=['insert', 'upsert'], default='insert',
                       help='SQL statement type: insert or upsert')
    
    # N8N API options
    parser.add_argument('--n8n-url', 
                       help='N8N instance URL (required for --source api)')
    parser.add_argument('--api-key', 
                       help='N8N API key (required for --source api)')
    
    # JSON file options
    parser.add_argument('--json-file',
                       help='JSON file path (default: COMPLETE_N8N_INTEGRATIONS_200.json)')
    
    # Additional options
    parser.add_argument('--verbose', '-v', action='store_true',
                       help='Enable verbose logging')
    parser.add_argument('--dry-run', action='store_true',
                       help='Show what would be generated without creating files')
    
    args = parser.parse_args()
    
    # Configure logging
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    try:
        # Create generator
        generator = SQLInsertGenerator(args.output_file)
        
        # Load channels based on source
        if args.source == 'api':
            if not args.n8n_url or not args.api_key:
                print("❌ N8N URL and API key are required when using --source api")
                return
            
            n8n_config = {
                'base_url': args.n8n_url,
                'api_key': args.api_key
            }
            generator._api_source = True
            channels = generator.load_channels_from_api(n8n_config)
            
        else:
            # Load from JSON
            json_file = args.json_file or 'COMPLETE_N8N_INTEGRATIONS_200.json'
            if not os.path.exists(json_file):
                # Try relative to script directory
                script_dir = os.path.dirname(__file__)
                json_file = os.path.join(script_dir, '../../COMPLETE_N8N_INTEGRATIONS_200.json')
                
            if not os.path.exists(json_file):
                print(f"❌ JSON file not found: {json_file}")
                print("Please specify a valid JSON file with --json-file option")
                return
            
            channels = generator.load_channels_from_json(json_file)
        
        if not channels:
            print("❌ No channels loaded. Cannot generate SQL.")
            return
        
        print(f"✅ Loaded {len(channels)} channels successfully")
        
        # Generate summary report
        report = generator.generate_summary_report(channels)
        print(report)
        
        if args.dry_run:
            print("\n🔍 DRY RUN MODE - No files were created")
            print("\nExample SQL statement:")
            if channels:
                if args.mode == 'upsert':
                    example = generator.create_upsert_statement(channels[0])
                    print(example)
                else:
                    insert_sql, rollback_sql = generator.create_insert_statement(channels[0])
                    print(insert_sql)
                    print("\nExample rollback:")
                    print(rollback_sql)
            return
        
        # Generate SQL files
        print(f"\n🚀 Generating {args.mode.upper()} statements...")
        main_file, rollback_file = generator.generate_sql_file(channels, args.mode)
        
        print(f"\n✅ SQL generation completed!")
        print(f"📄 Main file: {main_file}")
        print(f"📄 Rollback file: {rollback_file}")
        
        # Show file sizes
        main_size = os.path.getsize(main_file)
        rollback_size = os.path.getsize(rollback_file)
        print(f"📊 File sizes: {main_size:,} bytes (main), {rollback_size:,} bytes (rollback)")
        
        print(f"\n🔧 Next steps:")
        print(f"1. Review the generated SQL: cat {main_file}")
        print(f"2. Test with your database: psql -h DB_HOST -U DB_USER -d catalog-edge-db -f {main_file}")
        print(f"3. If needed, rollback: psql -h DB_HOST -U DB_USER -d catalog-edge-db -f {rollback_file}")
        
    except KeyboardInterrupt:
        print("\n⏹️  Generation interrupted by user")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        print(f"❌ Generation failed: {e}")
        raise

if __name__ == "__main__":
    main()
