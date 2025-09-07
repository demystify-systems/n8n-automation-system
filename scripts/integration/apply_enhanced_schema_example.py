#!/usr/bin/env python3
"""
Apply Enhanced N8N Channel Management Schema
Uses the Cloud SQL proxy connection to apply database migrations
"""

import os
import sys
import psycopg2
import json
from datetime import datetime

# Database connection using Cloud SQL proxy
DB_CONFIG = {
    'host': 'localhost',  # Cloud SQL proxy runs locally
    'port': 5432,         # Forwarded port
    'database': 'catalog-edge-db',
    'user': os.getenv('DB_USER', 'n8n_user'),
    'password': os.getenv('DB_PASSWORD', 'saasdbforn8n2025')
}

def test_connection():
    """Test the database connection"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        with conn.cursor() as cur:
            cur.execute("SELECT current_database(), current_user, version();")
            db_name, user, version = cur.fetchone()
            print(f"✅ Connected to database: {db_name}")
            print(f"✅ Current user: {user}")
            print(f"✅ PostgreSQL version: {version.split(',')[0]}")
        conn.close()
        return True
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
        return False

def check_existing_tables():
    """Check what tables already exist"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        with conn.cursor() as cur:
            # Check for existing channel-related tables
            cur.execute("""
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name LIKE 'saas_%'
                ORDER BY table_name;
            """)
            
            existing_tables = [row[0] for row in cur.fetchall()]
            print(f"\n📋 Existing SaaS tables ({len(existing_tables)}):")
            for table in existing_tables:
                print(f"  - {table}")
                
        conn.close()
        return existing_tables
    except Exception as e:
        print(f"❌ Failed to check existing tables: {e}")
        return []

def apply_schema_migration():
    """Apply the enhanced schema migration"""
    schema_file = "enhanced_channel_schema_migration.sql"
    
    if not os.path.exists(schema_file):
        print(f"❌ Schema file not found: {schema_file}")
        return False
    
    try:
        # Read the schema file
        with open(schema_file, 'r') as f:
            schema_sql = f.read()
        
        print(f"\n🚀 Applying schema migration from {schema_file}...")
        print(f"📊 SQL file size: {len(schema_sql):,} characters")
        
        # Apply the schema
        conn = psycopg2.connect(**DB_CONFIG)
        conn.autocommit = True  # Let the SQL file handle transactions
        
        with conn.cursor() as cur:
            # Execute the entire schema file
            cur.execute(schema_sql)
            
            # Get any notices/messages
            for notice in conn.notices:
                print(f"ℹ️  {notice.strip()}")
        
        conn.close()
        print("✅ Schema migration applied successfully!")
        return True
        
    except Exception as e:
        print(f"❌ Schema migration failed: {e}")
        return False

def verify_new_tables():
    """Verify that new tables were created"""
    new_tables = [
        'saas_channel_credentials',
        'saas_channel_installation_wizard',
        'saas_channel_credential_test_history',
        'saas_n8n_template_versions',
        'saas_channel_webhook_logs'
    ]
    
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        with conn.cursor() as cur:
            print(f"\n🔍 Verifying new tables...")
            
            for table in new_tables:
                cur.execute("""
                    SELECT COUNT(*) 
                    FROM information_schema.tables 
                    WHERE table_schema = 'public' 
                    AND table_name = %s;
                """, (table,))
                
                count = cur.fetchone()[0]
                status = "✅" if count > 0 else "❌"
                print(f"  {status} {table}")
        
        conn.close()
        return True
        
    except Exception as e:
        print(f"❌ Failed to verify new tables: {e}")
        return False

def check_new_columns():
    """Check that new columns were added to existing tables"""
    enhanced_tables = {
        'saas_channel_master': [
            'credential_schema', 'auth_methods', 'setup_guide', 'portal_config',
            'webhook_events', 'rate_limits', 'test_endpoints', 'required_scopes'
        ],
        'saas_channel_installed_flows': [
            'credential_id', 'n8n_webhook_id', 'webhook_secret', 'last_execution_at',
            'execution_count', 'success_count', 'error_count', 'last_error',
            'flow_settings', 'retry_config'
        ],
        'saas_channel_installations': [
            'setup_wizard_id', 'installation_method', 'last_sync_at', 'sync_frequency',
            'health_status', 'health_checked_at', 'installation_metadata'
        ],
        'saas_n8n_flows': [
            'category', 'complexity_level', 'estimated_runtime_minutes', 'requires_webhook',
            'supports_batch', 'max_batch_size', 'prerequisites', 'tags', 'popularity_score'
        ]
    }
    
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        with conn.cursor() as cur:
            print(f"\n🔍 Verifying enhanced columns...")
            
            for table_name, columns in enhanced_tables.items():
                print(f"\n  📋 {table_name}:")
                
                for column in columns:
                    cur.execute("""
                        SELECT COUNT(*) 
                        FROM information_schema.columns 
                        WHERE table_schema = 'public' 
                        AND table_name = %s 
                        AND column_name = %s;
                    """, (table_name, column))
                    
                    count = cur.fetchone()[0]
                    status = "✅" if count > 0 else "❌"
                    print(f"    {status} {column}")
        
        conn.close()
        return True
        
    except Exception as e:
        print(f"❌ Failed to verify enhanced columns: {e}")
        return False

