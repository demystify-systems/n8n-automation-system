-- Add Missing Channels to saas_channel_master
-- These channels exist in your channel_enum but not in N8N integrations
-- Generated: 2025-09-07

BEGIN;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insert BIG_COMMERCE
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'BIG_COMMERCE',
    'BigCommerce',
    'https://api.bigcommerce.com',
    'https://developer.bigcommerce.com/docs/rest-management',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/bigcommerce.svg',
    '{
        "category": "E-commerce",
        "subcategory": "Platform",
        "description": "BigCommerce is a leading SaaS ecommerce platform that empowers merchants of all sizes to build, innovate and grow their businesses online.",
        "features": ["products", "orders", "customers", "webhooks", "inventory"],
        "is_popular": true,
        "is_core": false
    }'::jsonb,
    '{
        "category": "E-commerce",
        "subcategory": "Platform", 
        "supported_operations": ["products", "orders", "customers", "webhooks", "inventory"],
        "auth_methods": ["oauth2", "api_key"],
        "is_popular": true
    }'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert GOOGLE_SHOPPING
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'GOOGLE_SHOPPING',
    'Google Shopping',
    'https://developers.google.com/shopping-content/v2.1',
    'https://developers.google.com/shopping-content/guides/quickstart',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/googleshopping.svg',
    '{
        "category": "E-commerce",
        "subcategory": "Shopping",
        "description": "Google Shopping allows retailers to upload their store and product data to Google and makes their products searchable across Google.",
        "features": ["products", "merchant_center", "shopping_ads", "product_listings"],
        "is_popular": true,
        "is_core": false
    }'::jsonb,
    '{
        "category": "E-commerce",
        "subcategory": "Shopping",
        "supported_operations": ["products", "merchant_center", "shopping_ads", "product_listings"],
        "auth_methods": ["oauth2", "service_account"],
        "is_popular": true
    }'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert MAGENTO
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'MAGENTO',
    'Magento',
    'https://devdocs.magento.com/guides/v2.4/rest/bk-rest.html',
    'https://devdocs.magento.com/guides/v2.4/get-started/bk-get-started-api.html',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/magento.svg',
    '{
        "category": "E-commerce",
        "subcategory": "Platform",
        "description": "Magento is a powerful, open-source ecommerce platform that provides merchants with a unique combination of ease-of-use, flexibility, and control.",
        "features": ["products", "orders", "customers", "categories", "inventory"],
        "is_popular": true,
        "is_core": false
    }'::jsonb,
    '{
        "category": "E-commerce",
        "subcategory": "Platform",
        "supported_operations": ["products", "orders", "customers", "categories", "inventory"],
        "auth_methods": ["oauth2", "api_key", "bearer_token"],
        "is_popular": true
    }'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert MICHAELS (Custom retailer)
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'MICHAELS',
    'Michaels',
    'https://www.michaels.com',
    'https://www.michaels.com',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Michaels_logo.svg/200px-Michaels_logo.svg.png',
    '{
        "category": "E-commerce",
        "subcategory": "Retail",
        "description": "Michaels is North America largest arts and crafts specialty retailer, providing products and services for makers and do-it-yourself home decorators.",
        "features": ["products", "inventory", "orders", "marketplace"],
        "is_popular": false,
        "is_core": false,
        "custom": true
    }'::jsonb,
    '{
        "category": "E-commerce",
        "subcategory": "Retail",
        "supported_operations": ["products", "inventory", "orders", "marketplace"],
        "auth_methods": ["api_key", "custom"],
        "is_popular": false,
        "custom": true
    }'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

COMMIT;

-- Verification
SELECT COUNT(*) as total_channels FROM saas_channel_master;

-- Show the newly added channels
SELECT channel_key, channel_name, channel_logo_url, 
       default_channel_config->>'category' as category,
       default_channel_config->>'is_popular' as is_popular
FROM saas_channel_master 
WHERE channel_key IN ('BIG_COMMERCE', 'GOOGLE_SHOPPING', 'MAGENTO', 'MICHAELS')
ORDER BY channel_name;

-- Verify all enum channels now exist in master table
SELECT 
    e.enum_val::text as channel_enum,
    CASE WHEN scm.channel_key IS NOT NULL THEN '✅ EXISTS' ELSE '❌ MISSING' END as status
FROM (SELECT unnest(enum_range(NULL::channel_enum)) as enum_val) e 
LEFT JOIN saas_channel_master scm ON e.enum_val::text = scm.channel_key
ORDER BY e.enum_val::text;
