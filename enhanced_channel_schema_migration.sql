-- =========================================
-- N8N Channel Integration Complete Migration
-- All Tables, Columns, Indexes, and Functions
-- Version: 2.0 (No RLS)
-- =========================================

BEGIN;

-- =========================================
-- 1) NEW TABLES
-- =========================================

-- Core credential management table
CREATE TABLE IF NOT EXISTS saas_channel_credentials (
  credential_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  saas_edge_id uuid NOT NULL,
  installation_id uuid NOT NULL REFERENCES saas_channel_installations(installation_id) ON DELETE CASCADE,
  channel_id uuid NOT NULL REFERENCES saas_channel_master(channel_id) ON DELETE CASCADE,
  
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
  channel_id uuid NOT NULL REFERENCES saas_channel_master(channel_id),
  
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
  n8n_flow_id uuid NOT NULL REFERENCES saas_n8n_flows(n8n_flow_id) ON DELETE CASCADE,
  
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
  saas_flow_id uuid REFERENCES saas_channel_installed_flows(saas_flow_id) ON DELETE CASCADE,
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
-- 2) ENHANCE EXISTING TABLES - ADD COLUMNS
-- =========================================

-- Enhance saas_channel_master
ALTER TABLE saas_channel_master 
  ADD COLUMN IF NOT EXISTS credential_schema jsonb DEFAULT '{}',      -- JSON schema for credential validation
  ADD COLUMN IF NOT EXISTS auth_methods jsonb DEFAULT '[]',           -- Supported auth methods ['oauth2', 'api_key']
  ADD COLUMN IF NOT EXISTS setup_guide jsonb DEFAULT '{}',            -- Step-by-step setup instructions
  ADD COLUMN IF NOT EXISTS portal_config jsonb DEFAULT '{}',          -- Portal UI configuration
  ADD COLUMN IF NOT EXISTS webhook_events jsonb DEFAULT '[]',         -- Supported webhook events
  ADD COLUMN IF NOT EXISTS rate_limits jsonb DEFAULT '{}',            -- API rate limiting info
  ADD COLUMN IF NOT EXISTS test_endpoints jsonb DEFAULT '{}',         -- Endpoints for credential testing
  ADD COLUMN IF NOT EXISTS required_scopes jsonb DEFAULT '[]';        -- Required OAuth scopes

-- Enhance saas_channel_installed_flows
ALTER TABLE saas_channel_installed_flows
  ADD COLUMN IF NOT EXISTS credential_id uuid REFERENCES saas_channel_credentials(credential_id),
  ADD COLUMN IF NOT EXISTS n8n_webhook_id text,                       -- N8N's webhook ID
  ADD COLUMN IF NOT EXISTS webhook_secret text,                       -- Webhook verification secret
  ADD COLUMN IF NOT EXISTS last_execution_at timestamptz,             -- Last time flow executed
  ADD COLUMN IF NOT EXISTS execution_count integer DEFAULT 0,         -- Total execution count
  ADD COLUMN IF NOT EXISTS success_count integer DEFAULT 0,           -- Successful executions
  ADD COLUMN IF NOT EXISTS error_count integer DEFAULT 0,             -- Failed executions
  ADD COLUMN IF NOT EXISTS last_error jsonb,                          -- Last error details
  ADD COLUMN IF NOT EXISTS flow_settings jsonb DEFAULT '{}',          -- Flow-specific settings
  ADD COLUMN IF NOT EXISTS retry_config jsonb DEFAULT '{}';           -- Retry configuration