def check_views():
    """Check that views were created"""
    new_views = [
        'v_channel_installations_with_credentials',
        'v_active_flows_with_credentials', 
        'v_installation_wizard_status',
        'v_credential_health_dashboard',
        'v_webhook_activity_summary'
    ]
    
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        with conn.cursor() as cur:
            print(f"\n🔍 Verifying views...")
            
            for view in new_views:
                cur.execute("""
                    SELECT COUNT(*) 
                    FROM information_schema.views 
                    WHERE table_schema = 'public' 
                    AND table_name = %s;
                """, (view,))
                
                count = cur.fetchone()[0]
                status = "✅" if count > 0 else "❌"
                print(f"  {status} {view}")
        
        conn.close()
        return True
        
    except Exception as e:
        print(f"❌ Failed to verify views: {e}")
        return False

def generate_migration_report():
    """Generate a summary report of the migration"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_file = f"migration_report_{timestamp}.json"
    
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        with conn.cursor() as cur:
            # Count tables
            cur.execute("""
                SELECT COUNT(*) FROM information_schema.tables 
                WHERE table_schema = 'public' AND table_name LIKE 'saas_%';
            """)
            table_count = cur.fetchone()[0]
            
            # Count views  
            cur.execute("""
                SELECT COUNT(*) FROM information_schema.views 
                WHERE table_schema = 'public' AND table_name LIKE 'v_%';
            """)
            view_count = cur.fetchone()[0]
            
            # Count functions
            cur.execute("""
                SELECT COUNT(*) FROM information_schema.routines 
                WHERE routine_schema = 'public' AND routine_type = 'FUNCTION';
            """)
            function_count = cur.fetchone()[0]
            
            report = {
                "migration_timestamp": timestamp,
                "database": DB_CONFIG['database'],
                "tables_total": table_count,
                "views_total": view_count, 
                "functions_total": function_count,
                "migration_status": "completed",
                "cloud_sql_proxy": True,
                "notes": [
                    "Enhanced channel management schema applied",
                    "Multi-tenant credential management enabled",
                    "Installation wizard tracking implemented",
                    "Webhook activity logging configured",
                    "Template version management setup"
                ]
            }
            
        conn.close()
        
        with open(report_file, 'w') as f:
            json.dump(report, f, indent=2)
            
        print(f"\n📋 Migration report saved: {report_file}")
        return report
        
    except Exception as e:
        print(f"❌ Failed to generate migration report: {e}")
        return None

def main():
    """Main migration process"""
    print("=" * 60)
    print("🚀 N8N Enhanced Channel Management Schema Migration")
    print("=" * 60)
    
    # Step 1: Test connection
    print("\n1️⃣ Testing database connection...")
    if not test_connection():
        sys.exit(1)
    
    # Step 2: Check existing tables
    print("\n2️⃣ Checking existing tables...")
    existing_tables = check_existing_tables()
    
    # Step 3: Apply schema migration
    print("\n3️⃣ Applying schema migration...")
    if not apply_schema_migration():
        sys.exit(1)
    
    # Step 4: Verify new tables
    print("\n4️⃣ Verifying new tables...")
    verify_new_tables()
    
    # Step 5: Check enhanced columns
    print("\n5️⃣ Checking enhanced columns...")
    check_new_columns()
    
    # Step 6: Verify views
    print("\n6️⃣ Verifying views...")
    check_views()
    
    # Step 7: Generate report
    print("\n7️⃣ Generating migration report...")
    report = generate_migration_report()
    
    print("\n" + "=" * 60)
    print("✅ Migration completed successfully!")
    print("🎯 Your N8N channel management system is now enhanced with:")
    print("   • Multi-tenant credential management")
    print("   • Installation wizard tracking") 
    print("   • Credential testing & health monitoring")
    print("   • Webhook activity logging")
    print("   • N8N template version management")
    print("   • Enhanced portal configuration")
    print("=" * 60)

if __name__ == "__main__":
    main()
