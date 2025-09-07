-- =========================================
-- N8N Integration Channel Master Inserts
-- =========================================
-- 
-- Generated: 2025-09-07T21:58:39.524294
-- Source: JSON File
-- Total Channels: 200
-- Target Table: saas_channel_master
-- Database: catalog-edge-db
--
-- Usage:
--   psql -h DB_HOST -U DB_USER -d catalog-edge-db -f n8n_channel_inserts_20250907_215839.sql
--
-- Rollback:
--   psql -h DB_HOST -U DB_USER -d catalog-edge-db -f n8n_channel_inserts_20250907_215839_rollback.sql
-- =========================================

-- Start transaction
BEGIN;

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Table validation removed - proceeding with insert


-- Insert SLACK: Slack
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
    '350d1a20-c9e2-45d9-9a63-cc689af88988',
    'SLACK',
    'Slack',
    'https://slack.com/api',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.slack/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/slack.svg',
    '{"category":"Communication","subcategory":"Team Chat","description":"Slack integration for Communication","node_name":"n8n-nodes-base.slack","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Team Chat","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert DISCORD: Discord
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
    'c2b6d7f8-0750-4ac3-b477-1d1767e9fed1',
    'DISCORD',
    'Discord',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.discord/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/discord.svg',
    '{"category":"Communication","subcategory":"Team Chat","description":"Discord integration for Communication","node_name":"n8n-nodes-base.discord","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Team Chat","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MICROSOFT_TEAMS: Microsoft Teams
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
    'adf391f3-c796-4f8d-97ab-5548f0ceb4e1',
    'MICROSOFT_TEAMS',
    'Microsoft Teams',
    'https://graph.microsoft.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.microsoftteams/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/microsoft.svg',
    '{"category":"Communication","subcategory":"Team Chat","description":"Microsoft Teams integration for Communication","node_name":"n8n-nodes-base.microsoftteams","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Team Chat","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GMAIL: Gmail
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
    '0fe3bee1-37a1-4182-9712-e0da56ac2525',
    'GMAIL',
    'Gmail',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.gmail/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/gmail.svg',
    '{"category":"Communication","subcategory":"Email","description":"Gmail integration for Communication","node_name":"n8n-nodes-base.gmail","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Email","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MICROSOFT_OUTLOOK: Microsoft Outlook
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
    'a8c88175-8ba9-4d3f-9a1b-f6e855fa2919',
    'MICROSOFT_OUTLOOK',
    'Microsoft Outlook',
    'https://graph.microsoft.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.microsoftoutlook/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/microsoft.svg',
    '{"category":"Communication","subcategory":"Email","description":"Microsoft Outlook integration for Communication","node_name":"n8n-nodes-base.microsoftoutlook","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Email","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SENDGRID: SendGrid
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
    '45585ac3-73fd-4a3d-9193-8349d3ce5631',
    'SENDGRID',
    'SendGrid',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.sendgrid/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/sendgrid.svg',
    '{"category":"Communication","subcategory":"Email","description":"SendGrid integration for Communication","node_name":"n8n-nodes-base.sendgrid","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Email","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TWILIO: Twilio
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
    '37bed7a0-1b35-44c3-a25c-45b228699b5c',
    'TWILIO',
    'Twilio',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.twilio/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/twilio.svg',
    '{"category":"Communication","subcategory":"SMS/Voice","description":"Twilio integration for Communication","node_name":"n8n-nodes-base.twilio","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"SMS/Voice","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TELEGRAM: Telegram
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
    '79fc7345-9643-433d-ac2a-5e4cc188d514',
    'TELEGRAM',
    'Telegram',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.telegram/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/telegram.svg',
    '{"category":"Communication","subcategory":"Messaging","description":"Telegram integration for Communication","node_name":"n8n-nodes-base.telegram","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Messaging","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert WHATSAPP: WhatsApp Business
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
    '38401bdf-fd3f-40ab-aa7a-8bc1d8e393d0',
    'WHATSAPP',
    'WhatsApp Business',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.whatsapp/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/whatsapp.svg',
    '{"category":"Communication","subcategory":"Messaging","description":"WhatsApp Business integration for Communication","node_name":"n8n-nodes-base.whatsapp","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Messaging","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert VONAGE: Vonage
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
    '53aea205-dd63-41b3-8af8-d4fd173bb800',
    'VONAGE',
    'Vonage',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.vonage/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/vonage.svg',
    '{"category":"Communication","subcategory":"SMS/Voice","description":"Vonage integration for Communication","node_name":"n8n-nodes-base.vonage","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"SMS/Voice","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AMAZONSES: Amazon SES
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
    '4b28e3a4-39c8-465e-ba4d-29d345d8a006',
    'AMAZONSES',
    'Amazon SES',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.amazonses/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/amazonses.svg',
    '{"category":"Sales","subcategory":"E-Commerce","description":"Amazon SES integration for Communication","node_name":"n8n-nodes-base.amazonses","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"E-Commerce","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SENDINBLUE: Brevo
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
    'c28fb122-b646-4cd8-8bbf-1bd174735a55',
    'SENDINBLUE',
    'Brevo',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.sendinblue/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/sendinblue.svg',
    '{"category":"Communication","subcategory":"Email","description":"Brevo integration for Communication","node_name":"n8n-nodes-base.sendinblue","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Email","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MATTERMOST: Mattermost
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
    '0c3489c1-1aac-41f2-8077-2b50cd0e2c88',
    'MATTERMOST',
    'Mattermost',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mattermost/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mattermost.svg',
    '{"category":"Communication","subcategory":"Team Chat","description":"Mattermost integration for Communication","node_name":"n8n-nodes-base.mattermost","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Team Chat","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ROCKETCHAT: Rocket.Chat
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
    'a8787eea-6af1-4bcd-b509-d329d76c2630',
    'ROCKETCHAT',
    'Rocket.Chat',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.rocketchat/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/rocketchat.svg',
    '{"category":"Communication","subcategory":"Team Chat","description":"Rocket.Chat integration for Communication","node_name":"n8n-nodes-base.rocketchat","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Team Chat","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SIGNAL: Signal
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
    '47a48443-2a5f-4a02-80d9-91e19d91b02f',
    'SIGNAL',
    'Signal',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.signal/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/signal.svg',
    '{"category":"Communication","subcategory":"Messaging","description":"Signal integration for Communication","node_name":"n8n-nodes-base.signal","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Messaging","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert IMAP: IMAP Email
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
    'a7d7578f-4a98-413b-99de-8d2e7de483da',
    'IMAP',
    'IMAP Email',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.imap/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/imap.svg',
    '{"category":"Communication","subcategory":"Email","description":"IMAP Email integration for Communication","node_name":"n8n-nodes-base.imap","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Email","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SMTP: SMTP Email
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
    '2f32eccc-7095-4126-b43f-848024466da8',
    'SMTP',
    'SMTP Email',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.smtp/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/smtp.svg',
    '{"category":"Communication","subcategory":"Email","description":"SMTP Email integration for Communication","node_name":"n8n-nodes-base.smtp","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Communication","subcategory":"Email","supported_operations":[],"supported_resources":[],"features":["messaging","notifications"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SHOPIFY: Shopify
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
    'd74ac092-4339-4ebd-88b3-76ef85a5adea',
    'SHOPIFY',
    'Shopify',
    'https://admin.shopify.com/admin/api',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.shopify/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/shopify.svg',
    '{"category":"Sales","subcategory":"E-Commerce","description":"Shopify integration for Sales","node_name":"n8n-nodes-base.shopify","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"E-Commerce","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert STRIPE: Stripe
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
    'bb2f82d8-3323-4222-ba7b-50ff4c99acda',
    'STRIPE',
    'Stripe',
    'https://api.stripe.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.stripe/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/stripe.svg',
    '{"category":"Sales","subcategory":"Payment Processing","description":"Stripe integration for Sales","node_name":"n8n-nodes-base.stripe","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Payment Processing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert WOOCOMMERCE: WooCommerce
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
    '393279c8-ee3c-4601-86e8-4e30d39db6d5',
    'WOOCOMMERCE',
    'WooCommerce',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.woocommerce/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/woocommerce.svg',
    '{"category":"Sales","subcategory":"E-Commerce","description":"WooCommerce integration for Sales","node_name":"n8n-nodes-base.woocommerce","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"E-Commerce","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert PAYPAL: PayPal
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
    '69a5964f-e1dc-41ee-8e24-27b4ee1a8344',
    'PAYPAL',
    'PayPal',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.paypal/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/paypal.svg',
    '{"category":"Sales","subcategory":"Payment Processing","description":"PayPal integration for Sales","node_name":"n8n-nodes-base.paypal","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Payment Processing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SQUARE: Square
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
    '8e37c196-a59a-4260-bace-96f188d8becc',
    'SQUARE',
    'Square',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.square/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/square.svg',
    '{"category":"Sales","subcategory":"Payment Processing","description":"Square integration for Sales","node_name":"n8n-nodes-base.square","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Payment Processing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert QUICKBOOKS: QuickBooks
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
    'fba27bbf-1b9f-4b57-af3c-50c813fa853f',
    'QUICKBOOKS',
    'QuickBooks',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.quickbooks/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/quickbooks.svg',
    '{"category":"Sales","subcategory":"Accounting","description":"QuickBooks integration for Sales","node_name":"n8n-nodes-base.quickbooks","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Accounting","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert XERO: Xero
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
    'b2609991-1044-43ce-84bd-3c1cbbb0aa85',
    'XERO',
    'Xero',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.xero/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/xero.svg',
    '{"category":"Sales","subcategory":"Accounting","description":"Xero integration for Sales","node_name":"n8n-nodes-base.xero","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Accounting","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert BIGCOMMERCE: BigCommerce
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
    '436b82db-9b24-4ed9-afef-5ad1346066cf',
    'BIGCOMMERCE',
    'BigCommerce',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.bigcommerce/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/bigcommerce.svg',
    '{"category":"Sales","subcategory":"E-Commerce","description":"BigCommerce integration for Sales","node_name":"n8n-nodes-base.bigcommerce","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"E-Commerce","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MAGENTO2: Magento 2
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
    'eaa2a8a1-a8bc-42d6-b0ff-cfebbd686c82',
    'MAGENTO2',
    'Magento 2',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.magento2/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/magento2.svg',
    '{"category":"Sales","subcategory":"E-Commerce","description":"Magento 2 integration for Sales","node_name":"n8n-nodes-base.magento2","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"E-Commerce","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ETSY: Etsy
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
    'ef6d84c4-1d3e-458e-bdaa-80c99a2fadf0',
    'ETSY',
    'Etsy',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.etsy/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/etsy.svg',
    '{"category":"Sales","subcategory":"E-Commerce","description":"Etsy integration for Sales","node_name":"n8n-nodes-base.etsy","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"E-Commerce","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AMAZON: Amazon MWS
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
    '8cbb9c71-03c0-4371-9944-eb139afe3d41',
    'AMAZON',
    'Amazon MWS',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.amazon/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/amazon.svg',
    '{"category":"Sales","subcategory":"E-Commerce","description":"Amazon MWS integration for Sales","node_name":"n8n-nodes-base.amazon","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"E-Commerce","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert EBAY: eBay
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
    '4a5e78a1-c138-4ff7-81d5-4b0ff1b0d380',
    'EBAY',
    'eBay',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.ebay/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/ebay.svg',
    '{"category":"Sales","subcategory":"E-Commerce","description":"eBay integration for Sales","node_name":"n8n-nodes-base.ebay","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"E-Commerce","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CHARGEBEE: Chargebee
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
    'a8e9556f-d6fa-45e7-a76f-c91989fb9179',
    'CHARGEBEE',
    'Chargebee',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.chargebee/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/chargebee.svg',
    '{"category":"Sales","subcategory":"Billing","description":"Chargebee integration for Sales","node_name":"n8n-nodes-base.chargebee","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Billing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert RECURLY: Recurly
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
    'bb819216-0f6e-4338-8f39-efbd6d701b7d',
    'RECURLY',
    'Recurly',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.recurly/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/recurly.svg',
    '{"category":"Sales","subcategory":"Billing","description":"Recurly integration for Sales","node_name":"n8n-nodes-base.recurly","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Billing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert PADDLE: Paddle
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
    '0b9486fe-8cf0-4be2-bc5f-fe9835b16a2b',
    'PADDLE',
    'Paddle',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.paddle/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/paddle.svg',
    '{"category":"Sales","subcategory":"Billing","description":"Paddle integration for Sales","node_name":"n8n-nodes-base.paddle","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Billing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert LEMONSQUEEZY: Lemon Squeezy
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
    '8f4be93b-59ed-425b-a650-fd888814b43b',
    'LEMONSQUEEZY',
    'Lemon Squeezy',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.lemonsqueezy/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/lemonsqueezy.svg',
    '{"category":"Sales","subcategory":"Billing","description":"Lemon Squeezy integration for Sales","node_name":"n8n-nodes-base.lemonsqueezy","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Billing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert FRESHBOOKS: FreshBooks
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
    '4cb6eba9-a3ad-4d11-909f-db02939deccd',
    'FRESHBOOKS',
    'FreshBooks',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.freshbooks/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/freshbooks.svg',
    '{"category":"Sales","subcategory":"Accounting","description":"FreshBooks integration for Sales","node_name":"n8n-nodes-base.freshbooks","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Accounting","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert WAVE: Wave
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
    '3f0f4c7f-fb8a-46fd-8a4b-9c5ec1fb2675',
    'WAVE',
    'Wave',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.wave/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/wave.svg',
    '{"category":"Sales","subcategory":"Accounting","description":"Wave integration for Sales","node_name":"n8n-nodes-base.wave","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Accounting","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert INVOICENINJA: Invoice Ninja
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
    'dd3fab5a-3f9a-4692-af9d-72fa721a48d8',
    'INVOICENINJA',
    'Invoice Ninja',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.invoiceninja/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/invoiceninja.svg',
    '{"category":"Sales","subcategory":"Invoicing","description":"Invoice Ninja integration for Sales","node_name":"n8n-nodes-base.invoiceninja","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Invoicing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert PANDADOC: PandaDoc
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
    '4d067f4a-9298-4524-ae09-2a9e8e4a9151',
    'PANDADOC',
    'PandaDoc',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.pandadoc/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/pandadoc.svg',
    '{"category":"Sales","subcategory":"Document Management","description":"PandaDoc integration for Sales","node_name":"n8n-nodes-base.pandadoc","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Document Management","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert DOCUSIGN: DocuSign
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
    '87e2dabe-f066-4610-afe6-e7ecdae8641b',
    'DOCUSIGN',
    'DocuSign',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.docusign/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/docusign.svg',
    '{"category":"Sales","subcategory":"Document Management","description":"DocuSign integration for Sales","node_name":"n8n-nodes-base.docusign","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Document Management","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert HELLOSIGN: HelloSign
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
    'a3c4fbb8-9b7a-4208-bdf3-f488c2423a44',
    'HELLOSIGN',
    'HelloSign',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.hellosign/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/hellosign.svg',
    '{"category":"Sales","subcategory":"Document Management","description":"HelloSign integration for Sales","node_name":"n8n-nodes-base.hellosign","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Document Management","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ADYEN: Adyen
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
    'afe629a2-f519-4538-a63b-ca7788b084b3',
    'ADYEN',
    'Adyen',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.adyen/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/adyen.svg',
    '{"category":"Sales","subcategory":"Payment Processing","description":"Adyen integration for Sales","node_name":"n8n-nodes-base.adyen","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Payment Processing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert BRAINTREE: Braintree
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
    '1197c738-cdf7-47f0-9545-e2f9bd704303',
    'BRAINTREE',
    'Braintree',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.braintree/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/braintree.svg',
    '{"category":"Sales","subcategory":"Payment Processing","description":"Braintree integration for Sales","node_name":"n8n-nodes-base.braintree","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Payment Processing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SQUARESPACE: Squarespace
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
    '1aea8099-ba39-415e-b844-9465064ec400',
    'SQUARESPACE',
    'Squarespace',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.squarespace/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/squarespace.svg',
    '{"category":"Sales","subcategory":"Payment Processing","description":"Squarespace integration for Sales","node_name":"n8n-nodes-base.squarespace","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"Payment Processing","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert HUBSPOT: HubSpot
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
    '09b04dad-2add-48b6-8b43-665261b3cf4c',
    'HUBSPOT',
    'HubSpot',
    'https://api.hubapi.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.hubspot/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/hubspot.svg',
    '{"category":"Marketing","subcategory":"CRM","description":"HubSpot integration for Marketing","node_name":"n8n-nodes-base.hubspot","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"CRM","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SALESFORCE: Salesforce
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
    '7da98f71-089f-42f5-862a-4b1a6b125071',
    'SALESFORCE',
    'Salesforce',
    'https://login.salesforce.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.salesforce/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/salesforce.svg',
    '{"category":"Marketing","subcategory":"CRM","description":"Salesforce integration for Marketing","node_name":"n8n-nodes-base.salesforce","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"CRM","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert PIPEDRIVE: Pipedrive
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
    'de170a47-9108-4ef8-bdac-2baac21be0bb',
    'PIPEDRIVE',
    'Pipedrive',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.pipedrive/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/pipedrive.svg',
    '{"category":"Marketing","subcategory":"CRM","description":"Pipedrive integration for Marketing","node_name":"n8n-nodes-base.pipedrive","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"CRM","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MAILCHIMP: Mailchimp
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
    'd6ae099e-84f1-4e4a-9657-a7dc901282dd',
    'MAILCHIMP',
    'Mailchimp',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mailchimp/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mailchimp.svg',
    '{"category":"Marketing","subcategory":"Email Marketing","description":"Mailchimp integration for Marketing","node_name":"n8n-nodes-base.mailchimp","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Email Marketing","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert INTERCOM: Intercom
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
    '84788840-b649-4fd5-b226-01ed5bcb1d98',
    'INTERCOM',
    'Intercom',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.intercom/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/intercom.svg',
    '{"category":"Marketing","subcategory":"Customer Support","description":"Intercom integration for Marketing","node_name":"n8n-nodes-base.intercom","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Customer Support","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ZENDESK: Zendesk
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
    '55818cca-0c17-49da-8b30-91bb5bf08253',
    'ZENDESK',
    'Zendesk',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.zendesk/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/zendesk.svg',
    '{"category":"Marketing","subcategory":"Customer Support","description":"Zendesk integration for Marketing","node_name":"n8n-nodes-base.zendesk","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Customer Support","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TYPEFORM: Typeform
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
    '21f4b986-3408-49b4-89de-849f33d24653',
    'TYPEFORM',
    'Typeform',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.typeform/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/typeform.svg',
    '{"category":"Marketing","subcategory":"Forms","description":"Typeform integration for Marketing","node_name":"n8n-nodes-base.typeform","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Forms","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CALENDLY: Calendly
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
    'b24f6aae-1c7f-445f-b134-84336706e85e',
    'CALENDLY',
    'Calendly',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.calendly/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/calendly.svg',
    '{"category":"Marketing","subcategory":"Scheduling","description":"Calendly integration for Marketing","node_name":"n8n-nodes-base.calendly","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Scheduling","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ZOHOCRM: Zoho CRM
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
    'e7701b0e-07fc-44f2-8cb0-252aa26c6685',
    'ZOHOCRM',
    'Zoho CRM',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.zohocrm/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/zohocrm.svg',
    '{"category":"Marketing","subcategory":"CRM","description":"Zoho CRM integration for Marketing","node_name":"n8n-nodes-base.zohocrm","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"CRM","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert COPPER: Copper
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
    '16766220-cdf5-48dd-ae2c-e3b35d949070',
    'COPPER',
    'Copper',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.copper/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/copper.svg',
    '{"category":"Marketing","subcategory":"CRM","description":"Copper integration for Marketing","node_name":"n8n-nodes-base.copper","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"CRM","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert FRESHSALES: Freshsales
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
    '64931fe0-9813-45a1-bb7c-110e10b3ec10',
    'FRESHSALES',
    'Freshsales',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.freshsales/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/freshsales.svg',
    '{"category":"Marketing","subcategory":"CRM","description":"Freshsales integration for Marketing","node_name":"n8n-nodes-base.freshsales","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"CRM","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CLOSECOM: Close
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
    '567a698d-2166-4a54-9452-661c5c588feb',
    'CLOSECOM',
    'Close',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.closecom/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/closecom.svg',
    '{"category":"Marketing","subcategory":"CRM","description":"Close integration for Marketing","node_name":"n8n-nodes-base.closecom","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"CRM","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CONSTANT_CONTACT: Constant Contact
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
    '9f7a9603-1612-4798-9ddb-bcb37a418b8f',
    'CONSTANT_CONTACT',
    'Constant Contact',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.constantcontact/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/constantcontact.svg',
    '{"category":"Marketing","subcategory":"Email Marketing","description":"Constant Contact integration for Marketing","node_name":"n8n-nodes-base.constantcontact","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Email Marketing","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CAMPAIGN_MONITOR: Campaign Monitor
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
    '38dfc320-63bb-432d-88f3-ca5e7b888564',
    'CAMPAIGN_MONITOR',
    'Campaign Monitor',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.campaignmonitor/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/campaignmonitor.svg',
    '{"category":"Marketing","subcategory":"Email Marketing","description":"Campaign Monitor integration for Marketing","node_name":"n8n-nodes-base.campaignmonitor","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Email Marketing","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AWEBER: AWeber
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
    'cb2503c8-857f-43b1-bdba-40177356412d',
    'AWEBER',
    'AWeber',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.aweber/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/aweber.svg',
    '{"category":"Marketing","subcategory":"Email Marketing","description":"AWeber integration for Marketing","node_name":"n8n-nodes-base.aweber","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Email Marketing","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CONVERTKIT: ConvertKit
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
    '252266d3-f801-45b6-a607-94944e550e63',
    'CONVERTKIT',
    'ConvertKit',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.convertkit/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/convertkit.svg',
    '{"category":"Marketing","subcategory":"Email Marketing","description":"ConvertKit integration for Marketing","node_name":"n8n-nodes-base.convertkit","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Email Marketing","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ACTIVE_CAMPAIGN: ActiveCampaign
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
    '712fc537-0323-4d1d-8eb9-d87c00801c26',
    'ACTIVE_CAMPAIGN',
    'ActiveCampaign',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.activecampaign/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/activecampaign.svg',
    '{"category":"Marketing","subcategory":"Email Marketing","description":"ActiveCampaign integration for Marketing","node_name":"n8n-nodes-base.activecampaign","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Email Marketing","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GETRESPONSE: GetResponse
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
    '8142f448-58db-4fa4-a4d3-ee1de8526480',
    'GETRESPONSE',
    'GetResponse',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.getresponse/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/getresponse.svg',
    '{"category":"Marketing","subcategory":"Email Marketing","description":"GetResponse integration for Marketing","node_name":"n8n-nodes-base.getresponse","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Email Marketing","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MAILJET: Mailjet
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
    'de77baa7-cb50-4453-ad08-eda99b6e52c3',
    'MAILJET',
    'Mailjet',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mailjet/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mailjet.svg',
    '{"category":"Marketing","subcategory":"Email Marketing","description":"Mailjet integration for Marketing","node_name":"n8n-nodes-base.mailjet","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Email Marketing","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert FRESHDESK: Freshdesk
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
    '4295f2b2-5b97-44f0-be37-a6388deb121e',
    'FRESHDESK',
    'Freshdesk',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.freshdesk/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/freshdesk.svg',
    '{"category":"Marketing","subcategory":"Customer Support","description":"Freshdesk integration for Marketing","node_name":"n8n-nodes-base.freshdesk","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Customer Support","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert HELPSCOUT: Help Scout
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
    '77070551-dcd7-47af-98d3-fcb6d6ebe038',
    'HELPSCOUT',
    'Help Scout',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.helpscout/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/helpscout.svg',
    '{"category":"Marketing","subcategory":"Customer Support","description":"Help Scout integration for Marketing","node_name":"n8n-nodes-base.helpscout","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Customer Support","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert DRIFT: Drift
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
    'b8198291-b553-4fb2-a93c-d54b9cfc088a',
    'DRIFT',
    'Drift',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.drift/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/drift.svg',
    '{"category":"Marketing","subcategory":"Customer Support","description":"Drift integration for Marketing","node_name":"n8n-nodes-base.drift","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Customer Support","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CRISP: Crisp
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
    '89b7f5d8-ac28-4c5c-85d7-50f5dd5f83de',
    'CRISP',
    'Crisp',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.crisp/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/crisp.svg',
    '{"category":"Marketing","subcategory":"Customer Support","description":"Crisp integration for Marketing","node_name":"n8n-nodes-base.crisp","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Customer Support","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert JOTFORM: JotForm
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
    '75ee37b5-e85a-4094-8d0d-0375b9142a7d',
    'JOTFORM',
    'JotForm',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.jotform/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/jotform.svg',
    '{"category":"Marketing","subcategory":"Forms","description":"JotForm integration for Marketing","node_name":"n8n-nodes-base.jotform","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Forms","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert WUFOO: Wufoo
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
    'df516a17-69f9-410e-a945-5ef41e68040a',
    'WUFOO',
    'Wufoo',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.wufoo/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/wufoo.svg',
    '{"category":"Marketing","subcategory":"Forms","description":"Wufoo integration for Marketing","node_name":"n8n-nodes-base.wufoo","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Forms","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert FORMSTACK: Formstack
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
    '7458df78-7ba2-45f9-9e8c-83ba874fa143',
    'FORMSTACK',
    'Formstack',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.formstack/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/formstack.svg',
    '{"category":"Marketing","subcategory":"Forms","description":"Formstack integration for Marketing","node_name":"n8n-nodes-base.formstack","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Forms","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SURVEYMONKEY: SurveyMonkey
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
    '6638eff4-7b89-4a80-863b-2df817f8a77e',
    'SURVEYMONKEY',
    'SurveyMonkey',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.surveymonkey/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/surveymonkey.svg',
    '{"category":"Marketing","subcategory":"Surveys","description":"SurveyMonkey integration for Marketing","node_name":"n8n-nodes-base.surveymonkey","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Surveys","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ACUITYSCHEDULING: Acuity Scheduling
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
    'de210721-ef7d-42e2-85a6-f0fee1d56f1c',
    'ACUITYSCHEDULING',
    'Acuity Scheduling',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.acuityscheduling/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/acuityscheduling.svg',
    '{"category":"Marketing","subcategory":"Scheduling","description":"Acuity Scheduling integration for Marketing","node_name":"n8n-nodes-base.acuityscheduling","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Scheduling","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert BOOKINGCOM: Booking.com
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
    '121f05d6-cb96-48d4-a655-c63d7ece24d5',
    'BOOKINGCOM',
    'Booking.com',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.bookingcom/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/bookingcom.svg',
    '{"category":"Marketing","subcategory":"Booking","description":"Booking.com integration for Marketing","node_name":"n8n-nodes-base.bookingcom","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Booking","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert LEADFEEDER: Leadfeeder
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
    '6c1dd047-e157-4044-a94a-46de076a3c0a',
    'LEADFEEDER',
    'Leadfeeder',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.leadfeeder/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/leadfeeder.svg',
    '{"category":"Marketing","subcategory":"Lead Generation","description":"Leadfeeder integration for Marketing","node_name":"n8n-nodes-base.leadfeeder","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Marketing","subcategory":"Lead Generation","supported_operations":[],"supported_resources":[],"features":["campaigns","analytics"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLE_DRIVE: Google Drive
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
    'd930b9cb-afeb-49d4-9e40-d00edefc3cea',
    'GOOGLE_DRIVE',
    'Google Drive',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googledrive/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Drive integration for Productivity","node_name":"n8n-nodes-base.googledrive","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLE_SHEETS: Google Sheets
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
    '29b135cb-4d05-4c1a-a44f-28b70618285f',
    'GOOGLE_SHEETS',
    'Google Sheets',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlesheets/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Sheets integration for Productivity","node_name":"n8n-nodes-base.googlesheets","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLE_DOCS: Google Docs
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
    'a5d12530-8e61-4ac3-93e8-6e69bfe389a0',
    'GOOGLE_DOCS',
    'Google Docs',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googledocs/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Docs integration for Productivity","node_name":"n8n-nodes-base.googledocs","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLESLIDES: Google Slides
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
    '2082c8bc-e439-4f0b-ac72-5b25b6fb6f06',
    'GOOGLESLIDES',
    'Google Slides',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googleslides/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Slides integration for Productivity","node_name":"n8n-nodes-base.googleslides","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLEFORMS: Google Forms
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
    '8a42231e-7042-4db0-a83b-1928fcd59cae',
    'GOOGLEFORMS',
    'Google Forms',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googleforms/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Forms integration for Productivity","node_name":"n8n-nodes-base.googleforms","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLE_CALENDAR: Google Calendar
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
    '2ef9299b-5751-4d88-8e9e-de6f3a53ab10',
    'GOOGLE_CALENDAR',
    'Google Calendar',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlecalendar/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Calendar integration for Productivity","node_name":"n8n-nodes-base.googlecalendar","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLETASKS: Google Tasks
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
    'e58d4038-300d-4a04-b0dc-f9a1471f20ec',
    'GOOGLETASKS',
    'Google Tasks',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googletasks/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Tasks integration for Productivity","node_name":"n8n-nodes-base.googletasks","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MICROSOFT_ONEDRIVE: Microsoft OneDrive
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
    '16e79bc4-82fd-426b-aeb6-89324133ad03',
    'MICROSOFT_ONEDRIVE',
    'Microsoft OneDrive',
    'https://graph.microsoft.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.microsoftonedrive/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/microsoft.svg',
    '{"category":"Productivity","subcategory":"Microsoft 365","description":"Microsoft OneDrive integration for Productivity","node_name":"n8n-nodes-base.microsoftonedrive","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Microsoft 365","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MICROSOFT_EXCEL: Microsoft Excel
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
    'e97bcd4e-bc6b-49d5-a978-2cd3278998ff',
    'MICROSOFT_EXCEL',
    'Microsoft Excel',
    'https://graph.microsoft.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.microsoftexcel/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/microsoft.svg',
    '{"category":"Productivity","subcategory":"Microsoft 365","description":"Microsoft Excel integration for Productivity","node_name":"n8n-nodes-base.microsoftexcel","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Microsoft 365","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MICROSOFTTODO: Microsoft To Do
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
    '68f035be-8b12-4e64-be19-680fb23f3df7',
    'MICROSOFTTODO',
    'Microsoft To Do',
    'https://graph.microsoft.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.microsofttodo/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/microsoft.svg',
    '{"category":"Productivity","subcategory":"Microsoft 365","description":"Microsoft To Do integration for Productivity","node_name":"n8n-nodes-base.microsofttodo","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Microsoft 365","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert NOTION: Notion
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
    'd072ebec-b4c2-4c47-8288-475a3377ea80',
    'NOTION',
    'Notion',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.notion/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/notion.svg',
    '{"category":"Productivity","subcategory":"Knowledge Management","description":"Notion integration for Productivity","node_name":"n8n-nodes-base.notion","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Knowledge Management","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AIRTABLE: Airtable
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
    '89394311-4db2-45f4-a933-f8fb654a7698',
    'AIRTABLE',
    'Airtable',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.airtable/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/airtable.svg',
    '{"category":"Productivity","subcategory":"Database","description":"Airtable integration for Productivity","node_name":"n8n-nodes-base.airtable","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Database","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TRELLO: Trello
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
    '963a9333-8804-4aa9-9302-973bd1e52da3',
    'TRELLO',
    'Trello',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.trello/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/trello.svg',
    '{"category":"Productivity","subcategory":"Project Management","description":"Trello integration for Productivity","node_name":"n8n-nodes-base.trello","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Project Management","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ASANA: Asana
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
    '32e2dec4-3954-43b9-9413-0f47a8cb0f23',
    'ASANA',
    'Asana',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.asana/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/asana.svg',
    '{"category":"Productivity","subcategory":"Project Management","description":"Asana integration for Productivity","node_name":"n8n-nodes-base.asana","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Project Management","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MONDAY: Monday.com
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
    'ca3b0828-57c4-4228-b30d-aeb472220dc2',
    'MONDAY',
    'Monday.com',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.monday/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/monday.svg',
    '{"category":"Productivity","subcategory":"Project Management","description":"Monday.com integration for Productivity","node_name":"n8n-nodes-base.monday","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Project Management","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CLICKUP: ClickUp
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
    '04cb59da-86a3-469a-880c-e3e9d11e13a7',
    'CLICKUP',
    'ClickUp',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.clickup/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/clickup.svg',
    '{"category":"Productivity","subcategory":"Project Management","description":"ClickUp integration for Productivity","node_name":"n8n-nodes-base.clickup","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Project Management","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert BASEROW: Baserow
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
    '032c31d8-e101-4f80-b585-164457b55354',
    'BASEROW',
    'Baserow',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.baserow/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/baserow.svg',
    '{"category":"Productivity","subcategory":"Database","description":"Baserow integration for Productivity","node_name":"n8n-nodes-base.baserow","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Database","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CODA: Coda
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
    '6d7a940d-964a-44c5-821f-dd7d31de554b',
    'CODA',
    'Coda',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.coda/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/coda.svg',
    '{"category":"Productivity","subcategory":"Documents","description":"Coda integration for Productivity","node_name":"n8n-nodes-base.coda","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Documents","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TODOIST: Todoist
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
    '14d3f3bd-0630-4f7d-84c7-fbc9e27dbf93',
    'TODOIST',
    'Todoist',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.todoist/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/todoist.svg',
    '{"category":"Productivity","subcategory":"Task Management","description":"Todoist integration for Productivity","node_name":"n8n-nodes-base.todoist","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Task Management","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert WRIKE: Wrike
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
    'caeb4f26-b67a-4493-83be-e4a2a8d45e4b',
    'WRIKE',
    'Wrike',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.wrike/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/wrike.svg',
    '{"category":"Productivity","subcategory":"Project Management","description":"Wrike integration for Productivity","node_name":"n8n-nodes-base.wrike","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Project Management","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SMARTSHEET: Smartsheet
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
    '4377f756-0b03-4f0d-b7f1-5d184a876fb5',
    'SMARTSHEET',
    'Smartsheet',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.smartsheet/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/smartsheet.svg',
    '{"category":"Productivity","subcategory":"Project Management","description":"Smartsheet integration for Productivity","node_name":"n8n-nodes-base.smartsheet","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Project Management","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert DROPBOX: Dropbox
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
    'f8782d0e-5a37-4327-ba26-77dcd15e251a',
    'DROPBOX',
    'Dropbox',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.dropbox/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/dropbox.svg',
    '{"category":"Productivity","subcategory":"File Storage","description":"Dropbox integration for Productivity","node_name":"n8n-nodes-base.dropbox","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"File Storage","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert BOX: Box
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
    '16b2b3eb-b5bf-4dc1-a2da-9b28ad149adf',
    'BOX',
    'Box',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.box/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/box.svg',
    '{"category":"Productivity","subcategory":"File Storage","description":"Box integration for Productivity","node_name":"n8n-nodes-base.box","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"File Storage","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AMAZONS3: Amazon S3
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
    'b37e7097-5b7e-4bbb-a9fb-266ecd552f4c',
    'AMAZONS3',
    'Amazon S3',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.amazons3/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/amazons3.svg',
    '{"category":"Sales","subcategory":"E-Commerce","description":"Amazon S3 integration for Productivity","node_name":"n8n-nodes-base.amazons3","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"E-Commerce","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert FTP: FTP
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
    'fecb97ef-2407-4de5-976a-5860655f855e',
    'FTP',
    'FTP',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.ftp/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/ftp.svg',
    '{"category":"Productivity","subcategory":"File Storage","description":"FTP integration for Productivity","node_name":"n8n-nodes-base.ftp","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"File Storage","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SFTP: SFTP
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
    '92b4f956-0cb5-442c-b69e-a91924eb0973',
    'SFTP',
    'SFTP',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.sftp/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/sftp.svg',
    '{"category":"Productivity","subcategory":"File Storage","description":"SFTP integration for Productivity","node_name":"n8n-nodes-base.sftp","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"File Storage","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert OBSIDIAN: Obsidian
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
    '3688aa0d-118b-4220-a803-0d908fd9243c',
    'OBSIDIAN',
    'Obsidian',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.obsidian/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/obsidian.svg',
    '{"category":"Productivity","subcategory":"Note Taking","description":"Obsidian integration for Productivity","node_name":"n8n-nodes-base.obsidian","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Note Taking","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ONENOTE: OneNote
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
    'b02773a6-1c6f-4b14-87b1-c8ba9a91ee45',
    'ONENOTE',
    'OneNote',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.onenote/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/onenote.svg',
    '{"category":"Productivity","subcategory":"Note Taking","description":"OneNote integration for Productivity","node_name":"n8n-nodes-base.onenote","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Note Taking","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert EVERNOTE: Evernote
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
    '6d6546e6-aaa2-488f-a67b-014d17fbf136',
    'EVERNOTE',
    'Evernote',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.evernote/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/evernote.svg',
    '{"category":"Productivity","subcategory":"Note Taking","description":"Evernote integration for Productivity","node_name":"n8n-nodes-base.evernote","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Note Taking","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CONFLUENCE: Confluence
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
    'ef27f102-3131-422c-932e-ac11b6e17bef',
    'CONFLUENCE',
    'Confluence',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.confluence/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/confluence.svg',
    '{"category":"Productivity","subcategory":"Knowledge Management","description":"Confluence integration for Productivity","node_name":"n8n-nodes-base.confluence","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Knowledge Management","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SHAREPOINT: SharePoint
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
    'b132d9f7-8004-4f82-a12e-60f988c92e8c',
    'SHAREPOINT',
    'SharePoint',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.sharepoint/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/sharepoint.svg',
    '{"category":"Productivity","subcategory":"Knowledge Management","description":"SharePoint integration for Productivity","node_name":"n8n-nodes-base.sharepoint","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Knowledge Management","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TOGGL: Toggl
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
    'dbff1653-d578-4b17-91fe-b24e3f651967',
    'TOGGL',
    'Toggl',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.toggl/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/toggl.svg',
    '{"category":"Productivity","subcategory":"Time Tracking","description":"Toggl integration for Productivity","node_name":"n8n-nodes-base.toggl","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Time Tracking","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert HARVEST: Harvest
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
    '314b2ae4-ef91-46bc-a059-4a2c5ca42870',
    'HARVEST',
    'Harvest',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.harvest/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/harvest.svg',
    '{"category":"Productivity","subcategory":"Time Tracking","description":"Harvest integration for Productivity","node_name":"n8n-nodes-base.harvest","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Time Tracking","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CLOCKWISE: Clockwise
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
    'bc49895d-7d62-4075-80da-42afb39c9e88',
    'CLOCKWISE',
    'Clockwise',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.clockwise/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/clockwise.svg',
    '{"category":"Productivity","subcategory":"Time Tracking","description":"Clockwise integration for Productivity","node_name":"n8n-nodes-base.clockwise","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Time Tracking","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert RESCUETIME: RescueTime
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
    'ddc87296-5461-4e22-860f-917c843d062b',
    'RESCUETIME',
    'RescueTime',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.rescuetime/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/rescuetime.svg',
    '{"category":"Productivity","subcategory":"Time Tracking","description":"RescueTime integration for Productivity","node_name":"n8n-nodes-base.rescuetime","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Time Tracking","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ICALENDAR: iCalendar
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
    'eca87268-e837-4728-a823-5c370904f2f1',
    'ICALENDAR',
    'iCalendar',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.icalendar/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/icalendar.svg',
    '{"category":"Productivity","subcategory":"Calendar","description":"iCalendar integration for Productivity","node_name":"n8n-nodes-base.icalendar","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Calendar","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert WHEN2MEET: When2meet
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
    'f55e672d-aef0-4a59-a381-8c25b4d56a43',
    'WHEN2MEET',
    'When2meet',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.when2meet/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/when2meet.svg',
    '{"category":"Productivity","subcategory":"Scheduling","description":"When2meet integration for Productivity","node_name":"n8n-nodes-base.when2meet","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Scheduling","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MIRO: Miro
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
    'da279c79-8470-48b4-a6bd-8c33d94a3a21',
    'MIRO',
    'Miro',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.miro/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/miro.svg',
    '{"category":"Productivity","subcategory":"Collaboration","description":"Miro integration for Productivity","node_name":"n8n-nodes-base.miro","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Collaboration","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert FIGMA: Figma
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
    '31d06ef5-c3c4-440b-963d-510a45767789',
    'FIGMA',
    'Figma',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.figma/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/figma.svg',
    '{"category":"Productivity","subcategory":"Design","description":"Figma integration for Productivity","node_name":"n8n-nodes-base.figma","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Design","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CANVA: Canva
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
    '800952a9-f68c-4f38-8c6b-4372a7d53580',
    'CANVA',
    'Canva',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.canva/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/canva.svg',
    '{"category":"Productivity","subcategory":"Design","description":"Canva integration for Productivity","node_name":"n8n-nodes-base.canva","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Design","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TWITTER: Twitter/X
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
    'be45a3ce-9a39-4306-ab10-68f5f6ecb099',
    'TWITTER',
    'Twitter/X',
    'https://api.twitter.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.twitter/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/twitter.svg',
    '{"category":"Social Media","subcategory":"Social Networking","description":"Twitter/X integration for Social Media","node_name":"n8n-nodes-base.twitter","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Social Networking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert LINKEDIN: LinkedIn
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
    'a7f824be-83ea-41cc-a3a1-dd88cf8896c3',
    'LINKEDIN',
    'LinkedIn',
    'https://api.linkedin.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.linkedin/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/linkedin.svg',
    '{"category":"Social Media","subcategory":"Professional Networking","description":"LinkedIn integration for Social Media","node_name":"n8n-nodes-base.linkedin","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Professional Networking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert FACEBOOK: Facebook
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
    '022067fc-f9f8-4a30-80d3-a9efc75534bb',
    'FACEBOOK',
    'Facebook',
    'https://graph.facebook.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.facebook/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/facebook.svg',
    '{"category":"Social Media","subcategory":"Social Networking","description":"Facebook integration for Social Media","node_name":"n8n-nodes-base.facebook","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Social Networking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert INSTAGRAM: Instagram
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
    '821309b6-bea5-4826-b485-33b1161758a2',
    'INSTAGRAM',
    'Instagram',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.instagram/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/instagram.svg',
    '{"category":"Social Media","subcategory":"Social Networking","description":"Instagram integration for Social Media","node_name":"n8n-nodes-base.instagram","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Social Networking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert YOUTUBE: YouTube
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
    '31b31dc4-120d-403d-99d2-4bbe98ef9a65',
    'YOUTUBE',
    'YouTube',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.youtube/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/youtube.svg',
    '{"category":"Social Media","subcategory":"Video Platform","description":"YouTube integration for Social Media","node_name":"n8n-nodes-base.youtube","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Video Platform","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TIKTOK: TikTok
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
    '63390021-5df0-44c1-b6e4-cccf3147523d',
    'TIKTOK',
    'TikTok',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.tiktok/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/tiktok.svg',
    '{"category":"Social Media","subcategory":"Video Platform","description":"TikTok integration for Social Media","node_name":"n8n-nodes-base.tiktok","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Video Platform","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert PINTEREST: Pinterest
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
    'd3a5ae68-50ab-497c-88ff-bb31bcb7055d',
    'PINTEREST',
    'Pinterest',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.pinterest/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/pinterest.svg',
    '{"category":"Social Media","subcategory":"Visual Platform","description":"Pinterest integration for Social Media","node_name":"n8n-nodes-base.pinterest","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Visual Platform","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert REDDIT: Reddit
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
    '1b91006b-2713-4a49-b95d-529d250d68e6',
    'REDDIT',
    'Reddit',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.reddit/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/reddit.svg',
    '{"category":"Social Media","subcategory":"Forum","description":"Reddit integration for Social Media","node_name":"n8n-nodes-base.reddit","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Forum","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MASTODON: Mastodon
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
    'ee0cefc5-36c2-47fe-b94e-440860df01b5',
    'MASTODON',
    'Mastodon',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mastodon/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mastodon.svg',
    '{"category":"Social Media","subcategory":"Social Networking","description":"Mastodon integration for Social Media","node_name":"n8n-nodes-base.mastodon","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Social Networking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MEDIUM: Medium
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
    '9ed47a44-c238-403d-9e4e-ad0d43c202a8',
    'MEDIUM',
    'Medium',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.medium/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/medium.svg',
    '{"category":"Social Media","subcategory":"Publishing","description":"Medium integration for Social Media","node_name":"n8n-nodes-base.medium","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Publishing","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert WORDPRESS: WordPress
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
    '5cb545e5-c447-4b5c-b89f-8e182d462f56',
    'WORDPRESS',
    'WordPress',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.wordpress/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/wordpress.svg',
    '{"category":"Social Media","subcategory":"Publishing","description":"WordPress integration for Social Media","node_name":"n8n-nodes-base.wordpress","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Publishing","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GHOST: Ghost
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
    'bdeed011-7733-4e19-a5e1-a7e6ed853291',
    'GHOST',
    'Ghost',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.ghost/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/ghost.svg',
    '{"category":"Social Media","subcategory":"Publishing","description":"Ghost integration for Social Media","node_name":"n8n-nodes-base.ghost","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Publishing","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SUBSTACK: Substack
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
    'f61014f8-29f2-458d-9105-89b5fb931aeb',
    'SUBSTACK',
    'Substack',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.substack/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/substack.svg',
    '{"category":"Social Media","subcategory":"Publishing","description":"Substack integration for Social Media","node_name":"n8n-nodes-base.substack","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Publishing","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert DEVTO: Dev.to
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
    'e11a17b3-507d-4758-aa8e-85a5c0a7db74',
    'DEVTO',
    'Dev.to',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.devto/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/devto.svg',
    '{"category":"Social Media","subcategory":"Developer Community","description":"Dev.to integration for Social Media","node_name":"n8n-nodes-base.devto","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Developer Community","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert HACKERNEWS: Hacker News
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
    '6fc0ec6a-a7ee-4473-91e6-6cc00f2d053c',
    'HACKERNEWS',
    'Hacker News',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.hackernews/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/hackernews.svg',
    '{"category":"Social Media","subcategory":"Developer Community","description":"Hacker News integration for Social Media","node_name":"n8n-nodes-base.hackernews","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Developer Community","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert PRODUCTHUNT: Product Hunt
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
    '7ff5fbfb-cf92-43cb-a2fa-ff069709eacc',
    'PRODUCTHUNT',
    'Product Hunt',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.producthunt/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/producthunt.svg',
    '{"category":"Social Media","subcategory":"Product Discovery","description":"Product Hunt integration for Social Media","node_name":"n8n-nodes-base.producthunt","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Product Discovery","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert UNSPLASH: Unsplash
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
    'bebbef7f-4108-4cb6-ac9f-6c7d139ba759',
    'UNSPLASH',
    'Unsplash',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.unsplash/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/unsplash.svg',
    '{"category":"Social Media","subcategory":"Photography","description":"Unsplash integration for Social Media","node_name":"n8n-nodes-base.unsplash","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Photography","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert PEXELS: Pexels
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
    '3b4c3e38-246d-4ddd-a74f-02e062f10613',
    'PEXELS',
    'Pexels',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.pexels/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/pexels.svg',
    '{"category":"Social Media","subcategory":"Photography","description":"Pexels integration for Social Media","node_name":"n8n-nodes-base.pexels","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Photography","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert FLICKR: Flickr
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
    'b1912d19-b6dd-4172-a723-e1c1b03f9b5d',
    'FLICKR',
    'Flickr',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.flickr/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flickr.svg',
    '{"category":"Social Media","subcategory":"Photography","description":"Flickr integration for Social Media","node_name":"n8n-nodes-base.flickr","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Photography","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert VIMEO: Vimeo
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
    '4b9aebe0-87d0-44b1-92a5-ae8ae35d0781',
    'VIMEO',
    'Vimeo',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.vimeo/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/vimeo.svg',
    '{"category":"Social Media","subcategory":"Video Platform","description":"Vimeo integration for Social Media","node_name":"n8n-nodes-base.vimeo","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Video Platform","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TWITCH: Twitch
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
    '40debcbd-8148-4ccf-98bb-d26571b42c45',
    'TWITCH',
    'Twitch',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.twitch/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/twitch.svg',
    '{"category":"Social Media","subcategory":"Streaming Platform","description":"Twitch integration for Social Media","node_name":"n8n-nodes-base.twitch","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Streaming Platform","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SPOTIFY: Spotify
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
    '4a513a4e-5130-414a-a846-c47c8d97b597',
    'SPOTIFY',
    'Spotify',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.spotify/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/spotify.svg',
    '{"category":"Social Media","subcategory":"Music Platform","description":"Spotify integration for Social Media","node_name":"n8n-nodes-base.spotify","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Music Platform","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SOUNDCLOUD: SoundCloud
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
    '45e643d8-80ac-4faf-ac84-3c3b7d2d4182',
    'SOUNDCLOUD',
    'SoundCloud',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.soundcloud/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/soundcloud.svg',
    '{"category":"Social Media","subcategory":"Music Platform","description":"SoundCloud integration for Social Media","node_name":"n8n-nodes-base.soundcloud","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Music Platform","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert BANDCAMP: Bandcamp
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
    'fc609e5e-bc1f-47ac-9244-d6dd6278f5c9',
    'BANDCAMP',
    'Bandcamp',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.bandcamp/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/bandcamp.svg',
    '{"category":"Social Media","subcategory":"Music Platform","description":"Bandcamp integration for Social Media","node_name":"n8n-nodes-base.bandcamp","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Music Platform","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SNAPCHAT: Snapchat
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
    '84a4bcda-edde-4527-972f-d7d5657b5738',
    'SNAPCHAT',
    'Snapchat',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.snapchat/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/snapchat.svg',
    '{"category":"Social Media","subcategory":"Social Networking","description":"Snapchat integration for Social Media","node_name":"n8n-nodes-base.snapchat","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Social Networking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert OPENAI: OpenAI
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
    '2924ab56-9f36-4659-bace-f44ba18319ff',
    'OPENAI',
    'OpenAI',
    'https://api.openai.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.openai/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/openai.svg',
    '{"category":"AI","subcategory":"Language Models","description":"OpenAI integration for AI","node_name":"n8n-nodes-base.openai","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Language Models","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ANTHROPIC: Anthropic Claude
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
    '500daaa5-8b01-4c59-86ea-0cfc6a7aef43',
    'ANTHROPIC',
    'Anthropic Claude',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.anthropic/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/anthropic.svg',
    '{"category":"AI","subcategory":"Language Models","description":"Anthropic Claude integration for AI","node_name":"n8n-nodes-base.anthropic","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Language Models","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert COHERE: Cohere
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
    '2b900ac5-8a86-4797-812f-d3229d79d15c',
    'COHERE',
    'Cohere',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.cohere/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/cohere.svg',
    '{"category":"AI","subcategory":"Language Models","description":"Cohere integration for AI","node_name":"n8n-nodes-base.cohere","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Language Models","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert HUGGINGFACE: Hugging Face
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
    '7647700c-92ac-4cab-86a2-43eca9f22764',
    'HUGGINGFACE',
    'Hugging Face',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.huggingface/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/huggingface.svg',
    '{"category":"AI","subcategory":"Machine Learning","description":"Hugging Face integration for AI","node_name":"n8n-nodes-base.huggingface","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Machine Learning","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert REPLICATE: Replicate
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
    '56f34000-4368-423f-a8f9-bca5e289791a',
    'REPLICATE',
    'Replicate',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.replicate/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/replicate.svg',
    '{"category":"AI","subcategory":"Machine Learning","description":"Replicate integration for AI","node_name":"n8n-nodes-base.replicate","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Machine Learning","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert STABILITYAI: Stability AI
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
    '9a8d527e-de06-47b7-a3af-981f85a542e9',
    'STABILITYAI',
    'Stability AI',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.stabilityai/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/stabilityai.svg',
    '{"category":"AI","subcategory":"Image Generation","description":"Stability AI integration for AI","node_name":"n8n-nodes-base.stabilityai","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Image Generation","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MIDJOURNEY: Midjourney
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
    '40c841ee-e0b9-4ce9-ac85-571c8489bbfd',
    'MIDJOURNEY',
    'Midjourney',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.midjourney/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/midjourney.svg',
    '{"category":"AI","subcategory":"Image Generation","description":"Midjourney integration for AI","node_name":"n8n-nodes-base.midjourney","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Image Generation","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert DALLE: DALL-E
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
    '216501d4-52fd-4c6a-8bb2-5cd7de42fe76',
    'DALLE',
    'DALL-E',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.dalle/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/dalle.svg',
    '{"category":"AI","subcategory":"Image Generation","description":"DALL-E integration for AI","node_name":"n8n-nodes-base.dalle","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Image Generation","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ELEVENLABS: ElevenLabs
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
    'baedcdbc-4b42-4675-8010-9740d71c8ca3',
    'ELEVENLABS',
    'ElevenLabs',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.elevenlabs/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/elevenlabs.svg',
    '{"category":"AI","subcategory":"Voice Synthesis","description":"ElevenLabs integration for AI","node_name":"n8n-nodes-base.elevenlabs","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Voice Synthesis","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert ASSEMBLYAI: AssemblyAI
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
    'faee7115-e419-4ec0-ab15-c4a5f35f11e6',
    'ASSEMBLYAI',
    'AssemblyAI',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.assemblyai/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/assemblyai.svg',
    '{"category":"AI","subcategory":"Speech Recognition","description":"AssemblyAI integration for AI","node_name":"n8n-nodes-base.assemblyai","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Speech Recognition","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert DEEPL: DeepL
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
    'dd644fc5-b98b-4622-ac22-b25b6cc4cd11',
    'DEEPL',
    'DeepL',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.deepl/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/deepl.svg',
    '{"category":"AI","subcategory":"Translation","description":"DeepL integration for AI","node_name":"n8n-nodes-base.deepl","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Translation","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLETRANSLATE: Google Translate
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
    '01f234a0-38cb-4b89-998f-6b21665683f3',
    'GOOGLETRANSLATE',
    'Google Translate',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googletranslate/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Translate integration for AI","node_name":"n8n-nodes-base.googletranslate","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AMAZONCOMPREHEND: Amazon Comprehend
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
    '77687679-83b2-4380-acf5-c87c4c711bed',
    'AMAZONCOMPREHEND',
    'Amazon Comprehend',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.amazoncomprehend/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/amazoncomprehend.svg',
    '{"category":"Sales","subcategory":"E-Commerce","description":"Amazon Comprehend integration for AI","node_name":"n8n-nodes-base.amazoncomprehend","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Sales","subcategory":"E-Commerce","supported_operations":[],"supported_resources":[],"features":["transactions","inventory"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AZURECOGNITIVE: Azure Cognitive Services
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
    'b016c4b6-5bf3-44da-b57e-2da60aebf03d',
    'AZURECOGNITIVE',
    'Azure Cognitive Services',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.azurecognitive/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/azurecognitive.svg',
    '{"category":"Development","subcategory":"Cloud Infrastructure","description":"Azure Cognitive Services integration for AI","node_name":"n8n-nodes-base.azurecognitive","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Cloud Infrastructure","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLEVISION: Google Vision AI
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
    '8451c28d-20a9-435a-b8f0-eeeba2eda6db',
    'GOOGLEVISION',
    'Google Vision AI',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlevision/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Vision AI integration for AI","node_name":"n8n-nodes-base.googlevision","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CLARIFAI: Clarifai
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
    '5e2ad418-2866-4705-8731-30c651ae4f45',
    'CLARIFAI',
    'Clarifai',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.clarifai/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/clarifai.svg',
    '{"category":"AI","subcategory":"Computer Vision","description":"Clarifai integration for AI","node_name":"n8n-nodes-base.clarifai","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Computer Vision","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TEXTRAZOR: TextRazor
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
    '5c6907d5-49e8-48b0-8c3a-7715642cb8c5',
    'TEXTRAZOR',
    'TextRazor',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.textrazor/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/textrazor.svg',
    '{"category":"AI","subcategory":"Natural Language Processing","description":"TextRazor integration for AI","node_name":"n8n-nodes-base.textrazor","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Natural Language Processing","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SENTIMENTAI: Sentiment.ai
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
    'd1053e68-f5c8-403c-a975-0daef4bd2b45',
    'SENTIMENTAI',
    'Sentiment.ai',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.sentimentai/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/sentimentai.svg',
    '{"category":"AI","subcategory":"Sentiment Analysis","description":"Sentiment.ai integration for AI","node_name":"n8n-nodes-base.sentimentai","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Sentiment Analysis","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MONKEYLEARN: MonkeyLearn
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
    '203cfa35-e607-4499-9cf7-e2b0744fb854',
    'MONKEYLEARN',
    'MonkeyLearn',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.monkeylearn/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/monkeylearn.svg',
    '{"category":"AI","subcategory":"Machine Learning","description":"MonkeyLearn integration for AI","node_name":"n8n-nodes-base.monkeylearn","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Machine Learning","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert WOLFRAM: Wolfram Alpha
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
    '2a292480-93f0-4235-bf08-e976e8a67ab5',
    'WOLFRAM',
    'Wolfram Alpha',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.wolfram/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/wolfram.svg',
    '{"category":"AI","subcategory":"Knowledge Engine","description":"Wolfram Alpha integration for AI","node_name":"n8n-nodes-base.wolfram","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"AI","subcategory":"Knowledge Engine","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GITHUB: GitHub
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
    '3e6a7874-385f-4cc1-a55d-d310cafd23ac',
    'GITHUB',
    'GitHub',
    'https://api.github.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.github/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/github.svg',
    '{"category":"Development","subcategory":"Version Control","description":"GitHub integration for Development","node_name":"n8n-nodes-base.github","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Version Control","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GITLAB: GitLab
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
    '72783ad3-80b9-4744-88c6-06acfda4e62c',
    'GITLAB',
    'GitLab',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.gitlab/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/gitlab.svg',
    '{"category":"Development","subcategory":"Version Control","description":"GitLab integration for Development","node_name":"n8n-nodes-base.gitlab","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Version Control","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert BITBUCKET: Bitbucket
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
    '8e2dc6ed-b9b3-4bb1-b56a-32d2cf9bf9f8',
    'BITBUCKET',
    'Bitbucket',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.bitbucket/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/bitbucket.svg',
    '{"category":"Development","subcategory":"Version Control","description":"Bitbucket integration for Development","node_name":"n8n-nodes-base.bitbucket","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Version Control","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AZUREDEVOPS: Azure DevOps
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
    'a67f75d7-0e4e-4f4f-9625-9324c786c9dc',
    'AZUREDEVOPS',
    'Azure DevOps',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.azuredevops/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/azuredevops.svg',
    '{"category":"Development","subcategory":"Cloud Infrastructure","description":"Azure DevOps integration for Development","node_name":"n8n-nodes-base.azuredevops","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Cloud Infrastructure","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert JIRA: Jira
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
    'd91516f5-064d-4baa-ad83-1b5795d66fae',
    'JIRA',
    'Jira',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.jira/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/jira.svg',
    '{"category":"Development","subcategory":"Issue Tracking","description":"Jira integration for Development","node_name":"n8n-nodes-base.jira","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Issue Tracking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert LINEAR: Linear
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
    '0334f955-0e47-4342-bb0e-2561e2ee08ec',
    'LINEAR',
    'Linear',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.linear/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/linear.svg',
    '{"category":"Development","subcategory":"Issue Tracking","description":"Linear integration for Development","node_name":"n8n-nodes-base.linear","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Issue Tracking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert YOUTRACK: YouTrack
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
    'd7584b50-ade4-4cdf-b218-9b165b194b8a',
    'YOUTRACK',
    'YouTrack',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.youtrack/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/youtrack.svg',
    '{"category":"Development","subcategory":"Issue Tracking","description":"YouTrack integration for Development","node_name":"n8n-nodes-base.youtrack","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Issue Tracking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SHORTCUT: Shortcut
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
    '26ce973a-eeab-4e1c-a87b-9aef7c2d8f19',
    'SHORTCUT',
    'Shortcut',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.shortcut/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/shortcut.svg',
    '{"category":"Development","subcategory":"Issue Tracking","description":"Shortcut integration for Development","node_name":"n8n-nodes-base.shortcut","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Issue Tracking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert JENKINS: Jenkins
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
    '9eb369bc-43da-4c42-817e-75d54cbea099',
    'JENKINS',
    'Jenkins',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.jenkins/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/jenkins.svg',
    '{"category":"Development","subcategory":"CI/CD","description":"Jenkins integration for Development","node_name":"n8n-nodes-base.jenkins","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"CI/CD","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert CIRCLECI: CircleCI
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
    'e3ce61cd-2b65-4a02-9828-4b1e051466a2',
    'CIRCLECI',
    'CircleCI',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.circleci/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/circleci.svg',
    '{"category":"Development","subcategory":"CI/CD","description":"CircleCI integration for Development","node_name":"n8n-nodes-base.circleci","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"CI/CD","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TRAVISCI: Travis CI
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
    '9e1bcd2e-4619-45d6-8a3e-e2c8f4c5d74b',
    'TRAVISCI',
    'Travis CI',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.travisci/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/travisci.svg',
    '{"category":"Development","subcategory":"CI/CD","description":"Travis CI integration for Development","node_name":"n8n-nodes-base.travisci","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"CI/CD","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GITHUBACTIONS: GitHub Actions
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
    '80e7b747-d272-4739-a623-0a7c22cc9452',
    'GITHUBACTIONS',
    'GitHub Actions',
    'https://api.github.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.githubactions/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/github.svg',
    '{"category":"Development","subcategory":"Version Control","description":"GitHub Actions integration for Development","node_name":"n8n-nodes-base.githubactions","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Version Control","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AWSEC2: AWS EC2
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
    'cd04e23d-b7e2-4fb0-8f5b-fdb4960bea03',
    'AWSEC2',
    'AWS EC2',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.awsec2/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/awsec2.svg',
    '{"category":"Development","subcategory":"Cloud Infrastructure","description":"AWS EC2 integration for Development","node_name":"n8n-nodes-base.awsec2","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Cloud Infrastructure","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AWSLAMBDA: AWS Lambda
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
    'c0a1ea98-0af7-4e2f-8c5e-05e69d070693',
    'AWSLAMBDA',
    'AWS Lambda',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.awslambda/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/awslambda.svg',
    '{"category":"Development","subcategory":"Cloud Infrastructure","description":"AWS Lambda integration for Development","node_name":"n8n-nodes-base.awslambda","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Cloud Infrastructure","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLECLOUD: Google Cloud
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
    '592a72f8-29a1-42a8-85c9-09d9dfca95d6',
    'GOOGLECLOUD',
    'Google Cloud',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlecloud/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Cloud integration for Development","node_name":"n8n-nodes-base.googlecloud","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AZURE: Microsoft Azure
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
    '3e12f917-4460-4ee4-be07-aa56a597f855',
    'AZURE',
    'Microsoft Azure',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.azure/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/azure.svg',
    '{"category":"Development","subcategory":"Cloud Infrastructure","description":"Microsoft Azure integration for Development","node_name":"n8n-nodes-base.azure","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Cloud Infrastructure","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert DIGITALOCEAN: DigitalOcean
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
    '4ff4146f-197b-4255-a12e-20d4dcd72058',
    'DIGITALOCEAN',
    'DigitalOcean',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.digitalocean/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/digitalocean.svg',
    '{"category":"Development","subcategory":"Cloud Infrastructure","description":"DigitalOcean integration for Development","node_name":"n8n-nodes-base.digitalocean","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Cloud Infrastructure","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert LINODE: Linode
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
    'cdabedf2-6162-4040-af17-6713aa0ee8c3',
    'LINODE',
    'Linode',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.linode/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/linode.svg',
    '{"category":"Development","subcategory":"Cloud Infrastructure","description":"Linode integration for Development","node_name":"n8n-nodes-base.linode","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Cloud Infrastructure","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert VULTR: Vultr
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
    '333e70f2-109f-4cfb-bb3f-1bda21f3242a',
    'VULTR',
    'Vultr',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.vultr/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/vultr.svg',
    '{"category":"Development","subcategory":"Cloud Infrastructure","description":"Vultr integration for Development","node_name":"n8n-nodes-base.vultr","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Cloud Infrastructure","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert DATADOG: Datadog
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
    'e4bdba8a-9060-47a3-a52d-f1fae726e73e',
    'DATADOG',
    'Datadog',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.datadog/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/datadog.svg',
    '{"category":"Development","subcategory":"Monitoring","description":"Datadog integration for Development","node_name":"n8n-nodes-base.datadog","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Monitoring","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert NEWRELIC: New Relic
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
    '18d19cfc-e252-4c58-ad32-a82d055704c1',
    'NEWRELIC',
    'New Relic',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.newrelic/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/newrelic.svg',
    '{"category":"Development","subcategory":"Monitoring","description":"New Relic integration for Development","node_name":"n8n-nodes-base.newrelic","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Monitoring","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SENTRY: Sentry
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
    '15d29a0a-01ae-4b38-a7b9-416b19f39c85',
    'SENTRY',
    'Sentry',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.sentry/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/sentry.svg',
    '{"category":"Development","subcategory":"Error Tracking","description":"Sentry integration for Development","node_name":"n8n-nodes-base.sentry","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Error Tracking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GRAFANA: Grafana
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
    'e06f2303-8062-44cf-83fe-0b3ea94056e0',
    'GRAFANA',
    'Grafana',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.grafana/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/grafana.svg',
    '{"category":"Development","subcategory":"Monitoring","description":"Grafana integration for Development","node_name":"n8n-nodes-base.grafana","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Monitoring","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert PROMETHEUS: Prometheus
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
    '420632b7-fee1-4ca1-8122-bc67b2b22ec5',
    'PROMETHEUS',
    'Prometheus',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.prometheus/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/prometheus.svg',
    '{"category":"Development","subcategory":"Monitoring","description":"Prometheus integration for Development","node_name":"n8n-nodes-base.prometheus","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Monitoring","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert UPTIMEROBOT: UptimeRobot
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
    '02fd8bb7-da36-4e77-99e9-936056cf9693',
    'UPTIMEROBOT',
    'UptimeRobot',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.uptimerobot/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/uptimerobot.svg',
    '{"category":"Development","subcategory":"Monitoring","description":"UptimeRobot integration for Development","node_name":"n8n-nodes-base.uptimerobot","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Monitoring","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert PINGDOM: Pingdom
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
    'a9bfafa4-70cc-448d-adbf-9cec753abab6',
    'PINGDOM',
    'Pingdom',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.pingdom/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/pingdom.svg',
    '{"category":"Development","subcategory":"Monitoring","description":"Pingdom integration for Development","node_name":"n8n-nodes-base.pingdom","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Monitoring","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MYSQL: MySQL
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
    'dece8058-a301-4694-9c9f-6dec33696b84',
    'MYSQL',
    'MySQL',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mysql/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mysql.svg',
    '{"category":"Development","subcategory":"Database","description":"MySQL integration for Development","node_name":"n8n-nodes-base.mysql","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Database","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert POSTGRESQL: PostgreSQL
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
    '44246a0f-ed39-452f-94b9-e14b06758b41',
    'POSTGRESQL',
    'PostgreSQL',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.postgresql/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/postgresql.svg',
    '{"category":"Development","subcategory":"Database","description":"PostgreSQL integration for Development","node_name":"n8n-nodes-base.postgresql","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Database","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MONGODB: MongoDB
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
    'ed2e25f3-15a2-461d-8266-730d48080b42',
    'MONGODB',
    'MongoDB',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mongodb/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mongodb.svg',
    '{"category":"Development","subcategory":"Database","description":"MongoDB integration for Development","node_name":"n8n-nodes-base.mongodb","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Database","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert REDIS: Redis
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
    '3c33b4f4-1cc3-4713-8666-5f3e47be5d7b',
    'REDIS',
    'Redis',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.redis/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/redis.svg',
    '{"category":"Development","subcategory":"Database","description":"Redis integration for Development","node_name":"n8n-nodes-base.redis","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Development","subcategory":"Database","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLE_ANALYTICS: Google Analytics
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
    '1fddfc84-ce36-42e7-99e2-f51c685cc60e',
    'GOOGLE_ANALYTICS',
    'Google Analytics',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googleanalytics/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Analytics integration for Analytics","node_name":"n8n-nodes-base.googleanalytics","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert MIXPANEL: Mixpanel
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
    'b2e2a05f-4db3-4428-ae70-a3b063b71e19',
    'MIXPANEL',
    'Mixpanel',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mixpanel/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mixpanel.svg',
    '{"category":"Analytics","subcategory":"Product Analytics","description":"Mixpanel integration for Analytics","node_name":"n8n-nodes-base.mixpanel","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Analytics","subcategory":"Product Analytics","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert AMPLITUDE: Amplitude
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
    '6cd493c0-60fa-4331-aaf4-f9b8a905c107',
    'AMPLITUDE',
    'Amplitude',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.amplitude/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/amplitude.svg',
    '{"category":"Analytics","subcategory":"Product Analytics","description":"Amplitude integration for Analytics","node_name":"n8n-nodes-base.amplitude","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Analytics","subcategory":"Product Analytics","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert SEGMENT: Segment
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
    '3b09d0a8-5efe-4ea5-8f69-27cb750d7e95',
    'SEGMENT',
    'Segment',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.segment/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/segment.svg',
    '{"category":"Analytics","subcategory":"Customer Data Platform","description":"Segment integration for Analytics","node_name":"n8n-nodes-base.segment","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Analytics","subcategory":"Customer Data Platform","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert HOTJAR: Hotjar
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
    'edc7013f-4279-4f61-b65a-9575d6a5ca3e',
    'HOTJAR',
    'Hotjar',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.hotjar/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/hotjar.svg',
    '{"category":"Analytics","subcategory":"User Experience","description":"Hotjar integration for Analytics","node_name":"n8n-nodes-base.hotjar","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Analytics","subcategory":"User Experience","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert FULLSTORY: FullStory
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
    '7c247db9-ebfc-4b76-b1a4-eb1e1eae63ba',
    'FULLSTORY',
    'FullStory',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.fullstory/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/fullstory.svg',
    '{"category":"Analytics","subcategory":"User Experience","description":"FullStory integration for Analytics","node_name":"n8n-nodes-base.fullstory","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Analytics","subcategory":"User Experience","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert HEAP: Heap
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
    '5cd9e109-1205-45a3-9706-4c2b2e15490f',
    'HEAP',
    'Heap',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.heap/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/heap.svg',
    '{"category":"Analytics","subcategory":"Product Analytics","description":"Heap integration for Analytics","node_name":"n8n-nodes-base.heap","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Analytics","subcategory":"Product Analytics","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert POSTHOG: PostHog
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
    '5b91ab66-881f-431b-8e53-b08e375edaca',
    'POSTHOG',
    'PostHog',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.posthog/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/posthog.svg',
    '{"category":"Analytics","subcategory":"Product Analytics","description":"PostHog integration for Analytics","node_name":"n8n-nodes-base.posthog","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Analytics","subcategory":"Product Analytics","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert GOOGLEADS: Google Ads
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
    'a6b32416-8205-451b-a2e1-657c31f3c0ad',
    'GOOGLEADS',
    'Google Ads',
    'https://www.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googleads/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    '{"category":"Productivity","subcategory":"Google Workspace","description":"Google Ads integration for Analytics","node_name":"n8n-nodes-base.googleads","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Productivity","subcategory":"Google Workspace","supported_operations":[],"supported_resources":[],"features":["collaboration","automation"]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert FACEBOOKPIXEL: Facebook Pixel
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
    '44070aa6-379c-4820-89e3-de8b6884193f',
    'FACEBOOKPIXEL',
    'Facebook Pixel',
    'https://graph.facebook.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.facebookpixel/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/facebook.svg',
    '{"category":"Social Media","subcategory":"Social Networking","description":"Facebook Pixel integration for Analytics","node_name":"n8n-nodes-base.facebookpixel","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Social Media","subcategory":"Social Networking","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert TABLEAU: Tableau
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
    '75b75ffb-ab01-41a2-8bfb-8e3d0e8df8b7',
    'TABLEAU',
    'Tableau',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.tableau/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/tableau.svg',
    '{"category":"Analytics","subcategory":"Data Visualization","description":"Tableau integration for Analytics","node_name":"n8n-nodes-base.tableau","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Analytics","subcategory":"Data Visualization","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert POWERBI: Power BI
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
    '873f5b47-ec2f-4bd7-aaa5-533aef382053',
    'POWERBI',
    'Power BI',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.powerbi/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/powerbi.svg',
    '{"category":"Analytics","subcategory":"Data Visualization","description":"Power BI integration for Analytics","node_name":"n8n-nodes-base.powerbi","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Analytics","subcategory":"Data Visualization","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

-- Insert LOOKER: Looker
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
    '1503e67f-286e-4f34-b7f6-5cc13e7ade68',
    'LOOKER',
    'Looker',
    NULL,
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.looker/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/looker.svg',
    '{"category":"Analytics","subcategory":"Data Visualization","description":"Looker integration for Analytics","node_name":"n8n-nodes-base.looker","version":1,"supports_webhook":false,"rate_limits":{"requests_per_minute":100,"burst_limit":200,"daily_limit":10000}}'::jsonb,
    '{"category":"Analytics","subcategory":"Data Visualization","supported_operations":[],"supported_resources":[],"features":[]}'::jsonb,
    NOW(),
    NOW()
);

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
