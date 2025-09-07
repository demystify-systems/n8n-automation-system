# N8N Integration Sync System - Complete Guide

## Overview

This guide provides comprehensive instructions for using the N8N Integration Sync System to fetch integrations from your self-hosted N8N instance at `https://spinner.saastify.ai`, transform them with logos and metadata, and sync them to your `catalog-edge-db` for unified tenant management.

## 🎯 What This System Does

✅ **Fetches** all available integrations from your N8N instance  
✅ **Transforms** integration data with proper logos, categories, and metadata  
✅ **Syncs** to your catalog-edge-db schema for unified management  
✅ **Supports** multi-tenant workflows with dynamic credential expressions  
✅ **Generates** SQL insert files for manual database operations  
✅ **Provides** comprehensive logging and error handling  

## 📋 Prerequisites

### 1. Database Schema
Your `catalog-edge-db` must have the catalog-edge schema deployed:
```bash
# Check if schema exists
psql -h 10.42.194.4 -U n8n_user -d catalog-edge-db -c "SELECT COUNT(*) FROM saas_channel_master"
```

### 2. N8N API Access
- N8N instance running at `https://spinner.saastify.ai`
- N8N API key (get from Settings > API Keys)

### 3. Python Dependencies
```bash
pip install psycopg2-binary requests python-dotenv
```

## 🚀 Quick Start

### Option 1: Direct Database Sync (Recommended)

1. **Set up environment variables:**
```bash
export N8N_BASE_URL=https://spinner.saastify.ai
export N8N_API_KEY=your-api-key-here
export DB_HOST=10.42.194.4
export DB_USER=n8n_user
export DB_PASSWORD=saasdbforn8n2025
export DB_NAME=catalog-edge-db
```

2. **Run a dry-run to preview:**
```bash
cd scripts/integration
python n8n_integration_sync_enhanced.py sync --dry-run
```

3. **Perform the actual sync:**
```bash
python n8n_integration_sync_enhanced.py sync
```

4. **Check the results:**
```bash
python n8n_integration_sync_enhanced.py status
```

### Option 2: Generate SQL Files First

1. **Generate SQL INSERT files:**
```bash
python generate_sql_inserts.py --source api --n8n-url https://spinner.saastify.ai --api-key YOUR_KEY
```

2. **Review the generated SQL:**
```bash
head -50 n8n_channel_inserts_YYYYMMDD_HHMMSS.sql
```

3. **Execute against your database:**
```bash
psql -h 10.42.194.4 -U n8n_user -d catalog-edge-db -f n8n_channel_inserts_YYYYMMDD_HHMMSS.sql
```

## 📖 Detailed Usage Guide

### Environment Configuration

Create a `.env.sync` file from the template:
```bash
cp .env.sync.template .env.sync
# Edit with your actual values
```

### N8N Integration Sync Enhanced

This is the main synchronization tool with comprehensive features:

```bash
# Show all available commands
python n8n_integration_sync_enhanced.py --help

# Validate database schema
python n8n_integration_sync_enhanced.py validate

# Get current sync status
python n8n_integration_sync_enhanced.py status

# Dry run sync (preview only)
python n8n_integration_sync_enhanced.py sync --dry-run

# Full sync from N8N API
python n8n_integration_sync_enhanced.py sync \
  --n8n-url https://spinner.saastify.ai \
  --api-key YOUR_API_KEY

# Update existing entries
python n8n_integration_sync_enhanced.py sync --update

# Custom database connection
python n8n_integration_sync_enhanced.py sync \
  --db-host your-host \
  --db-user your-user \
  --db-password your-pass
```

### SQL Insert Generator

Generate standalone SQL files for manual execution:

