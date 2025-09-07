# WARP.md

This file provides comprehensive guidance to WARP (warp.dev) when working with the N8N Automation & Migration System codebase.

## 🎯 Project Overview

This repository serves as a **cold start enabler** for N8N automation and channel integration management within the Saastify platform ecosystem. It provides migration tools, integration sync capabilities, and comprehensive automation management for a self-hosted N8N instance on GCP infrastructure.

### Core Purpose
- **Migration & Integration**: Sync 200+ integrations from N8N to catalog-edge-db
- **Channel Management**: Multi-tenant channel installation and configuration
- **Automation Enabler**: Bootstrap N8N workflows and AI automation systems
- **GCP Infrastructure**: Production-ready deployment on Google Cloud Platform
- **Cold Start Accelerator**: 1000X faster delivery of new platform results

## 📁 Repository Structure

### Root Directory Structure
```
n8n/
├── 🔧 Core Integration Management
│   ├── fetch_n8n_integrations.py      # (990 lines) - Main integration fetcher
│   ├── sync_integrations_to_db_clean.py # (397 lines) - Database sync (clean)
│   ├── sync_integrations_to_db.py     # (202 lines) - Database sync (legacy)
│   ├── manage_integrations.py         # (121 lines) - All-in-one management
│   ├── n8n_integration_sync.py        # (584 lines) - Advanced sync system
│   └── n8n_credential_expressions.py  # (545 lines) - Dynamic credential system
│
├── 📊 Log Export & Monitoring
│   ├── main.py                        # (376 lines) - Main log exporter
│   ├── cloud_function_main.py         # (448 lines) - GCP Cloud Function
│   ├── n8n_log_exporter.py           # (433 lines) - Advanced log exporter
│   ├── test_db_connection.py          # (80 lines) - Database testing
│   └── n8n_log_queries.sql           # SQL queries for log analysis
│
├── 🚀 Deployment & Setup
│   ├── setup_integration_system.sh    # Complete system setup
│   ├── deploy-n8n.sh                 # N8N deployment script
│   ├── deploy_log_exporter.sh        # Log exporter deployment
│   └── gcs-lifecycle.json            # GCS lifecycle configuration
│
├── 🤖 AI Management System
│   └── n8n-ai-management/            # Complete AI workflow management
│       ├── workflows/templates/       # AI workflow templates
│       ├── saas-n8n-ai/             # SaaS AI integration layer
│       ├── scripts/                  # Management scripts
│       └── docs/                     # AI system documentation
│
├── 📋 Configuration
│   ├── .env                          # Production environment config
│   ├── .env.integration             # Integration sync config template
│   └── requirements.txt             # Python dependencies
│
├── 📊 Generated Data & Analysis
│   ├── n8n_integrations_*.json      # Fetched integration data
│   ├── n8n_database_mapping_*.json  # Database mapping suggestions
│   └── INTEGRATION_SYSTEM_README.md # Auto-generated system docs
│
└── 📖 Documentation
    ├── IMPLEMENTATION_GUIDE.md       # Complete implementation guide
    ├── admin_portal_design.md        # Admin portal specifications
    ├── README_log_exporter.md        # Log exporter documentation
    └── N8N_PRODUCTION_TEST_REPORT.md # Production testing report
```

## 🏗️ Architecture Layers

### Layer 1: Infrastructure (GCP)
- **Cloud Run**: Self-hosted N8N instance at `https://spinner.saastify.ai`
- **Cloud SQL**: PostgreSQL databases (n8n + catalog-edge-db)
- **Cloud Storage**: Log storage bucket `saas_job_logs`
- **Cloud Functions**: Automated log export and processing
- **Secret Manager**: Secure credential and API key storage

### Layer 2: Integration Management
- **Channel Sync System**: 200+ integrations from N8N API → Database
- **Multi-tenant Architecture**: Complete isolation by `saas_edge_id`
- **Dynamic Credentials**: Runtime credential injection for workflows
- **Webhook Generation**: Auto-generated webhook endpoints per tenant

### Layer 3: AI Automation
- **AI Workflow Templates**: Pre-built chat, completion, and automation flows
- **AI Analytics**: Token usage, cost tracking, and performance metrics
- **Memory Management**: Conversation context and session handling
- **Model Integration**: OpenAI, Anthropic, and custom AI providers

### Layer 4: Management & Monitoring
- **Workflow Deployment**: Automated workflow sync and version control
- **Log Export**: Daily log export to GCS with lifecycle management
- **Health Monitoring**: System health checks and alerting
- **Usage Analytics**: Execution tracking and performance analysis

## 🔧 Core Components

