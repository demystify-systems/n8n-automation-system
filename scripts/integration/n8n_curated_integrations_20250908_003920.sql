-- N8N Curated Integrations with High-Quality Icons
-- Generated: 2025-09-08T00:39:20.388210
-- Total integrations: 37

BEGIN;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insert Slack
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'SLACK',
    'Slack',
    'https://slack.com/api',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.slack/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/slack.svg',
    '{"category": "Communication", "subcategory": "Team Chat", "description": "Slack is a powerful collaboration tool for businesses of all sizes. Hangs bring everyone together to work effectively and solve problems.", "features": ["messaging", "notifications", "channels", "webhooks"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Communication", "subcategory": "Team Chat", "supported_operations": ["messaging", "notifications", "channels", "webhooks"], "auth_methods": ["oauth2", "webhook"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Discord
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'DISCORD',
    'Discord',
    'https://discord.com/api',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.discord/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/discord.svg',
    '{"category": "Communication", "subcategory": "Team Chat", "description": "Discord integration for Communication", "features": ["messaging", "notifications"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Communication", "subcategory": "Team Chat", "supported_operations": ["messaging", "notifications"], "auth_methods": ["webhook", "bot_token"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Microsoft Teams
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'MICROSOFT_TEAMS',
    'Microsoft Teams',
    'https://graph.microsoft.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.microsoftteams/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/microsoftteams.svg',
    '{"category": "Communication", "subcategory": "Team Chat", "description": "Microsoft Teams integration for Communication", "features": ["messaging", "meetings"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Communication", "subcategory": "Team Chat", "supported_operations": ["messaging", "meetings"], "auth_methods": ["oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Gmail
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'GMAIL',
    'Gmail',
    'https://gmail.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.gmail/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/gmail.svg',
    '{"category": "Communication", "subcategory": "Email", "description": "Gmail is a free of charge email service offered as part of Google Workspace. It is used by individuals and organizations to send and receive emails and communicate internally and externally.", "features": ["email", "attachments"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Communication", "subcategory": "Email", "supported_operations": ["email", "attachments"], "auth_methods": ["oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Telegram
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'TELEGRAM',
    'Telegram',
    'https://api.telegram.org',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.telegram/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/telegram.svg',
    '{"category": "Communication", "subcategory": "Messaging", "description": "Telegram is one of the fastest and most secured messaging apps on the market.", "features": ["messaging", "bots"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Communication", "subcategory": "Messaging", "supported_operations": ["messaging", "bots"], "auth_methods": ["bot_token"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert WhatsApp
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'WHATSAPP',
    'WhatsApp',
    'https://developers.facebook.com/docs/whatsapp',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.whatsapp/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/whatsapp.svg',
    '{"category": "Communication", "subcategory": "Messaging", "description": "WhatsApp integration for messaging", "features": ["messaging"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Communication", "subcategory": "Messaging", "supported_operations": ["messaging"], "auth_methods": ["api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Facebook
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'FACEBOOK',
    'Facebook',
    'https://graph.facebook.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.facebook/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/facebook.svg',
    '{"category": "Communication", "subcategory": "Social Media", "description": "Facebook integration for Social Media", "features": ["posting", "pages"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Communication", "subcategory": "Social Media", "supported_operations": ["posting", "pages"], "auth_methods": ["oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Twitter
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'TWITTER',
    'Twitter',
    'https://api.twitter.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.twitter/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/x.svg',
    '{"category": "Communication", "subcategory": "Social Media", "description": "Twitter integration for Social Media", "features": ["tweets", "mentions"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Communication", "subcategory": "Social Media", "supported_operations": ["tweets", "mentions"], "auth_methods": ["oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert LinkedIn
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'LINKEDIN',
    'LinkedIn',
    'https://api.linkedin.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.linkedin/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/linkedin.svg',
    '{"category": "Communication", "subcategory": "Social Media", "description": "LinkedIn integration for Social Media", "features": ["posting", "connections"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Communication", "subcategory": "Social Media", "supported_operations": ["posting", "connections"], "auth_methods": ["oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert OpenAI
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'OPENAI',
    'OpenAI',
    'https://api.openai.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.openai/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/openai.svg',
    '{"category": "AI", "subcategory": "Language Models", "description": "OpenAI, the creator of ChatGPT, offers a range of powerful models including GPT-3, DALL\u00b7E, and Whisper. Leverage these models to build AI-powered workflows.", "features": ["chat", "completions", "images"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "AI", "subcategory": "Language Models", "supported_operations": ["chat", "completions", "images"], "auth_methods": ["api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Anthropic
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'ANTHROPIC',
    'Anthropic',
    'https://api.anthropic.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.anthropic/',
    'https://docs.anthropic.com/claude/reference/claude_logo_icon.svg',
    '{"category": "AI", "subcategory": "Language Models", "description": "The Anthropic app, built by the creators of Claude, is an AI chat app that lets you talk to Claude on the go.", "features": ["chat", "text_generation"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "AI", "subcategory": "Language Models", "supported_operations": ["chat", "text_generation"], "auth_methods": ["api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Google Gemini
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'GOOGLE_GEMINI',
    'Google Gemini',
    'https://generativelanguage.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlegemini/',
    'https://www.gstatic.com/lamda/images/gemini_sparkle_v002_d4735304ff6292a690345.svg',
    '{"category": "AI", "subcategory": "Language Models", "description": "Google Gemini is an AI assistant app that answers questions, summarizes information, and helps you dive deeper into topics you care about.", "features": ["chat", "multimodal"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "AI", "subcategory": "Language Models", "supported_operations": ["chat", "multimodal"], "auth_methods": ["api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Google Sheets
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'GOOGLE_SHEETS',
    'Google Sheets',
    'https://sheets.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlesheets/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/googlesheets.svg',
    '{"category": "Productivity", "subcategory": "Spreadsheets", "description": "Google Sheets is a web-based spreadsheet program offered by Google for free. It similar to Microsoft Excel, and can be accessed anywhere on any device, you only need a Google account.", "features": ["data_manipulation", "automation"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Productivity", "subcategory": "Spreadsheets", "supported_operations": ["data_manipulation", "automation"], "auth_methods": ["oauth2", "service_account"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Google Drive
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'GOOGLE_DRIVE',
    'Google Drive',
    'https://www.googleapis.com/drive/v3',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googledrive/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/googledrive.svg',
    '{"category": "Productivity", "subcategory": "File Storage", "description": "Google Drive is a storage and synchronization service offered by Google.", "features": ["file_management", "sharing"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Productivity", "subcategory": "File Storage", "supported_operations": ["file_management", "sharing"], "auth_methods": ["oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Google Calendar
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'GOOGLE_CALENDAR',
    'Google Calendar',
    'https://www.googleapis.com/calendar/v3',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlecalendar/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/googlecalendar.svg',
    '{"category": "Productivity", "subcategory": "Calendar", "description": "Google Calendar integration for scheduling", "features": ["events", "scheduling"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Productivity", "subcategory": "Calendar", "supported_operations": ["events", "scheduling"], "auth_methods": ["oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert GitHub
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'GITHUB',
    'GitHub',
    'https://api.github.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.github/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/github.svg',
    '{"category": "Development", "subcategory": "Version Control", "description": "GitHub integration for Development", "features": ["repositories", "issues", "pull_requests"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Development", "subcategory": "Version Control", "supported_operations": ["repositories", "issues", "pull_requests"], "auth_methods": ["oauth2", "token"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert GitLab
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'GITLAB',
    'GitLab',
    'https://gitlab.com/api/v4',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.gitlab/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/gitlab.svg',
    '{"category": "Development", "subcategory": "Version Control", "description": "GitLab integration for Development", "features": ["repositories", "pipelines"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Development", "subcategory": "Version Control", "supported_operations": ["repositories", "pipelines"], "auth_methods": ["token"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Docker
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'DOCKER',
    'Docker',
    'https://docs.docker.com/engine/api',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.docker/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/docker.svg',
    '{"category": "Development", "subcategory": "DevOps", "description": "Docker integration for Development", "features": ["containers", "images"], "is_popular": false, "is_core": false}'::jsonb,
    '{"category": "Development", "subcategory": "DevOps", "supported_operations": ["containers", "images"], "auth_methods": ["api_key"], "is_popular": false}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Shopify
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'SHOPIFY',
    'Shopify',
    'https://shopify.dev/api',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.shopify/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/shopify.svg',
    '{"category": "E-commerce", "subcategory": "Platform", "description": "Shopify integration for E-commerce", "features": ["orders", "products", "customers"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "E-commerce", "subcategory": "Platform", "supported_operations": ["orders", "products", "customers"], "auth_methods": ["oauth2", "api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Stripe
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'STRIPE',
    'Stripe',
    'https://api.stripe.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.stripe/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/stripe.svg',
    '{"category": "E-commerce", "subcategory": "Payment", "description": "Stripe integration for Payments", "features": ["payments", "subscriptions"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "E-commerce", "subcategory": "Payment", "supported_operations": ["payments", "subscriptions"], "auth_methods": ["api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert PayPal
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'PAYPAL',
    'PayPal',
    'https://api.paypal.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.paypal/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/paypal.svg',
    '{"category": "E-commerce", "subcategory": "Payment", "description": "PayPal integration for Payments", "features": ["payments", "invoices"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "E-commerce", "subcategory": "Payment", "supported_operations": ["payments", "invoices"], "auth_methods": ["oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert WooCommerce
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'WOOCOMMERCE',
    'WooCommerce',
    'https://woocommerce.github.io/woocommerce-rest-api-docs',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.woocommerce/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/woocommerce.svg',
    '{"category": "E-commerce", "subcategory": "Platform", "description": "WooCommerce integration for E-commerce", "features": ["orders", "products"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "E-commerce", "subcategory": "Platform", "supported_operations": ["orders", "products"], "auth_methods": ["api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert HubSpot
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'HUBSPOT',
    'HubSpot',
    'https://api.hubapi.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.hubspot/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/hubspot.svg',
    '{"category": "Marketing", "subcategory": "CRM", "description": "HubSpot integration for Marketing", "features": ["contacts", "deals", "campaigns"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Marketing", "subcategory": "CRM", "supported_operations": ["contacts", "deals", "campaigns"], "auth_methods": ["oauth2", "api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Salesforce
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'SALESFORCE',
    'Salesforce',
    'https://developer.salesforce.com/docs/api-explorer',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.salesforce/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/salesforce.svg',
    '{"category": "Marketing", "subcategory": "CRM", "description": "Salesforce integration for CRM", "features": ["leads", "opportunities"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Marketing", "subcategory": "CRM", "supported_operations": ["leads", "opportunities"], "auth_methods": ["oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Mailchimp
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'MAILCHIMP',
    'Mailchimp',
    'https://mailchimp.com/developer/marketing/api/',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mailchimp/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mailchimp.svg',
    '{"category": "Marketing", "subcategory": "Email Marketing", "description": "Mailchimp integration for Email Marketing", "features": ["campaigns", "lists"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Marketing", "subcategory": "Email Marketing", "supported_operations": ["campaigns", "lists"], "auth_methods": ["api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert SendGrid
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'SENDGRID',
    'SendGrid',
    'https://sendgrid.com/docs/api/',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.sendgrid/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/sendgrid.svg',
    '{"category": "Marketing", "subcategory": "Email Marketing", "description": "SendGrid integration for Email", "features": ["email_delivery"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Marketing", "subcategory": "Email Marketing", "supported_operations": ["email_delivery"], "auth_methods": ["api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Notion
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'NOTION',
    'Notion',
    'https://api.notion.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.notion/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/notion.svg',
    '{"category": "Productivity", "subcategory": "Note Taking", "description": "Notion integration for Productivity", "features": ["pages", "databases"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Productivity", "subcategory": "Note Taking", "supported_operations": ["pages", "databases"], "auth_methods": ["oauth2", "integration_token"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Trello
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'TRELLO',
    'Trello',
    'https://api.trello.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.trello/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/trello.svg',
    '{"category": "Productivity", "subcategory": "Project Management", "description": "Trello integration for Project Management", "features": ["boards", "cards", "lists"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Productivity", "subcategory": "Project Management", "supported_operations": ["boards", "cards", "lists"], "auth_methods": ["oauth2", "api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Asana
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'ASANA',
    'Asana',
    'https://app.asana.com/api/1.0',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.asana/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/asana.svg',
    '{"category": "Productivity", "subcategory": "Project Management", "description": "Asana integration for Project Management", "features": ["tasks", "projects"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Productivity", "subcategory": "Project Management", "supported_operations": ["tasks", "projects"], "auth_methods": ["oauth2", "token"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Monday.com
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'MONDAY_COM',
    'Monday.com',
    'https://api.monday.com/v2',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mondaycom/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mondaydotcom.svg',
    '{"category": "Productivity", "subcategory": "Project Management", "description": "Monday.com integration for Project Management", "features": ["boards", "items"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Productivity", "subcategory": "Project Management", "supported_operations": ["boards", "items"], "auth_methods": ["api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Jira
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'JIRA',
    'Jira',
    'https://developer.atlassian.com/cloud/jira/platform/rest/v2/',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.jira/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/jira.svg',
    '{"category": "Productivity", "subcategory": "Project Management", "description": "Jira integration for Issue Tracking", "features": ["issues", "projects"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Productivity", "subcategory": "Project Management", "supported_operations": ["issues", "projects"], "auth_methods": ["oauth2", "api_token"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert ClickUp
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'CLICKUP',
    'ClickUp',
    'https://api.clickup.com/api/v2',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.clickup/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/clickup.svg',
    '{"category": "Productivity", "subcategory": "Project Management", "description": "ClickUp integration for Productivity", "features": ["tasks", "automation"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Productivity", "subcategory": "Project Management", "supported_operations": ["tasks", "automation"], "auth_methods": ["api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Airtable
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'AIRTABLE',
    'Airtable',
    'https://api.airtable.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.airtable/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/airtable.svg',
    '{"category": "Database", "subcategory": "Cloud Database", "description": "Airtable is the best tool to develop your business. It helps you connect your data, your business processes, and your teams.", "features": ["records", "views", "automation"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Database", "subcategory": "Cloud Database", "supported_operations": ["records", "views", "automation"], "auth_methods": ["api_key", "oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Google Analytics
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'GOOGLE_ANALYTICS',
    'Google Analytics',
    'https://analyticsreporting.googleapis.com',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googleanalytics/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/googleanalytics.svg',
    '{"category": "Analytics", "subcategory": "Web Analytics", "description": "Google Analytics integration for Analytics", "features": ["reports", "dimensions"], "is_popular": true, "is_core": false}'::jsonb,
    '{"category": "Analytics", "subcategory": "Web Analytics", "supported_operations": ["reports", "dimensions"], "auth_methods": ["oauth2"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert HTTP Request
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'HTTP_REQUEST',
    'HTTP Request',
    NULL,
    'https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/http.svg',
    '{"category": "Utility", "subcategory": "Core", "description": "HTTP Request integration for making API calls", "features": ["api_calls", "webhooks"], "is_popular": true, "is_core": true}'::jsonb,
    '{"category": "Utility", "subcategory": "Core", "supported_operations": ["api_calls", "webhooks"], "auth_methods": ["none", "basic", "oauth2", "api_key"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Webhook
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'WEBHOOK',
    'Webhook',
    NULL,
    'https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/',
    'https://docs.n8n.io/assets/images/webhook-5b6a6cb99e19b48e1ce2de9c2e9ad2b5.svg',
    '{"category": "Utility", "subcategory": "Core", "description": "Webhooks are automatic notifications that are sent when something important happens in an app.", "features": ["triggers", "automation"], "is_popular": true, "is_core": true}'::jsonb,
    '{"category": "Utility", "subcategory": "Core", "supported_operations": ["triggers", "automation"], "auth_methods": ["none"], "is_popular": true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();