-- Enhance saas_channel_installations
ALTER TABLE saas_channel_installations
  ADD COLUMN IF NOT EXISTS setup_wizard_id uuid REFERENCES saas_channel_installation_wizard(wizard_id),
  ADD COLUMN IF NOT EXISTS installation_method text DEFAULT 'portal',  -- 'portal', 'api', 'manual'
  ADD COLUMN IF NOT EXISTS last_sync_at timestamptz,                  -- Last successful sync
  ADD COLUMN IF NOT EXISTS sync_frequency text,                       -- How often to sync
  ADD COLUMN IF NOT EXISTS health_status text DEFAULT 'unknown',      -- 'healthy', 'warning', 'error'
  ADD COLUMN IF NOT EXISTS health_checked_at timestamptz,             -- Last health check
  ADD COLUMN IF NOT EXISTS installation_metadata jsonb DEFAULT '{}';   -- Additional installation data

-- Enhance saas_n8n_flows
ALTER TABLE saas_n8n_flows
  ADD COLUMN IF NOT EXISTS category text,                             -- 'sync', 'export', 'import', etc.
  ADD COLUMN IF NOT EXISTS complexity_level text DEFAULT 'basic',     -- 'basic', 'intermediate', 'advanced'
  ADD COLUMN IF NOT EXISTS estimated_runtime_minutes integer,         -- Expected runtime
  ADD COLUMN IF NOT EXISTS requires_webhook boolean DEFAULT false,    -- Does this flow need webhooks?
  ADD COLUMN IF NOT EXISTS supports_batch boolean DEFAULT false,      -- Can process multiple items?
  ADD COLUMN IF NOT EXISTS max_batch_size integer,                    -- Maximum items per batch
  ADD COLUMN IF NOT EXISTS prerequisites jsonb DEFAULT '[]',          -- Prerequisites for this flow
  ADD COLUMN IF NOT EXISTS tags jsonb DEFAULT '[]',                   -- Searchable tags
  ADD COLUMN IF NOT EXISTS popularity_score integer DEFAULT 0;        -- Usage popularity score

-- =========================================
-- 3) CREATE INDEXES
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

-- Enhanced flow indexes
CREATE INDEX IF NOT EXISTS idx_inst_flows_credential ON saas_channel_installed_flows (credential_id);
CREATE INDEX IF NOT EXISTS idx_inst_flows_last_execution ON saas_channel_installed_flows (last_execution_at);
CREATE INDEX IF NOT EXISTS idx_inst_flows_health ON saas_channel_installed_flows (status, error_count);

-- Enhanced n8n flows indexes
CREATE INDEX IF NOT EXISTS idx_n8n_flows_category ON saas_n8n_flows (category);
CREATE INDEX IF NOT EXISTS idx_n8n_flows_complexity ON saas_n8n_flows (complexity_level);
CREATE INDEX IF NOT EXISTS idx_n8n_flows_popularity ON saas_n8n_flows (popularity_score DESC);
CREATE INDEX IF NOT EXISTS idx_n8n_flows_webhook ON saas_n8n_flows (requires_webhook);

-- =========================================
-- 4) SECURITY FUNCTIONS (NO RLS)
-- =========================================

-- Function to encrypt credential data
CREATE OR REPLACE FUNCTION encrypt_credential_data(data jsonb, encryption_key text)
RETURNS text AS $$
BEGIN
  RETURN encode(encrypt(data::text::bytea, encryption_key::bytea, 'aes'), 'base64');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrypt credential data
CREATE OR REPLACE FUNCTION decrypt_credential_data(encrypted_data text, encryption_key text)
RETURNS jsonb AS $$
BEGIN
  RETURN decrypt(decode(encrypted_data, 'base64'), encryption_key::bytea, 'aes')::text::jsonb;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '{}'::jsonb; -- Return empty object if decryption fails
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION touch_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================================
-- 5) TRIGGERS FOR UPDATED_AT
-- =========================================

-- Add trigger for credentials table
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_touch_channel_credentials') THEN
    CREATE TRIGGER trg_touch_channel_credentials
      BEFORE UPDATE ON saas_channel_credentials
      FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
  END IF;
END $$;

-- Add trigger for wizard table
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_touch_installation_wizard') THEN
    CREATE TRIGGER trg_touch_installation_wizard
      BEFORE UPDATE ON saas_channel_installation_wizard
      FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
  END IF;