### Integration Management System
**Primary Script**: `manage_integrations.py`
```bash
# Complete workflow - fetch from N8N and sync to database
python manage_integrations.py full-sync --sample-only \
  --db-host HOST --db-user USER --db-password PASS

# Production sync with real N8N instance
python manage_integrations.py full-sync \
  --n8n-url https://spinner.saastify.ai --api-key KEY \
  --db-host HOST --db-user USER --db-password PASS
```

**Key Features**:
- Fetches 200+ integrations from N8N API
- Transforms data to catalog-edge-db schema
- Handles credential schemas and operation mappings
- Supports both sample and production data

### Database Schema Integration
**Target Database**: `catalog-edge-db` on GCP Cloud SQL
**Key Tables**:
- `saas_channel_master`: Master channel registry
- `saas_n8n_flows`: N8N workflow templates
- `saas_channel_master_flow_defs`: Default flow configurations
- `saas_channel_installations`: User installations
- `saas_channel_installed_flows`: Active workflow instances

### Dynamic Credential System
**Script**: `n8n_credential_expressions.py`
- Multi-tenant credential isolation
- Runtime credential injection in N8N workflows
- Database-driven credential lookup
- Secure encrypted storage patterns

### Log Export & Monitoring
**Production System**: Cloud Function + Cloud Run integration
**Daily Export**: N8N execution logs → GCS bucket
**Analytics**: Execution metrics, error tracking, usage patterns

## 🚀 Development Workflows

### Initial Setup
```bash
# 1. Environment setup
cp .env.integration .env
# Edit with your actual credentials

# 2. Install dependencies
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 3. Test database connection
python test_db_connection.py

# 4. Run complete system setup
./setup_integration_system.sh
```

### Integration Sync Workflow
```bash
# 1. Fetch integrations (sample data for testing)
python fetch_n8n_integrations.py --sample-only

# 2. Review generated data
cat n8n_integrations_analysis_*.json

# 3. Sync to database
python sync_integrations_to_db_clean.py n8n_integrations_processed_*.json \
  --db-host HOST --db-user USER --db-password PASS

# 4. Verify sync
python manage_integrations.py status \
  --db-host HOST --db-user USER --db-password PASS
```

### AI Workflow Management
```bash
# Navigate to AI management system
cd n8n-ai-management

# Setup AI database and workflows
./scripts/setup.sh

# Deploy AI workflow templates
./scripts/deploy-workflows.sh

# Monitor AI usage and costs
./scripts/health-check.sh
```

### Log Export Management
```bash
# Test log exporter locally
python main.py

# Deploy to Cloud Functions
./deploy_log_exporter.sh

# Test database connection
python test_db_connection.py
```

## 🎯 Key Use Cases

### 1. Platform Bootstrap (Cold Start)
**Scenario**: Setting up N8N integration management from scratch
**Commands**:
```bash
./setup_integration_system.sh
python manage_integrations.py full-sync --sample-only --db-host HOST --db-user USER --db-password PASS
```

### 2. Production Integration Sync
**Scenario**: Syncing 200+ integrations from production N8N
**Commands**:
```bash
python manage_integrations.py full-sync \
  --n8n-url https://spinner.saastify.ai \
  --api-key YOUR_N8N_API_KEY \
  --db-host YOUR_GCP_POSTGRES_HOST \
  --db-user YOUR_DB_USER \
  --db-password YOUR_DB_PASSWORD
```

### 3. AI Workflow Deployment
**Scenario**: Deploying AI chat and automation workflows
**Commands**:
```bash
cd n8n-ai-management
./scripts/setup.sh
./scripts/deploy-workflows.sh
```

### 4. Multi-tenant Channel Installation
**Scenario**: End user installing Shopify integration
**Process**:
1. Admin enables Shopify in `saas_channel_master`
2. User installs via portal → creates `saas_channel_installations` record
3. N8N workflow uses dynamic credentials via expressions
4. Execution logs tracked in `saas_edge_jobs`

### 5. Log Analysis & Monitoring
**Scenario**: Daily log export and analysis
**Commands**:
```bash
# Manual log export
python n8n_log_exporter.py

# Deploy automated Cloud Function
./deploy_log_exporter.sh
```

## 🔐 Security & Configuration

### Environment Variables
```bash
# N8N Instance
N8N_BASE_URL=https://spinner.saastify.ai
N8N_API_KEY=your-api-key

# Database Connection
DB_HOST=10.42.194.4
DB_USER=n8n_user
DB_PASSWORD=saasdbforn8n2025
DB_DATABASE=catalog-edge-db

# GCP Configuration
GOOGLE_CLOUD_PROJECT=saastify-base-wm
GCS_BUCKET_NAME=saas_job_logs
```

