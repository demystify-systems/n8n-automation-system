#!/bin/bash

# N8N Log Exporter Deployment Script
# This script deploys the log exporter as a Cloud Function and sets up Cloud Scheduler

set -e

# Configuration variables - Updated for saastify-base-wm environment
PROJECT_ID="saastify-base-wm"
REGION="us-central1"
FUNCTION_NAME="n8n-log-exporter"
SCHEDULER_JOB_NAME="n8n-daily-log-export"
GCS_BUCKET_NAME="saas_job_logs"
DB_HOST="10.42.194.4"  # Your Cloud SQL private IP
DB_NAME="n8n"
DB_USER="n8n_user"
DB_PASSWORD="saasdbforn8n2025"  # Retrieved from secret manager

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting N8N Log Exporter deployment...${NC}"

# Check if required commands are available
command -v gcloud >/dev/null 2>&1 || { echo -e "${RED}gcloud CLI is required but not installed. Aborting.${NC}" >&2; exit 1; }

# Set the project
echo -e "${YELLOW}Setting project: ${PROJECT_ID}${NC}"
gcloud config set project "${PROJECT_ID}"

# Enable required APIs if not already enabled (skipping - already enabled)
echo -e "${YELLOW}Required APIs are already enabled${NC}"

# Create GCS bucket if it doesn't exist
echo -e "${YELLOW}Creating GCS bucket: ${GCS_BUCKET_NAME}${NC}"
if ! gsutil ls -b gs://"${GCS_BUCKET_NAME}" >/dev/null 2>&1; then
    gsutil mb gs://"${GCS_BUCKET_NAME}"
    echo -e "${GREEN}Bucket created successfully${NC}"
else
    echo -e "${YELLOW}Bucket already exists${NC}"
fi

# Deploy the Cloud Function
echo -e "${YELLOW}Deploying Cloud Function: ${FUNCTION_NAME}${NC}"
gcloud functions deploy "${FUNCTION_NAME}" \
    --runtime python39 \
    --trigger-http \
    --entry-point export_logs_handler \
    --allow-unauthenticated \
    --memory 512MB \
    --timeout 540s \
    --region="${REGION}" \
    --source=. \
    --set-env-vars "GCS_BUCKET_NAME=${GCS_BUCKET_NAME},DB_POSTGRESDB_HOST=${DB_HOST},DB_POSTGRESDB_DATABASE=${DB_NAME},DB_POSTGRESDB_USER=${DB_USER},DB_POSTGRESDB_PASSWORD=${DB_PASSWORD}" \
    --ingress-settings all \
    --vpc-connector n8n-connector \
    --egress-settings private-ranges-only

# Get the function URL
FUNCTION_URL=$(gcloud functions describe "${FUNCTION_NAME}" --region="${REGION}" --format="value(url)")
echo -e "${GREEN}Function deployed at: ${FUNCTION_URL}${NC}"

# Delete existing scheduler job if it exists
if gcloud scheduler jobs describe "${SCHEDULER_JOB_NAME}" --location="${REGION}" >/dev/null 2>&1; then
    echo -e "${YELLOW}Deleting existing scheduler job...${NC}"
    gcloud scheduler jobs delete "${SCHEDULER_JOB_NAME}" --location="${REGION}" --quiet
fi

# Create Cloud Scheduler job for daily exports (1 AM UTC)
echo -e "${YELLOW}Creating Cloud Scheduler job: ${SCHEDULER_JOB_NAME}${NC}"
gcloud scheduler jobs create http "${SCHEDULER_JOB_NAME}" \
    --schedule="0 1 * * *" \
    --uri="${FUNCTION_URL}" \
    --http-method=POST \
    --headers="Content-Type=application/json" \
    --message-body='{"date":"yesterday"}' \
    --location="${REGION}" \
    --description="Daily N8N log export to GCS"

echo -e "${GREEN}Scheduler job created successfully${NC}"

# Test the function
echo -e "${YELLOW}Testing the function with a manual trigger...${NC}"
curl -X POST "${FUNCTION_URL}" \
    -H "Content-Type: application/json" \
    -d '{"date":"yesterday"}' \
    --max-time 600

echo -e "\n${GREEN}Deployment completed successfully!${NC}"
echo -e "Function URL: ${FUNCTION_URL}"
echo -e "Scheduler Job: ${SCHEDULER_JOB_NAME} (runs daily at 1 AM UTC)"
echo -e "GCS Bucket: gs://${GCS_BUCKET_NAME}"

echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Check the function logs: gcloud functions logs read ${FUNCTION_NAME} --region=${REGION}"
echo -e "2. Verify the scheduler job: gcloud scheduler jobs list --location=${REGION}"
echo -e "3. Check GCS bucket for exported logs: gsutil ls gs://${GCS_BUCKET_NAME}/n8n/"
echo -e "4. Test manual export: curl -X POST ${FUNCTION_URL} -H 'Content-Type: application/json' -d '{\"date\":\"yesterday\"}'"