END $$;

-- =========================================
-- 6) ENHANCED VIEWS
-- =========================================

-- Enhanced view with credential information
CREATE OR REPLACE VIEW v_channel_installations_with_credentials AS
SELECT 
  ci.*,
  cm.channel_key,
  cm.channel_name,
  cm.base_url,
  cm.capabilities,
  cm.credential_schema,
  cm.portal_config,
  cred.credential_id,
  cred.credential_type,
  cred.status as credential_status,
  cred.last_tested_at as credential_last_tested,
  cred.test_result as credential_test_result
FROM saas_channel_installations ci
LEFT JOIN saas_channel_master cm ON ci.channel_id = cm.channel_id
LEFT JOIN saas_channel_credentials cred ON ci.installation_id = cred.installation_id;

-- View for active flows with credential status
CREATE OR REPLACE VIEW v_active_flows_with_credentials AS
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
LEFT JOIN saas_channel_credentials cred ON cif.credential_id = cred.credential_id
WHERE cif.status = 'active';

-- View for installation wizard progress
CREATE OR REPLACE VIEW v_installation_wizard_status AS
SELECT 
  w.*,
  cm.channel_key,
  cm.channel_name,
  cm.portal_config,
  CASE 
    WHEN w.status = 'completed' THEN 100
    WHEN array_length(COALESCE((w.completed_steps)::text[]::text[], '{}'), 1) IS NULL THEN 0
    ELSE (array_length((w.completed_steps)::text[]::text[], 1) * 100) / 
         GREATEST(array_length((cm.portal_config->'setup_steps')::text[]::text[], 1), 1)
  END as progress_percentage
FROM saas_channel_installation_wizard w
JOIN saas_channel_master cm ON w.channel_id = cm.channel_id;

-- View for credential health dashboard
CREATE OR REPLACE VIEW v_credential_health_dashboard AS
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
  END as health_status,
  COUNT(flows.saas_flow_id) as flows_using_credential
FROM saas_channel_credentials c
JOIN saas_channel_master cm ON c.channel_id = cm.channel_id
LEFT JOIN saas_channel_installed_flows flows ON c.credential_id = flows.credential_id
GROUP BY c.credential_id, c.saas_edge_id, c.credential_name, c.credential_type, 
         c.status, c.last_tested_at, c.expires_at, cm.channel_name, cm.channel_key;

-- View for webhook activity summary
CREATE OR REPLACE VIEW v_webhook_activity_summary AS
SELECT 
  w.saas_edge_id,
  f.channel_id,
  cm.channel_name,
  DATE_TRUNC('hour', w.received_at) as activity_hour,
  COUNT(*) as total_requests,
  COUNT(*) FILTER (WHERE w.processing_status = 'success') as successful_requests,
  COUNT(*) FILTER (WHERE w.processing_status = 'error') as error_requests,
  AVG(w.response_time_ms) as avg_response_time_ms,
  MAX(w.response_time_ms) as max_response_time_ms
FROM saas_channel_webhook_logs w
JOIN saas_channel_installed_flows f ON w.saas_flow_id = f.saas_flow_id
JOIN saas_channel_master cm ON f.channel_id = cm.channel_id
WHERE w.received_at >= now() - INTERVAL '24 hours'
GROUP BY w.saas_edge_id, f.channel_id, cm.channel_name, DATE_TRUNC('hour', w.received_at)
ORDER BY activity_hour DESC;

-- =========================================
-- 7) SAMPLE DATA UPDATES
-- =========================================

