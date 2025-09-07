-- Add More Popular E-commerce and Business Channels
-- These are commonly requested integrations not in N8N but popular in SaaS platforms
-- Generated: 2025-09-07

BEGIN;

-- Enable UUID extension  
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Update AMAZON with better details (it exists in enum but might need enhancement)
INSERT INTO saas_channel_master (
    channel_key,
    channel_name, 
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'AMAZON',
    'Amazon',
    'https://developer.amazonservices.com',
    'https://developer.amazonservices.com/gp/mws/docs.html',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/amazon.svg',
    '{
        "category": "E-commerce",
        "subcategory": "Marketplace", 
        "description": "Amazon is the worlds largest online marketplace and cloud computing platform, offering seller APIs for inventory, order, and product management.",
        "features": ["orders", "products", "inventory", "fulfillment", "marketplace"],
        "is_popular": true,
        "is_core": false
    }'::jsonb,
    '{
        "category": "E-commerce", 
        "subcategory": "Marketplace",
        "supported_operations": ["orders", "products", "inventory", "fulfillment", "marketplace"],
        "auth_methods": ["aws_signature", "api_key"],
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

-- Update EBAY with better details  
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url, 
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'EBAY',
    'eBay',
    'https://developer.ebay.com/api-docs/static/overview.html',
    'https://developer.ebay.com/api-docs/sell/account/overview.html',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/ebay.svg',
    '{
        "category": "E-commerce",
        "subcategory": "Marketplace",
        "description": "eBay is a global online marketplace where people buy and sell a wide variety of goods and services worldwide.",
        "features": ["listings", "orders", "inventory", "seller_tools", "marketplace"],
        "is_popular": true,
        "is_core": false
    }'::jsonb,
    '{
        "category": "E-commerce",
        "subcategory": "Marketplace", 
        "supported_operations": ["listings", "orders", "inventory", "seller_tools", "marketplace"],
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

-- Add ETSY
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url, 
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'ETSY',
    'Etsy',
    'https://www.etsy.com/developers/documentation/getting_started/api_basics',
    'https://www.etsy.com/developers/documentation',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/etsy.svg',
    '{
        "category": "E-commerce",
        "subcategory": "Marketplace",
        "description": "Etsy is a global online marketplace for unique and creative goods, connecting millions of buyers and sellers around the world.",
        "features": ["listings", "shops", "orders", "inventory", "handmade"],
        "is_popular": true,
        "is_core": false
    }'::jsonb,
    '{
        "category": "E-commerce",
        "subcategory": "Marketplace",
        "supported_operations": ["listings", "shops", "orders", "inventory", "handmade"], 
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

-- Add some additional popular channels that might be useful

-- Add MICROSOFT_OUTLOOK
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'MICROSOFT_OUTLOOK',
    'Microsoft Outlook',
    'https://graph.microsoft.com',
    'https://docs.microsoft.com/en-us/graph/api/resources/mail-api-overview',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/microsoftoutlook.svg',
    '{
        "category": "Communication",
        "subcategory": "Email",
        "description": "Microsoft Outlook is a personal information manager from Microsoft, featuring email, calendar, task manager, contact manager, and more.",
        "features": ["email", "calendar", "contacts", "tasks"],
        "is_popular": true,
        "is_core": false
    }'::jsonb,
    '{
        "category": "Communication", 
        "subcategory": "Email",
        "supported_operations": ["email", "calendar", "contacts", "tasks"],
        "auth_methods": ["oauth2"],
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

-- Add TWILIO
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'TWILIO',
    'Twilio',
    'https://api.twilio.com',
    'https://www.twilio.com/docs/api',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/twilio.svg',
    '{
        "category": "Communication",
        "subcategory": "SMS",
        "description": "Twilio is a cloud communications platform that allows software developers to programmatically make and receive phone calls, send and receive text messages.",
        "features": ["sms", "voice", "video", "messaging"],
        "is_popular": true,
        "is_core": false
    }'::jsonb,
    '{
        "category": "Communication",
        "subcategory": "SMS", 
        "supported_operations": ["sms", "voice", "video", "messaging"],
        "auth_methods": ["api_key", "auth_token"],
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

COMMIT;

-- Verification
SELECT COUNT(*) as total_channels FROM saas_channel_master;

-- Show summary by category
SELECT 
    default_channel_config->>'category' as category,
    COUNT(*) as channel_count
FROM saas_channel_master 
GROUP BY default_channel_config->>'category'
ORDER BY channel_count DESC;

-- Show the newly updated/added channels
SELECT channel_key, channel_name, channel_logo_url,
       default_channel_config->>'category' as category,
       default_channel_config->>'subcategory' as subcategory
FROM saas_channel_master 
WHERE channel_key IN ('AMAZON', 'EBAY', 'ETSY', 'MICROSOFT_OUTLOOK', 'TWILIO')
ORDER BY channel_name;
