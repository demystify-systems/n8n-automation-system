#!/bin/bash

# N8N Cloud Run Deployment Script with Persistent Configuration
# This ensures database and configuration persistence across deployments

set -e

# Configuration
PROJECT_ID="saastify-base-wm"
REGION="us-central1" 
DOMAIN="spinner.saastify.ai"
SERVICE_NAME="n8n-main"
SQL_INSTANCE="saastify-pgdb-us"
VPC_NETWORK="default"
VPC_CONNECTOR="n8n-connector"
REDIS_INSTANCE="n8n-redis"
N8N_DB_NAME="n8n"
N8N_DB_USER="n8n_user"
SA_EMAIL="n8n-runner@saastify-base-wm.iam.gserviceaccount.com"

# Database IPs (persistent)
SQL_PRIVATE_IP="10.42.194.4"
REDIS_HOST="10.44.70.68"

# Get connection name
SQL_CONN_NAME="$(gcloud sql instances describe "$SQL_INSTANCE" --format='value(connectionName)')"

echo "=== N8N Deployment Script ==="
echo "Deploying n8n with COMPLETE persistent configuration..."
echo ""

# Generate admin password if not set
if [ -z "$N8N_ADMIN_PASS" ]; then
    export N8N_ADMIN_PASS="$(openssl rand -base64 24)"
    echo "Generated new admin password: $N8N_ADMIN_PASS"
fi

# Deploy with COMPLETE configuration
gcloud run deploy $SERVICE_NAME \
  --image=n8nio/n8n:latest \
  --region="$REGION" \
  --service-account="$SA_EMAIL" \
  --allow-unauthenticated \
  --min-instances=1 --max-instances=2 \
  --add-cloudsql-instances="$SQL_CONN_NAME" \
  --vpc-connector="$VPC_CONNECTOR" --vpc-egress=all-traffic \
  --cpu=2 --memory=1Gi --concurrency=15 \
  --port=5678 \
  --timeout=600 \
  --set-env-vars=EXECUTIONS_MODE=queue,N8N_METRICS=true \
  --set-env-vars=DB_TYPE=postgresdb,DB_POSTGRESDB_DATABASE="$N8N_DB_NAME",DB_POSTGRESDB_USER="$N8N_DB_USER",DB_POSTGRESDB_HOST="$SQL_PRIVATE_IP",DB_POSTGRESDB_PORT=5432,DB_POSTGRESDB_POOL_SIZE=10,DB_POSTGRESDB_CONNECTION_TIMEOUT=60000 \
  --set-env-vars=QUEUE_BULL_REDIS_HOST="$REDIS_HOST",QUEUE_BULL_REDIS_PORT=6379 \
  --set-env-vars=N8N_HOST="$DOMAIN",N8N_PROTOCOL=https,WEBHOOK_URL="https://$DOMAIN" \
  --set-env-vars=N8N_BASIC_AUTH_ACTIVE=true,N8N_BASIC_AUTH_USER=admin,N8N_BASIC_AUTH_PASSWORD="$N8N_ADMIN_PASS" \
  --set-env-vars=N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false,N8N_DIAGNOSTICS_ENABLED=false \
  --set-secrets=N8N_ENCRYPTION_KEY=N8N_ENCRYPTION_KEY:latest,DB_POSTGRESDB_PASSWORD=N8N_DB_PASS:latest

echo ""
echo "✅ Deployment completed!"
echo ""
echo "🌐 URL: https://$DOMAIN"
echo "🔐 Username: admin"
echo "🔑 Password: $N8N_ADMIN_PASS"
echo ""
echo "🚨 IMPORTANT: This script preserves database configuration"
echo "   Your multi-tenant templates will persist across deployments"
echo ""
