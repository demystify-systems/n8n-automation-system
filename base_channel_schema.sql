-- =========================================
-- Base N8N Channel Management Schema
-- Foundation tables required for enhanced schema
-- =========================================

BEGIN;

-- =========================================
-- 1) BASE TABLES
-- =========================================

-- Master channel registry
CREATE TABLE IF NOT EXISTS saas_channel_master (
    channel_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_key text NOT NULL UNIQUE,
    channel_name text NOT NULL,
    description text,
    base_url text,
    version text DEFAULT '1.0',
    
    -- Core Configuration
    capabilities jsonb DEFAULT '{}',
    is_active boolean DEFAULT true,
    
    -- Metadata
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- N8N workflow templates
CREATE TABLE IF NOT EXISTS saas_n8n_flows (
    n8n_flow_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_id uuid NOT NULL REFERENCES saas_channel_master(channel_id) ON DELETE CASCADE,
    
    -- Flow Details
    name text NOT NULL,
    description text,
    operation text NOT NULL,  -- 'sync', 'export', 'import', etc.
    
    -- N8N Integration
    n8n_workflow_json jsonb NOT NULL,
    n8n_webhook_path text,
    
    -- Status
    status text NOT NULL DEFAULT 'active',
    
    -- Metadata
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Channel installations per tenant
CREATE TABLE IF NOT EXISTS saas_channel_installations (
    installation_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    saas_edge_id uuid NOT NULL,
    channel_id uuid NOT NULL REFERENCES saas_channel_master(channel_id) ON DELETE CASCADE,
    
    -- Installation Config
    installation_config jsonb NOT NULL DEFAULT '{}',
    
    -- Status
    status text NOT NULL DEFAULT 'active',
    
    -- Metadata
    installed_at timestamptz NOT NULL DEFAULT now(),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Channel flow definitions (default flows per channel)
CREATE TABLE IF NOT EXISTS saas_channel_master_flow_defs (
    flow_def_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_id uuid NOT NULL REFERENCES saas_channel_master(channel_id) ON DELETE CASCADE,
    n8n_flow_id uuid NOT NULL REFERENCES saas_n8n_flows(n8n_flow_id) ON DELETE CASCADE,
    
    -- Configuration
    is_default boolean DEFAULT false,
    is_required boolean DEFAULT false,
    flow_config jsonb DEFAULT '{}',
    
    -- Metadata
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Installed flows per tenant (active flow instances)
CREATE TABLE IF NOT EXISTS saas_channel_installed_flows (
    saas_flow_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    installation_id uuid NOT NULL REFERENCES saas_channel_installations(installation_id) ON DELETE CASCADE,
    channel_id uuid NOT NULL REFERENCES saas_channel_master(channel_id) ON DELETE CASCADE,
    n8n_flow_id uuid NOT NULL REFERENCES saas_n8n_flows(n8n_flow_id) ON DELETE CASCADE,
    saas_edge_id uuid NOT NULL,
    
    -- Flow Instance Config
    flow_config jsonb DEFAULT '{}',
    
    -- N8N Integration
    n8n_workflow_id text,  -- N8N's internal workflow ID for this instance
    
    -- Status
    status text NOT NULL DEFAULT 'active',
    
    -- Metadata
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Job execution tracking
CREATE TABLE IF NOT EXISTS saas_edge_jobs (
    job_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    saas_edge_id uuid NOT NULL,
    saas_flow_id uuid REFERENCES saas_channel_installed_flows(saas_flow_id) ON DELETE CASCADE,
    
    -- Job Details
    job_type text NOT NULL,
    job_status text NOT NULL DEFAULT 'pending',
    
    -- Execution Data
    job_config jsonb DEFAULT '{}',
    job_result jsonb DEFAULT '{}',
    error_message text,
    
    -- N8N Integration
    n8n_execution_id text,
    
    -- Timestamps
    started_at timestamptz NOT NULL DEFAULT now(),
    completed_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- =========================================
-- 2) INDEXES
-- =========================================

-- Channel master indexes
CREATE INDEX IF NOT EXISTS idx_channel_master_key ON saas_channel_master (channel_key);
CREATE INDEX IF NOT EXISTS idx_channel_master_active ON saas_channel_master (is_active);

-- N8N flows indexes
CREATE INDEX IF NOT EXISTS idx_n8n_flows_channel ON saas_n8n_flows (channel_id);
CREATE INDEX IF NOT EXISTS idx_n8n_flows_operation ON saas_n8n_flows (operation);
CREATE INDEX IF NOT EXISTS idx_n8n_flows_status ON saas_n8n_flows (status);

-- Channel installations indexes
CREATE INDEX IF NOT EXISTS idx_installations_edge ON saas_channel_installations (saas_edge_id);
CREATE INDEX IF NOT EXISTS idx_installations_channel ON saas_channel_installations (channel_id);
CREATE INDEX IF NOT EXISTS idx_installations_status ON saas_channel_installations (status);
CREATE UNIQUE INDEX IF NOT EXISTS uq_installations_edge_channel ON saas_channel_installations (saas_edge_id, channel_id);

-- Flow definitions indexes
CREATE INDEX IF NOT EXISTS idx_flow_defs_channel ON saas_channel_master_flow_defs (channel_id);
CREATE INDEX IF NOT EXISTS idx_flow_defs_n8n_flow ON saas_channel_master_flow_defs (n8n_flow_id);
CREATE INDEX IF NOT EXISTS idx_flow_defs_default ON saas_channel_master_flow_defs (is_default);

-- Installed flows indexes
CREATE INDEX IF NOT EXISTS idx_installed_flows_installation ON saas_channel_installed_flows (installation_id);
CREATE INDEX IF NOT EXISTS idx_installed_flows_edge ON saas_channel_installed_flows (saas_edge_id);
CREATE INDEX IF NOT EXISTS idx_installed_flows_channel ON saas_channel_installed_flows (channel_id);
CREATE INDEX IF NOT EXISTS idx_installed_flows_n8n_flow ON saas_channel_installed_flows (n8n_flow_id);
CREATE INDEX IF NOT EXISTS idx_installed_flows_status ON saas_channel_installed_flows (status);

-- Jobs indexes
CREATE INDEX IF NOT EXISTS idx_edge_jobs_edge ON saas_edge_jobs (saas_edge_id);
CREATE INDEX IF NOT EXISTS idx_edge_jobs_flow ON saas_edge_jobs (saas_flow_id);
CREATE INDEX IF NOT EXISTS idx_edge_jobs_type ON saas_edge_jobs (job_type);
CREATE INDEX IF NOT EXISTS idx_edge_jobs_status ON saas_edge_jobs (job_status);
CREATE INDEX IF NOT EXISTS idx_edge_jobs_started ON saas_edge_jobs (started_at);

-- =========================================
-- 3) UTILITY FUNCTIONS
-- =========================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION touch_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================================
-- 4) TRIGGERS
-- =========================================

-- Triggers for updated_at
CREATE TRIGGER trg_touch_channel_master
    BEFORE UPDATE ON saas_channel_master
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TRIGGER trg_touch_n8n_flows
    BEFORE UPDATE ON saas_n8n_flows
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TRIGGER trg_touch_channel_installations
    BEFORE UPDATE ON saas_channel_installations
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TRIGGER trg_touch_flow_defs
    BEFORE UPDATE ON saas_channel_master_flow_defs
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TRIGGER trg_touch_installed_flows
    BEFORE UPDATE ON saas_channel_installed_flows
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TRIGGER trg_touch_edge_jobs
    BEFORE UPDATE ON saas_edge_jobs
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

-- =========================================
-- 5) SAMPLE DATA
-- =========================================

-- Insert sample channels
INSERT INTO saas_channel_master (channel_key, channel_name, description, base_url, capabilities) VALUES
('SHOPIFY', 'Shopify', 'Shopify e-commerce platform integration', 'https://admin.shopify.com', '{"api_version": "2023-10", "supports_webhooks": true}'),
('EBAY', 'eBay', 'eBay marketplace integration', 'https://api.ebay.com', '{"api_version": "v1", "supports_oauth": true}'),
('AMAZON', 'Amazon', 'Amazon marketplace integration', 'https://sellingpartnerapi-na.amazon.com', '{"api_version": "sp-api", "requires_oauth": true}'),
('WOOCOMMERCE', 'WooCommerce', 'WooCommerce integration', 'https://woocommerce.github.io/woocommerce-rest-api-docs', '{"api_version": "v3", "supports_webhooks": true}')
ON CONFLICT (channel_key) DO NOTHING;

-- Insert sample N8N flows
INSERT INTO saas_n8n_flows (channel_id, name, description, operation, n8n_workflow_json, n8n_webhook_path) 
SELECT 
    cm.channel_id,
    cm.channel_name || ' Product Sync',
    'Sync products from ' || cm.channel_name || ' to database',
    'sync',
    '{"nodes": [], "connections": {}}',
    '/webhook/' || LOWER(cm.channel_key) || '/product-sync'
FROM saas_channel_master cm
ON CONFLICT DO NOTHING;

-- =========================================
-- 6) VIEWS
-- =========================================

-- Basic view for channel installations
CREATE OR REPLACE VIEW v_channel_installations AS
SELECT 
    ci.*,
    cm.channel_key,
    cm.channel_name,
    cm.base_url,
    cm.capabilities
FROM saas_channel_installations ci
JOIN saas_channel_master cm ON ci.channel_id = cm.channel_id;

-- Active flows view
CREATE OR REPLACE VIEW v_active_flows AS
SELECT 
    cif.*,
    cm.channel_key,
    cm.channel_name,
    nf.name as flow_name,
    nf.operation as flow_operation
FROM saas_channel_installed_flows cif
JOIN saas_channel_master cm ON cif.channel_id = cm.channel_id
JOIN saas_n8n_flows nf ON cif.n8n_flow_id = nf.n8n_flow_id
WHERE cif.status = 'active';

COMMIT;

-- =========================================
-- SETUP COMPLETE
-- =========================================

-- Display summary
DO $$
BEGIN
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Base N8N Channel Management Schema Created';
    RAISE NOTICE '==========================================';
    RAISE NOTICE '';
    RAISE NOTICE 'Tables created: 6';
    RAISE NOTICE '  - saas_channel_master';
    RAISE NOTICE '  - saas_n8n_flows';
    RAISE NOTICE '  - saas_channel_installations';
    RAISE NOTICE '  - saas_channel_master_flow_defs';
    RAISE NOTICE '  - saas_channel_installed_flows';
    RAISE NOTICE '  - saas_edge_jobs';
    RAISE NOTICE '';
    RAISE NOTICE 'Sample data inserted for: Shopify, eBay, Amazon, WooCommerce';
    RAISE NOTICE 'Ready for enhanced schema migration!';
END $$;
