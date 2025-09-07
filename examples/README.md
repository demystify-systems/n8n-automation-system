# 📊 Examples & Configuration Templates

This directory contains sample data, configuration templates, and example implementations for the N8N Automation System architecture.

## 📁 Directory Structure

### **📊 [sample-data/](sample-data/)** - Real Integration Data Samples
Actual data samples from N8N integration discovery and processing.

#### **Integration Data Files**
- **[n8n_integrations_raw_*.json](sample-data/)** - Raw integration data from N8N API
- **[n8n_integrations_processed_*.json](sample-data/)** - Processed and normalized integration metadata  
- **[n8n_integrations_analysis_*.json](sample-data/)** - Analysis results and statistics
- **[n8n_database_mapping_*.json](sample-data/)** - Database mapping suggestions and schema guidance

#### **Sample Data Features**
- ✅ **Real Integration Metadata**: Actual data from 200+ N8N integrations
- ✅ **Complete Channel Information**: Names, descriptions, capabilities, requirements
- ✅ **Credential Schemas**: Authentication requirements and configuration templates
- ✅ **Operation Mappings**: Available operations and workflow templates
- ✅ **Database Mapping**: Suggested database schema mappings and transformations

### **⚙️ [configurations/](configurations/)** - Configuration Templates
Environment configuration templates and dependency specifications.

#### **Environment Templates**
- **[.env.template](configurations/.env.template)** - Base environment variable template
- **[.env.integration](configurations/.env.integration)** - Integration-specific configuration template
- **[requirements.txt](configurations/requirements.txt)** - Python dependency specifications

#### **Infrastructure Configuration**
- **[gcs-lifecycle.json](configurations/gcs-lifecycle.json)** - Google Cloud Storage lifecycle management
- **Additional configuration templates for various deployment scenarios**

## 🎯 Sample Data Overview

### **Integration Coverage**
The sample data includes comprehensive information for major platforms:

#### **E-commerce Platforms**
- **Shopify**: Complete API v2023-10 integration with webhook support
- **WooCommerce**: REST API v3 with comprehensive product management
- **Magento**: Full catalog and order management capabilities
- **BigCommerce**: V3 API with multi-store support

#### **Marketplace Integrations**  
- **Amazon**: SP-API with marketplace-specific configurations
- **eBay**: Trading API with OAuth2 authentication
- **Etsy**: Open API v3 with shop management features
- **Walmart**: Marketplace API with fulfillment integration

#### **Business Applications**
- **Salesforce**: CRM integration with custom object support
- **HubSpot**: Marketing and sales automation
- **QuickBooks**: Financial data synchronization
- **Slack**: Team communication and notification workflows

#### **Social Media & Marketing**
- **Facebook**: Graph API with business account management
- **Instagram**: Business API with content publishing
- **Google Ads**: Campaign management and analytics
- **Mailchimp**: Email marketing automation

### **Data Structure Examples**

#### **Channel Master Data Structure**
```json
{
  "channel_key": "SHOPIFY",
  "channel_name": "Shopify",
  "description": "Shopify e-commerce platform integration",
  "base_url": "https://admin.shopify.com",
  "capabilities": {
    "api_version": "2023-10",
    "supports_webhooks": true,
    "authentication_methods": ["private_app", "oauth2"],
    "supported_operations": ["product_sync", "order_export", "inventory_update"],
    "rate_limits": {"requests_per_second": 40, "burst_limit": 80}
  },
  "credential_schema": {
    "type": "object",
    "required": ["shop_domain", "access_token"],
    "properties": {
      "shop_domain": {
        "type": "string",
        "description": "Your Shopify store domain",
        "pattern": "^[a-zA-Z0-9-]+\\.myshopify\\.com$"
      },
      "access_token": {
        "type": "string", 
        "description": "Shopify Admin API access token",
        "minLength": 32
      }
    }
  }
}
```

#### **N8N Flow Template Structure**
```json
{
  "n8n_flow_id": "uuid",
  "channel_id": "uuid", 
  "name": "Shopify Product Sync",
  "description": "Sync products from Shopify to database",
  "operation": "sync",
  "n8n_workflow_json": {
    "nodes": [
      {
        "name": "Shopify Trigger",
        "type": "shopifyTrigger",
        "credentials": "{{shopify_credentials}}",
        "webhookEvents": ["products/create", "products/update"]
      },
      {
        "name": "Database Insert", 
        "type": "postgres",
        "credentials": "{{database_credentials}}"
      }
    ]
  }
}
```

## ⚙️ Configuration Templates

### **Environment Configuration**