```bash
# Generate from live N8N API
python generate_sql_inserts.py \
  --source api \
  --n8n-url https://spinner.saastify.ai \
  --api-key YOUR_KEY \
  --output-file my_integrations.sql

# Generate from JSON fallback data
python generate_sql_inserts.py \
  --source json \
  --json-file COMPLETE_N8N_INTEGRATIONS_200.json

# Generate UPSERT statements (safer for re-runs)
python generate_sql_inserts.py --mode upsert

# Dry run to preview
python generate_sql_inserts.py --dry-run
```

## 🔄 Data Transformation Details

### What Gets Transformed

The system transforms N8N node data into your database schema format:

1. **Channel Key Generation**: `n8n-nodes-base.shopify` → `SHOPIFY`
2. **Logo URLs**: Automatically mapped to CDN URLs (Simple Icons)
3. **Categorization**: Automatic classification into 8 major categories
4. **Credential Schemas**: JSON Schema generation for authentication
5. **Capabilities**: Operations, resources, and features extraction
6. **URLs**: Base API URLs and documentation links

### Generated Data Structure

Each integration becomes a record in `saas_channel_master`:

```sql
-- Example: Shopify integration
INSERT INTO saas_channel_master (
  channel_key,           -- 'SHOPIFY'
  channel_name,          -- 'Shopify'
  base_url,              -- 'https://admin.shopify.com/admin/api'
  docs_url,              -- 'https://docs.n8n.io/integrations/...'
  channel_logo_url,      -- 'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/shopify.svg'
  default_channel_config,-- JSON with category, description, etc.
  capabilities          -- JSON with operations, resources, auth methods
);
```

### Categories Supported

- **Communication**: Slack, Discord, Teams, Gmail, etc.
- **Sales**: Shopify, Stripe, PayPal, QuickBooks, etc.
- **Marketing**: HubSpot, Salesforce, Mailchimp, etc.
- **Productivity**: Google Workspace, Microsoft 365, Notion, etc.
- **Social Media**: Twitter, LinkedIn, Facebook, YouTube, etc.
- **AI**: OpenAI, Anthropic, Hugging Face, etc.
- **Development**: GitHub, GitLab, Jira, AWS, etc.
- **Analytics**: Google Analytics, Mixpanel, Segment, etc.

## 🏗️ Multi-Tenant Usage

### Dynamic Credential Expressions

Once synced, you can use these integrations in N8N workflows with tenant-specific credentials:

```javascript
// In N8N workflow nodes, use expressions like:
{{ $getTenantCredential('shopify', $getTenantId()) }}
{{ $getChannelConfig('STRIPE', $getTenantId()) }}
```

### Webhook Path Generation

Each tenant gets isolated webhook paths:
```
/webhook/tenant/{{saas_edge_id}}/{{channel_key}}/{{operation}}
```

### Installation Flow

1. **Admin enables channels** in `saas_channel_master`
2. **Tenants install** via your portal → `saas_channel_installations`
3. **Workflows deploy** with tenant-specific configs
4. **Credentials inject** dynamically at runtime

## 📊 Monitoring and Validation

### Check Sync Results

```bash
# Total channels synced
psql -h 10.42.194.4 -U n8n_user -d catalog-edge-db -c "SELECT COUNT(*) FROM saas_channel_master;"

# Channels by category
psql -h 10.42.194.4 -U n8n_user -d catalog-edge-db -c "
  SELECT capabilities->>'category' as category, COUNT(*) 
  FROM saas_channel_master 
  GROUP BY capabilities->>'category' 
  ORDER BY count DESC;"

# Recent additions
psql -h 10.42.194.4 -U n8n_user -d catalog-edge-db -c "
  SELECT channel_key, channel_name, created_at 
  FROM saas_channel_master 
  ORDER BY created_at DESC 
  LIMIT 10;"
```

### Validate Data Quality

```bash
# Check for missing logos
psql -h 10.42.194.4 -U n8n_user -d catalog-edge-db -c "
  SELECT channel_key, channel_name 
  FROM saas_channel_master 
  WHERE channel_logo_url IS NULL;"

# Check credential schemas
psql -h 10.42.194.4 -U n8n_user -d catalog-edge-db -c "
  SELECT channel_key, jsonb_array_length(capabilities->'auth_methods') as auth_methods_count
  FROM saas_channel_master 
  WHERE capabilities->'auth_methods' IS NOT NULL;"
```