-- Update existing channels with enhanced configuration
UPDATE saas_channel_master 
SET 
  credential_schema = CASE channel_key
    WHEN 'SHOPIFY' THEN '{
      "type": "object",
      "required": ["shop_domain", "access_token"],
      "properties": {
        "shop_domain": {
          "type": "string",
          "description": "Your Shopify store domain (e.g., store.myshopify.com)",
          "pattern": "^[a-zA-Z0-9-]+\\.myshopify\\.com$",
          "example": "my-store.myshopify.com"
        },
        "access_token": {
          "type": "string",
          "description": "Shopify Admin API access token",
          "minLength": 32,
          "example": "shpat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        }
      }
    }'::jsonb
    WHEN 'EBAY' THEN '{
      "type": "object", 
      "required": ["client_id", "client_secret", "refresh_token"],
      "properties": {
        "client_id": {
          "type": "string",
          "description": "eBay Developer Account Client ID",
          "example": "YourAppI-d123-4567-8901-234567890123"
        },
        "client_secret": {
          "type": "string", 
          "description": "eBay Developer Account Client Secret",
          "minLength": 20,
          "example": "PRD-1234567890ab-cdef1234-5678-9012"
        },
        "refresh_token": {
          "type": "string",
          "description": "OAuth2 Refresh Token from eBay",
          "minLength": 50,
          "example": "v^1.1#i^1#p^1#r^0#I^3#f^0#t^H4sIAAAAAAAAAOVXa2wUVRS..."
        }
      }
    }'::jsonb
    WHEN 'AMAZON' THEN '{
      "type": "object",
      "required": ["marketplace_id", "refresh_token", "lwa_app_id", "lwa_client_secret"],
      "properties": {
        "marketplace_id": {
          "type": "string",
          "description": "Amazon Marketplace ID",
          "example": "ATVPDKIKX0DER",
          "enum": ["ATVPDKIKX0DER", "A2EUQ1WTGCTBG2", "A1AM78C64UM0Y8"]
        },
        "refresh_token": {
          "type": "string",
          "description": "Amazon SP-API Refresh Token",
          "minLength": 50
        },
        "lwa_app_id": {
          "type": "string", 
          "description": "Login with Amazon App ID",
          "example": "amzn1.application-oa2-client.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        "lwa_client_secret": {
          "type": "string",
          "description": "Login with Amazon Client Secret",
          "minLength": 32
        }
      }
    }'::jsonb
    ELSE '{}'::jsonb
  END,
  auth_methods = CASE channel_key
    WHEN 'SHOPIFY' THEN '["private_app", "oauth2", "api_key"]'::jsonb
    WHEN 'EBAY' THEN '["oauth2"]'::jsonb
    WHEN 'AMAZON' THEN '["oauth2"]'::jsonb
    ELSE '[]'::jsonb
  END,
  portal_config = CASE channel_key
    WHEN 'SHOPIFY' THEN '{
      "setup_steps": [
        "Navigate to your Shopify admin panel",
        "Go to Apps → Develop apps → Create an app",
        "Configure Admin API scopes (read_products, read_orders, etc.)",
        "Install the app and copy the access token",
        "Enter your store domain and access token below"
      ],
      "help_url": "https://help.shopify.com/en/manual/apps/private-apps",
      "test_endpoint": "/admin/api/2023-10/shop.json",
      "required_scopes": ["read_products", "read_orders", "write_products"],
      "icon": "🛍️"
    }'::jsonb
    WHEN 'EBAY' THEN '{
      "setup_steps": [
        "Create eBay Developer Account at developer.ebay.com",
        "Create a new application in your developer dashboard", 
        "Generate production OAuth2 credentials",
        "Complete OAuth2 authorization flow",
        "Copy the refresh token from the response"
      ],
      "help_url": "https://developer.ebay.com/api-docs/static/oauth-tokens.html",
      "test_endpoint": "/sell/inventory/v1/inventory_item",
      "oauth_scopes": ["https://api.ebay.com/oauth/api_scope/sell.inventory"],
      "icon": "🏷️"
    }'::jsonb
    WHEN 'AMAZON' THEN '{
      "setup_steps": [
        "Register as Amazon SP-API developer",
        "Create new application in Seller Central",
        "Complete app authorization process", 
        "Obtain refresh token and LWA credentials",
        "Enter marketplace ID and credentials below"
      ],
      "help_url": "https://developer-docs.amazon.com/sp-api/docs/registering-your-application",
      "test_endpoint": "/orders/v0/orders",
      "required_permissions": ["read_orders", "read_listings"],
      "icon": "📦"
    }'::jsonb
    ELSE '{}'::jsonb
  END,
  webhook_events = CASE channel_key
    WHEN 'SHOPIFY' THEN '["orders/create", "orders/updated", "products/create", "products/update"]'::jsonb
    WHEN 'EBAY' THEN '["item.ended", "item.sold"]'::jsonb
    ELSE '[]'::jsonb
  END,
  test_endpoints = CASE channel_key
    WHEN 'SHOPIFY' THEN '{"health_check": "/admin/api/2023-10/shop.json"}'::jsonb
    WHEN 'EBAY' THEN '{"health_check": "/sell/account/v1/fulfillment_policy"}'::jsonb
    WHEN 'AMAZON' THEN '{"health_check": "/orders/v0/orders"}'::jsonb
    ELSE '{}'::jsonb
  END