#### **[.env.template](configurations/.env.template)** - Base Environment
```bash
# N8N Configuration
N8N_BASE_URL=https://your-n8n-instance.com
N8N_API_KEY=your-n8n-api-key

# Database Configuration  
DB_HOST=your-database-host
DB_PORT=5432
DB_USER=your-database-user
DB_PASSWORD=your-database-password
DB_DATABASE=catalog-edge-db

# GCP Configuration
GOOGLE_CLOUD_PROJECT=your-gcp-project
GCS_BUCKET_NAME=your-storage-bucket
```

#### **[.env.integration](configurations/.env.integration)** - Integration-Specific
```bash
# Integration Sync Configuration
FETCH_REAL_INTEGRATIONS=false
SAMPLE_INTEGRATION_COUNT=10
UPDATE_EXISTING_CHANNELS=true
VALIDATE_SCHEMAS=true

# Credential Management
CREDENTIAL_ENCRYPTION_KEY=your-encryption-key
CREDENTIAL_TEST_ENDPOINTS=true
HEALTH_CHECK_INTERVAL=3600

# Performance Configuration  
BATCH_SIZE=100
MAX_CONCURRENT_REQUESTS=10
REQUEST_TIMEOUT=30
RETRY_ATTEMPTS=3
```

### **Infrastructure Configuration**

#### **[gcs-lifecycle.json](configurations/gcs-lifecycle.json)** - Storage Lifecycle
```json
{
  "rule": [
    {
      "action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
      "condition": {"age": 30, "matchesStorageClass": ["STANDARD"]}
    },
    {
      "action": {"type": "SetStorageClass", "storageClass": "COLDLINE"}, 
      "condition": {"age": 90, "matchesStorageClass": ["NEARLINE"]}
    },
    {
      "action": {"type": "Delete"},
      "condition": {"age": 365}
    }
  ]
}
```

## 🔧 Usage Examples

### **Development Setup**
```bash
# 1. Copy configuration templates
cp examples/configurations/.env.template .env
cp examples/configurations/.env.integration .env.local

# 2. Install dependencies  
pip install -r examples/configurations/requirements.txt

# 3. Review sample data
cat examples/sample-data/n8n_integrations_processed_*.json | jq '.integrations[0]'

# 4. Test with sample data
python scripts/integration/fetch_n8n_integrations.py --sample-only
```

### **Configuration Customization**
```bash
# 1. Edit environment variables for your setup
vim .env

# 2. Validate configuration
python scripts/monitoring/test_db_connection.py

# 3. Review integration mappings
cat examples/sample-data/n8n_database_mapping_*.json | jq '.mapping_suggestions'
```

## 📊 Sample Data Analysis

### **Integration Statistics**
Based on the sample data collected:

- **Total Integrations**: 200+ channels available
- **Authentication Methods**: OAuth2 (60%), API Key (30%), Basic Auth (10%)
- **Webhook Support**: 75% of integrations support real-time webhooks
- **API Versions**: Modern REST APIs with JSON responses
- **Rate Limits**: Average 40 requests/second with burst capabilities

### **Channel Categories**
- **E-commerce**: 35% (Shopify, WooCommerce, Magento, etc.)
- **Business Apps**: 25% (Salesforce, HubSpot, QuickBooks, etc.)
- **Marketing**: 20% (Mailchimp, Facebook Ads, Google Ads, etc.)
- **Communication**: 10% (Slack, Teams, Discord, etc.)
- **Other**: 10% (File storage, analytics, automation tools)

### **Complexity Analysis**
- **Basic Integration**: Simple CRUD operations, standard authentication
- **Intermediate**: Webhook support, batch operations, complex queries
- **Advanced**: Multi-tenant support, custom fields, advanced workflows

## 🔍 Data Validation

### **Sample Data Integrity**
All sample data has been validated for:
- ✅ JSON schema compliance
- ✅ Required field presence
- ✅ Data type consistency
- ✅ Relationship integrity
- ✅ Authentication schema validity

### **Configuration Template Validation**
All configuration templates include:
- ✅ Required environment variables
- ✅ Security best practices
- ✅ Performance optimization settings
- ✅ Error handling configuration
- ✅ Monitoring and logging setup

## 📚 Related Documentation

- **[Scripts Documentation](../scripts/README.md)**: Implementation examples using this sample data
- **[Schema Documentation](../schemas/README.md)**: Database designs based on this data structure
- **[WARP.md](../docs/WARP.md)**: Complete operational reference using these configurations

---

**Examples Repository Mission**: Provide comprehensive, real-world sample data and configuration templates that enable rapid development and testing of N8N automation systems with proper configuration management and data handling patterns.
