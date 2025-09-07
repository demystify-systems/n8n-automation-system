-- N8N Channel Inserts - Simplified
-- Using n8n_user with existing permissions

BEGIN;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Test insert with one record first
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    'SLACK_TEST',
    'Slack Test',
    'https://slack.com/api',
    'https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.slack/',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/slack.svg',
    '{"category":"Communication","subcategory":"Team Chat"}'::jsonb,
    '{"messaging":true,"notifications":true}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    updated_at = NOW();

COMMIT;

-- Verify insert
SELECT channel_key, channel_name, created_at FROM saas_channel_master WHERE channel_key = 'SLACK_TEST';