WHERE channel_key IN ('SHOPIFY', 'EBAY', 'AMAZON');

-- =========================================
-- 8) COMMENTS AND DOCUMENTATION
-- =========================================

-- Table comments
COMMENT ON TABLE saas_channel_credentials IS 'Secure storage for customer channel credentials with encryption';
COMMENT ON TABLE saas_channel_installation_wizard IS 'Tracks progress through channel setup wizard';
COMMENT ON TABLE saas_channel_credential_test_history IS 'History of credential testing attempts and results';
COMMENT ON TABLE saas_n8n_template_versions IS 'Version management for N8N workflow templates';
COMMENT ON TABLE saas_channel_webhook_logs IS 'Logs of webhook activity and processing results';

-- Column comments
COMMENT ON COLUMN saas_channel_credentials.portal_credential_data IS 'Encrypted credential data from portal form';
COMMENT ON COLUMN saas_channel_master.credential_schema IS 'JSON schema for validating customer credentials';
COMMENT ON COLUMN saas_channel_master.portal_config IS 'Configuration for portal setup wizard';
COMMENT ON COLUMN saas_channel_installed_flows.execution_count IS 'Total number of times this flow has been executed';
COMMENT ON COLUMN saas_channel_webhook_logs.processing_status IS 'Status of webhook processing: success, error, or filtered';

COMMIT;

-- =========================================
-- MIGRATION COMPLETE
-- =========================================

-- Display summary
DO $$
BEGIN
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'N8N Channel Integration Migration Complete';
    RAISE NOTICE '==========================================';
    RAISE NOTICE '';
    RAISE NOTICE 'New tables created: 5';
    RAISE NOTICE '  - saas_channel_credentials';
    RAISE NOTICE '  - saas_channel_installation_wizard';
    RAISE NOTICE '  - saas_channel_credential_test_history';
    RAISE NOTICE '  - saas_n8n_template_versions';
    RAISE NOTICE '  - saas_channel_webhook_logs';
    RAISE NOTICE '';
    RAISE NOTICE 'Tables enhanced: 4';
    RAISE NOTICE '  - saas_channel_master (+8 columns)';
    RAISE NOTICE '  - saas_channel_installed_flows (+9 columns)';
    RAISE NOTICE '  - saas_channel_installations (+7 columns)';
    RAISE NOTICE '  - saas_n8n_flows (+9 columns)';
    RAISE NOTICE '';
    RAISE NOTICE 'Indexes created: 20+';
    RAISE NOTICE 'Views created: 5';
    RAISE NOTICE 'Functions created: 2';
    RAISE NOTICE '';
    RAISE NOTICE 'Ready for N8N portal integration! 🚀';
END $$;