-- Insert Schedule Trigger
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'SCHEDULE_TRIGGER',
    'Schedule Trigger',
    NULL,
    'https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.cron/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/clockwise.svg',
    '{"category": "Utility", "subcategory": "Core", "description": "Schedule Trigger integration for automated workflows", "features": ["scheduling", "automation"], "is_popular": true, "is_core": true}'::jsonb,
    '{"category": "Utility", "subcategory": "Core", "supported_operations": ["scheduling", "automation"], "auth_methods": ["none"], "is_popular": true}'::jsonb
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
SELECT channel_key, channel_name, channel_logo_url FROM saas_channel_master WHERE channel_key IN ('SLACK', 'DISCORD', 'MICROSOFT_TEAMS', 'GMAIL', 'TELEGRAM', 'WHATSAPP', 'FACEBOOK', 'TWITTER', 'LINKEDIN', 'OPENAI', 'ANTHROPIC', 'GOOGLE_GEMINI', 'GOOGLE_SHEETS', 'GOOGLE_DRIVE', 'GOOGLE_CALENDAR', 'GITHUB', 'GITLAB', 'DOCKER', 'SHOPIFY', 'STRIPE', 'PAYPAL', 'WOOCOMMERCE', 'HUBSPOT', 'SALESFORCE', 'MAILCHIMP', 'SENDGRID', 'NOTION', 'TRELLO', 'ASANA', 'MONDAY_COM', 'JIRA', 'CLICKUP', 'AIRTABLE', 'GOOGLE_ANALYTICS', 'HTTP_REQUEST', 'WEBHOOK', 'SCHEDULE_TRIGGER') ORDER BY channel_name;