## 🚨 Troubleshooting

### Common Issues

#### 1. N8N API Connection Failed
```bash
# Test API connectivity
curl -H "X-N8N-API-KEY: YOUR_KEY" "https://spinner.saastify.ai/api/v1/nodes" | jq '. | length'
```

#### 2. Database Connection Failed
```bash
# Test database connection
python -c "import psycopg2; psycopg2.connect(host='10.42.194.4', user='n8n_user', password='saasdbforn8n2025', database='catalog-edge-db')"
```

#### 3. Schema Validation Failed
```bash
# Check if tables exist
python n8n_integration_sync_enhanced.py validate
```

#### 4. Empty Results
- Check if N8N instance is running
- Verify API key has proper permissions
- Check logs for transformation errors

### Recovery Options

#### Rollback Changes
If you generated SQL files, use the rollback:
```bash
psql -h 10.42.194.4 -U n8n_user -d catalog-edge-db -f n8n_channel_inserts_YYYYMMDD_HHMMSS_rollback.sql
```

#### Clean Start
```sql
-- Remove all N8N-sourced channels
DELETE FROM saas_channel_master 
WHERE channel_key IN (
  SELECT DISTINCT channel_key 
  FROM saas_channel_master 
  WHERE default_channel_config->>'node_name' LIKE 'n8n-nodes-base.%'
);
```

## 📈 Performance Optimization

### Batch Processing
The system processes integrations in batches for optimal performance:
- Default batch size: 100 integrations
- Rate limiting: 1-second delay between API calls
- Transaction-based database operations

### Monitoring
Enable verbose logging to track performance:
```bash
python n8n_integration_sync_enhanced.py sync --verbose
```

## 🔒 Security Considerations

### API Key Management
- Store N8N API key in environment variables
- Never commit API keys to version control
- Rotate API keys regularly

### Database Security
- Use read-only database user for validation operations
- Use connection pooling for production deployments
- Enable SSL/TLS for database connections

### Multi-Tenant Isolation
- All data is scoped by `saas_edge_id`
- Credentials are encrypted at rest
- Webhook paths include tenant identifiers

## 📚 Advanced Usage

### Custom Transformations
You can extend the transformation logic in `N8NIntegrationSyncEnhanced`:

```python
def _custom_categorize_integration(self, node_name: str) -> tuple[str, str]:
    # Add your custom categorization logic
    if 'custom' in node_name:
        return 'Custom', 'Integration'
    return self._categorize_integration(node_name, integration)
```

### Integration Filtering
Filter specific integrations during sync:

```python
# In sync_to_database method, add filtering
if channel.channel_key not in ['ALLOWED_CHANNEL_1', 'ALLOWED_CHANNEL_2']:
    continue
```

### Custom Logo Mapping
Add your own logo URLs:

```python
CUSTOM_LOGO_MAPPING = {
    'your-service': 'https://your-cdn.com/logo.svg',
}
```

## 📞 Support

### Getting Help
1. Check this guide first
2. Review error messages in logs
3. Validate your environment setup
4. Test with dry-run mode first

### Error Reporting
When reporting issues, include:
- Full error message and stack trace
- Environment details (Python version, OS)
- Configuration used (remove sensitive data)
- Steps to reproduce

---

## 🎉 Success!

Once you've successfully synced your integrations, you'll have:

✅ **200+ integrations** available in your database  
✅ **Complete metadata** with logos, categories, and credentials  
✅ **Multi-tenant support** ready for your platform  
✅ **Dynamic expressions** for N8N workflow automation  
✅ **Unified management** through your admin interface  

Your N8N integration ecosystem is now ready for production use! 🚀