### Credential Management
- **Platform Credentials**: Stored in `saas_channel_master.capabilities.credential_schemas`
- **User Credentials**: Stored in `saas_channel_installations.installation_config`
- **Runtime Access**: Via database function `get_tenant_credential()`
- **N8N Integration**: Dynamic expressions in workflow parameters

## 📊 Data Flow Architecture

### Integration Sync Flow
```
N8N API → fetch_n8n_integrations.py → JSON Processing → Database Transformation → catalog-edge-db
    ↓
Channel Master Registry → Admin Portal → User Marketplace → Installation Wizard
    ↓
Multi-tenant Credentials → Dynamic N8N Workflows → Execution Tracking → Analytics
```

### Log Export Flow
```
N8N Executions → PostgreSQL → Log Exporter → GCS Bucket → Analytics Processing
    ↓
Daily Reports → Usage Metrics → Cost Analysis → Performance Monitoring
```

### AI Workflow Flow
```
User Input → Webhook → N8N Workflow → AI Provider API → Response Processing → Database Storage
    ↓
Conversation Memory → Session Management → Usage Tracking → Cost Attribution
```

## 📈 Performance & Scaling

### Current Metrics
- **Integration Capacity**: 200+ channels supported
- **Multi-tenancy**: Unlimited tenants via `saas_edge_id`
- **Workflow Execution**: Tracked in `saas_edge_jobs`
- **Log Storage**: Daily exports to GCS with lifecycle management
- **AI Usage**: Token tracking and cost analysis per tenant

### Optimization Points
- **Database Connections**: Connection pooling for high concurrency
- **Credential Caching**: Redis layer for frequent credential lookups  
- **Webhook Routing**: Optimized path resolution for tenant workflows
- **Log Processing**: Batch processing for large execution volumes

## 🛠️ Troubleshooting

### Common Issues

#### Database Connection Failed
```bash
# Test connection
python test_db_connection.py

# Check environment variables
echo $DB_HOST $DB_USER
```

#### N8N API Connection Failed
```bash
# Test with sample data
python fetch_n8n_integrations.py --sample-only

# Verify N8N instance
curl -H "X-N8N-API-KEY: $N8N_API_KEY" "$N8N_BASE_URL/api/v1/healthz"
```

#### Integration Sync Errors
```bash
# Check database schema
python sync_integrations_to_db_clean.py processed_file.json --validate-only \
  --db-host HOST --db-user USER --db-password PASS

# Run with update flag
python sync_integrations_to_db_clean.py processed_file.json --update \
  --db-host HOST --db-user USER --db-password PASS
```

#### AI Workflow Issues
```bash
# Check AI system health
cd n8n-ai-management
./scripts/health-check.sh

# Verify workflow deployment
./scripts/deploy-workflows.sh --dry-run
```

## 🔄 Maintenance Tasks

### Daily Operations
- **Log Export**: Automated via Cloud Function
- **Health Checks**: System monitoring and alerts
- **Usage Tracking**: AI token consumption and costs

### Weekly Operations
- **Integration Sync**: Update channel registry with new N8N nodes
- **Workflow Backup**: Export and backup all active workflows
- **Performance Review**: Analyze execution metrics and optimize

### Monthly Operations
- **Security Audit**: Review credentials and access patterns
- **Cost Analysis**: AI usage costs and infrastructure optimization
- **Capacity Planning**: Scale infrastructure based on usage growth

## 🎯 Success Metrics

This system enables **1000X faster delivery** through:

1. **Integration Bootstrap**: 200+ ready integrations vs building each one
2. **Multi-tenant Architecture**: Instant tenant isolation and scaling
3. **AI Workflow Templates**: Pre-built automation vs custom development
4. **Dynamic Configuration**: Runtime flexibility vs static configurations
5. **Monitoring & Analytics**: Built-in observability vs manual tracking

## 📞 Support & Resources

### Key Documentation
- `IMPLEMENTATION_GUIDE.md`: Complete setup and usage guide
- `admin_portal_design.md`: UI/UX specifications for admin interface
- `n8n-ai-management/docs/`: AI system specific documentation
- `README_log_exporter.md`: Log export system documentation

### Production Instance
- **N8N URL**: https://spinner.saastify.ai
- **Database**: Cloud SQL PostgreSQL in `saastify-base-wm`
- **Logs**: GCS bucket `saas_job_logs`
- **Project**: saastify-base-wm (GCP)

---

**Repository Purpose**: Cold start enabler for N8N automation and channel integration management
**Target Outcome**: 1000X faster platform delivery through pre-built integration ecosystem
**Maintainer**: Saastify Platform Team
**Last Updated**: 2025-09-07
