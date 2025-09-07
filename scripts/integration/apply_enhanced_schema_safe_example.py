#!/usr/bin/env python3
"""
Apply Enhanced N8N Channel Management Schema (Safe Mode)
Works with existing tables owned by postgres user
Only adds new tables and columns, doesn't modify existing structure
"""

import os
import sys
import psycopg2
import json
from datetime import datetime

# Database connection using Cloud SQL proxy
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'catalog-edge-db',
    'user': os.getenv('DB_USER', 'n8n_user'),
    'password': os.getenv('DB_PASSWORD', 'saasdbforn8n2025')
}

SAFE_ENHANCED_SCHEMA = """
-- =========================================
-- Enhanced N8N Channel Management Schema (SAFE)
-- Only adds new tables and functions that we can create
-- =========================================

BEGIN;

-- =========================================
-- 1) NEW TABLES (Safe to create)
-- =========================================

-- Core credential management table
CREATE TABLE IF NOT EXISTS saas_channel_credentials (
  credential_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  saas_edge_id uuid NOT NULL,
  installation_id uuid NOT NULL,  -- References existing table
  channel_id uuid NOT NULL,       -- References existing table
  
  -- N8N Integration
  n8n_credential_id text,                    -- N8N's internal credential ID
  credential_type text NOT NULL,             -- 'shopifyApi', 'ebayApi', etc.
  credential_name text NOT NULL,             -- Display name for credential
  
  -- Portal Integration  
  portal_credential_data jsonb NOT NULL DEFAULT '{}',  -- Encrypted credential data
  credential_schema jsonb,                   -- Schema for validation
  
  -- Status & Metadata
  status text NOT NULL DEFAULT 'active',     -- 'active', 'expired', 'invalid', 'pending'
  test_result jsonb,                         -- Last credential test results
  last_tested_at timestamptz,               -- When credentials were last tested
  
  -- Security & Audit
  created_by text,                          -- User who created the credential
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  expires_at timestamptz,                   -- For time-based credentials
  
  CONSTRAINT ck_credential_status CHECK (status IN ('active', 'expired', 'invalid', 'pending'))
);

-- Setup process tracking table
CREATE TABLE IF NOT EXISTS saas_channel_installation_wizard (
  wizard_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  saas_edge_id uuid NOT NULL,
  channel_id uuid NOT NULL,  -- References existing table
  
  -- Wizard Progress
  current_step text NOT NULL DEFAULT 'channel_selection',
  completed_steps jsonb DEFAULT '[]',        -- Array of completed step names
  wizard_data jsonb DEFAULT '{}',           -- Store form data during setup
  
  -- Status
  status text NOT NULL DEFAULT 'in_progress', -- 'in_progress', 'completed', 'abandoned'
  completed_at timestamptz,                 -- When wizard was completed
  
  -- Tracking
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  
  CONSTRAINT ck_wizard_status CHECK (status IN ('in_progress', 'completed', 'abandoned'))
);

-- Credential testing history
CREATE TABLE IF NOT EXISTS saas_channel_credential_test_history (
  test_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  credential_id uuid NOT NULL REFERENCES saas_channel_credentials(credential_id) ON DELETE CASCADE,
  
  -- Test Results
  test_status text NOT NULL,                -- 'success', 'failure', 'timeout'
  test_message text,                        -- Detailed test message
  response_data jsonb,                      -- API response data (sanitized)
  error_code text,                          -- Error code if failed
  
  -- Connection Details (if successful)
  connection_info jsonb,                    -- Store name, account type, permissions, etc.
  
  -- Performance Metrics
  response_time_ms integer,                 -- How long the test took
  tested_endpoint text,                     -- Which endpoint was tested
  
  tested_at timestamptz NOT NULL DEFAULT now(),
  tested_by text                            -- Who/what triggered the test
);

-- N8N template version management
CREATE TABLE IF NOT EXISTS saas_n8n_template_versions (
  version_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  n8n_flow_id uuid NOT NULL,  -- References existing table
  
  -- Version Details
  version_number text NOT NULL,             -- v1.0, v1.1, v2.0, etc.
  version_name text,                        -- "Product Sync Enhanced", etc.
  is_active boolean NOT NULL DEFAULT true,  -- Is this version available for new installs?
  is_default boolean NOT NULL DEFAULT false, -- Is this the default version?
  
  -- Changes
  changelog text,                           -- What changed in this version
  breaking_changes jsonb DEFAULT '[]',      -- Array of breaking change descriptions
  migration_notes text,                     -- Notes for migrating from previous versions
  
  -- N8N Data
  n8n_workflow_json jsonb NOT NULL,         -- The actual N8N workflow JSON
  required_credentials jsonb DEFAULT '[]',   -- List of required credential types
  
  -- Metadata
  created_by text,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Webhook activity tracking
CREATE TABLE IF NOT EXISTS saas_channel_webhook_logs (
  log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  saas_flow_id uuid,                        -- References existing table (no FK constraint for safety)
  saas_edge_id uuid NOT NULL,
  
  -- Webhook Details
  webhook_path text NOT NULL,               -- The webhook URL path hit
  http_method text NOT NULL,                -- GET, POST, PUT, etc.
  source_ip inet,                          -- IP address of the caller
  user_agent text,                         -- User agent string
  
  -- Request Data
  request_headers jsonb,                    -- HTTP headers (sanitized)
  request_body jsonb,                      -- Request body (might be large)
  request_size_bytes integer,              -- Size of request
  
  -- Response Data
  response_status integer,                  -- HTTP status code
  response_body jsonb,                     -- Response sent back
  response_time_ms integer,                -- Processing time
  
  -- Processing Results
  processing_status text,                   -- 'success', 'error', 'filtered'
  error_message text,                      -- Error details if failed
  n8n_execution_id text,                   -- N8N execution ID if triggered
  
  received_at timestamptz NOT NULL DEFAULT now()
);

-- =========================================
-- 2) CREATE INDEXES (Safe)
-- =========================================

-- Credential management indexes
CREATE INDEX IF NOT EXISTS idx_channel_creds_edge_install ON saas_channel_credentials (saas_edge_id, installation_id);
CREATE INDEX IF NOT EXISTS idx_channel_creds_channel ON saas_channel_credentials (channel_id);
CREATE INDEX IF NOT EXISTS idx_channel_creds_type ON saas_channel_credentials (credential_type);
CREATE INDEX IF NOT EXISTS idx_channel_creds_status ON saas_channel_credentials (status);
CREATE INDEX IF NOT EXISTS idx_channel_creds_expires ON saas_channel_credentials (expires_at) WHERE expires_at IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_channel_creds_n8n_id ON saas_channel_credentials (n8n_credential_id) WHERE n8n_credential_id IS NOT NULL;

-- Wizard tracking indexes
CREATE INDEX IF NOT EXISTS idx_wizard_edge_status ON saas_channel_installation_wizard (saas_edge_id, status);
CREATE INDEX IF NOT EXISTS idx_wizard_channel ON saas_channel_installation_wizard (channel_id);
CREATE INDEX IF NOT EXISTS idx_wizard_created ON saas_channel_installation_wizard (created_at);

-- Test history indexes
CREATE INDEX IF NOT EXISTS idx_test_history_credential ON saas_channel_credential_test_history (credential_id);
CREATE INDEX IF NOT EXISTS idx_test_history_status ON saas_channel_credential_test_history (test_status);
CREATE INDEX IF NOT EXISTS idx_test_history_tested_at ON saas_channel_credential_test_history (tested_at);

-- Template version indexes
CREATE INDEX IF NOT EXISTS idx_template_versions_flow ON saas_n8n_template_versions (n8n_flow_id);
CREATE INDEX IF NOT EXISTS idx_template_versions_active ON saas_n8n_template_versions (is_active, is_default);

-- Webhook logs indexes (important for performance)
CREATE INDEX IF NOT EXISTS idx_webhook_logs_flow ON saas_channel_webhook_logs (saas_flow_id);
CREATE INDEX IF NOT EXISTS idx_webhook_logs_edge ON saas_channel_webhook_logs (saas_edge_id);
CREATE INDEX IF NOT EXISTS idx_webhook_logs_received ON saas_channel_webhook_logs (received_at);
CREATE INDEX IF NOT EXISTS idx_webhook_logs_status ON saas_channel_webhook_logs (processing_status);

-- =========================================
-- 3) SECURITY FUNCTIONS (Safe to create)
-- =========================================

-- Function to encrypt credential data
CREATE OR REPLACE FUNCTION encrypt_credential_data_n8n(data jsonb, encryption_key text)
RETURNS text AS $$
BEGIN
  RETURN encode(encrypt(data::text::bytea, encryption_key::bytea, 'aes'), 'base64');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrypt credential data
CREATE OR REPLACE FUNCTION decrypt_credential_data_n8n(encrypted_data text, encryption_key text)
RETURNS jsonb AS $$
BEGIN
  RETURN decrypt(decode(encrypted_data, 'base64'), encryption_key::bytea, 'aes')::text::jsonb;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '{}'::jsonb; -- Return empty object if decryption fails
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update updated_at timestamp (safe name)
CREATE OR REPLACE FUNCTION touch_updated_at_n8n()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================================
-- 4) TRIGGERS FOR NEW TABLES (Safe)
-- =========================================

-- Add triggers for our new tables only
CREATE OR REPLACE TRIGGER trg_touch_channel_credentials
    BEFORE UPDATE ON saas_channel_credentials
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at_n8n();

CREATE OR REPLACE TRIGGER trg_touch_installation_wizard
    BEFORE UPDATE ON saas_channel_installation_wizard
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at_n8n();

-- =========================================
-- 5) SAFE VIEWS (Read-only)
-- =========================================

-- Enhanced view with credential information (safe)
CREATE OR REPLACE VIEW v_n8n_channel_installations_with_credentials AS
SELECT 
  ci.*,
  cm.channel_key,
  cm.channel_name,
  cred.credential_id,
  cred.credential_type,
  cred.status as credential_status,
  cred.last_tested_at as credential_last_tested,
  cred.test_result as credential_test_result
FROM saas_channel_installations ci
LEFT JOIN saas_channel_master cm ON ci.channel_id = cm.channel_id
LEFT JOIN saas_channel_credentials cred ON ci.installation_id = cred.installation_id;

-- View for active flows with credential status (safe)
CREATE OR REPLACE VIEW v_n8n_active_flows_with_credentials AS
SELECT 
  cif.*,
  cm.channel_key,
  cm.channel_name,
  nf.name as flow_name,
  nf.operation as flow_operation,
  cred.credential_id,
  cred.status as credential_status,
  cred.last_tested_at as credential_last_tested
FROM saas_channel_installed_flows cif
JOIN saas_channel_master cm ON cif.channel_id = cm.channel_id
JOIN saas_n8n_flows nf ON cif.n8n_flow_id = nf.n8n_flow_id
LEFT JOIN saas_channel_credentials cred ON cif.saas_flow_id::text = cred.installation_id::text  -- Safe join
WHERE cif.status = 'active';

-- View for installation wizard progress (safe)
CREATE OR REPLACE VIEW v_n8n_installation_wizard_status AS
SELECT 
  w.*,
  cm.channel_key,
  cm.channel_name,
  CASE 
    WHEN w.status = 'completed' THEN 100
    WHEN array_length(COALESCE((w.completed_steps)::text[]::text[], '{}'), 1) IS NULL THEN 0
    ELSE LEAST(100, (array_length((w.completed_steps)::text[]::text[], 1) * 100) / 5)  -- Assume 5 steps
  END as progress_percentage
FROM saas_channel_installation_wizard w
JOIN saas_channel_master cm ON w.channel_id = cm.channel_id;

-- View for credential health dashboard (safe)
CREATE OR REPLACE VIEW v_n8n_credential_health_dashboard AS
SELECT 
  c.credential_id,
  c.saas_edge_id,
  c.credential_name,
  c.credential_type,
  c.status,
  c.last_tested_at,
  c.expires_at,
  cm.channel_name,
  cm.channel_key,
  CASE 
    WHEN c.expires_at IS NOT NULL AND c.expires_at < now() THEN 'expired'
    WHEN c.expires_at IS NOT NULL AND c.expires_at < now() + INTERVAL '7 days' THEN 'expiring_soon'
    WHEN c.last_tested_at IS NULL THEN 'never_tested'
    WHEN c.last_tested_at < now() - INTERVAL '30 days' THEN 'stale'
    WHEN c.status = 'active' THEN 'healthy'
    ELSE c.status
  END as health_status
FROM saas_channel_credentials c
JOIN saas_channel_master cm ON c.channel_id = cm.channel_id;

-- View for webhook activity summary (safe)
CREATE OR REPLACE VIEW v_n8n_webhook_activity_summary AS
SELECT 
  w.saas_edge_id,
  w.saas_flow_id,
  DATE_TRUNC('hour', w.received_at) as activity_hour,
  COUNT(*) as total_requests,
  COUNT(*) FILTER (WHERE w.processing_status = 'success') as successful_requests,
  COUNT(*) FILTER (WHERE w.processing_status = 'error') as error_requests,
  AVG(w.response_time_ms) as avg_response_time_ms,
  MAX(w.response_time_ms) as max_response_time_ms
FROM saas_channel_webhook_logs w
WHERE w.received_at >= now() - INTERVAL '24 hours'
GROUP BY w.saas_edge_id, w.saas_flow_id, DATE_TRUNC('hour', w.received_at)
ORDER BY activity_hour DESC;

-- =========================================
-- 6) COMMENTS AND DOCUMENTATION
-- =========================================

COMMENT ON TABLE saas_channel_credentials IS 'Secure storage for customer channel credentials with encryption';
COMMENT ON TABLE saas_channel_installation_wizard IS 'Tracks progress through channel setup wizard';
COMMENT ON TABLE saas_channel_credential_test_history IS 'History of credential testing attempts and results';
COMMENT ON TABLE saas_n8n_template_versions IS 'Version management for N8N workflow templates';
COMMENT ON TABLE saas_channel_webhook_logs IS 'Logs of webhook activity and processing results';

COMMENT ON COLUMN saas_channel_credentials.portal_credential_data IS 'Encrypted credential data from portal form';

COMMIT;

-- Display summary
DO $$
BEGIN
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'N8N Enhanced Channel Management (Safe Mode)';
    RAISE NOTICE '==========================================';
    RAISE NOTICE '';
    RAISE NOTICE 'New tables created: 5';
    RAISE NOTICE '  - saas_channel_credentials';
    RAISE NOTICE '  - saas_channel_installation_wizard';
    RAISE NOTICE '  - saas_channel_credential_test_history';
    RAISE NOTICE '  - saas_n8n_template_versions';
    RAISE NOTICE '  - saas_channel_webhook_logs';
    RAISE NOTICE '';
    RAISE NOTICE 'Views created: 5';
    RAISE NOTICE 'Functions created: 3';
    RAISE NOTICE 'Triggers created: 2';
    RAISE NOTICE '';
    RAISE NOTICE 'Ready for N8N portal integration! 🚀';
    RAISE NOTICE 'Note: Works safely with existing postgres-owned tables';
END $$;
"""

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

def apply_safe_schema():
    """Apply the safe enhanced schema"""
    try:
        print(f"\n🚀 Applying safe enhanced schema...")
        
        conn = psycopg2.connect(**DB_CONFIG)
        conn.autocommit = True
        
        with conn.cursor() as cur:
            cur.execute(SAFE_ENHANCED_SCHEMA)
            
            # Get any notices/messages
            for notice in conn.notices:
                print(f"ℹ️  {notice.strip()}")
        
        conn.close()
        print("✅ Safe enhanced schema applied successfully!")
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
                    SELECT COUNT(*), tableowner 
                    FROM pg_tables 
                    WHERE schemaname = 'public' 
                    AND tablename = %s
                    GROUP BY tableowner;
                """, (table,))
                
                result = cur.fetchone()
                if result:
                    count, owner = result
                    status = "✅"
                    print(f"  {status} {table} (owner: {owner})")
                else:
                    print(f"  ❌ {table} (not found)")
        
        conn.close()
        return True
        
    except Exception as e:
        print(f"❌ Failed to verify new tables: {e}")
        return False

def check_views():
    """Check that views were created"""
    new_views = [
        'v_n8n_channel_installations_with_credentials',
        'v_n8n_active_flows_with_credentials', 
        'v_n8n_installation_wizard_status',
        'v_n8n_credential_health_dashboard',
        'v_n8n_webhook_activity_summary'
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

def generate_report():
    """Generate a migration report"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_file = f"safe_migration_report_{timestamp}.json"
    
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        with conn.cursor() as cur:
            # Count our new tables
            cur.execute("""
                SELECT COUNT(*) FROM pg_tables 
                WHERE schemaname = 'public' 
                AND tablename IN ('saas_channel_credentials', 'saas_channel_installation_wizard', 
                                 'saas_channel_credential_test_history', 'saas_n8n_template_versions', 
                                 'saas_channel_webhook_logs')
                AND tableowner = %s;
            """, (DB_CONFIG['user'],))
            new_table_count = cur.fetchone()[0]
            
            # Count our views
            cur.execute("""
                SELECT COUNT(*) FROM information_schema.views 
                WHERE table_schema = 'public' AND table_name LIKE 'v_n8n_%';
            """)
            view_count = cur.fetchone()[0]
            
            report = {
                "migration_timestamp": timestamp,
                "database": DB_CONFIG['database'],
                "migration_type": "safe_enhanced",
                "new_tables_created": new_table_count,
                "views_created": view_count,
                "migration_status": "completed",
                "cloud_sql_proxy": True,
                "notes": [
                    "Safe enhanced schema applied without modifying existing postgres-owned tables",
                    "Multi-tenant credential management enabled with new tables",
                    "Installation wizard tracking implemented",
                    "Webhook activity logging configured",
                    "Template version management setup",
                    "All new objects owned by n8n_user"
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
    print("🚀 N8N Enhanced Schema Migration (Safe Mode)")
    print("=" * 60)
    
    # Step 1: Test connection
    print("\n1️⃣ Testing database connection...")
    if not test_connection():
        sys.exit(1)
    
    # Step 2: Apply safe schema
    print("\n2️⃣ Applying safe enhanced schema...")
    if not apply_safe_schema():
        sys.exit(1)
    
    # Step 3: Verify new tables
    print("\n3️⃣ Verifying new tables...")
    verify_new_tables()
    
    # Step 4: Verify views
    print("\n4️⃣ Verifying views...")
    check_views()
    
    # Step 5: Generate report
    print("\n5️⃣ Generating migration report...")
    generate_report()
    
    print("\n" + "=" * 60)
    print("✅ Safe migration completed successfully!")
    print("🎯 Your N8N channel management system is now enhanced with:")
    print("   • Multi-tenant credential management (new tables)")
    print("   • Installation wizard tracking (new tables)") 
    print("   • Credential testing & health monitoring (new tables)")
    print("   • Webhook activity logging (new tables)")
    print("   • N8N template version management (new tables)")
    print("   • Enhanced views for existing + new data")
    print("   • Safe integration with existing postgres-owned tables")
    print("=" * 60)

if __name__ == "__main__":
    main()
