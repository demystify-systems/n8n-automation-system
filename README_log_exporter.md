# N8N Log Exporter to Google Cloud Storage

This system automatically extracts execution logs from your N8N PostgreSQL database and uploads them to Google Cloud Storage with a structured folder hierarchy.

## Overview

The log exporter creates the following GCS folder structure:
```
gs://saas_job_logs/n8n/<saas_edge_id>/<job_type>/<channel>/<date>/
├── executions_YYYYMMDD.json    # Detailed execution logs
└── summary_YYYYMMDD.json       # Daily summary statistics
```

## Features

- **Automated Daily Exports**: Cloud Scheduler triggers exports at 1 AM UTC
- **Structured Filtering**: Groups logs by `saas_edge_id`, `job_type`, and `channel`
- **Comprehensive Logging**: Includes execution details and summary statistics
- **Error Handling**: Retry logic and comprehensive error reporting
- **Scalable Architecture**: Cloud Function deployment for automatic scaling

## Files in This Package

1. **`n8n_log_exporter.py`** - Main Python script for local execution
2. **`cloud_function_main.py`** - Cloud Function version for serverless deployment
3. **`n8n_log_queries.sql`** - SQL queries for data extraction
4. **`requirements.txt`** - Python dependencies
5. **`deploy_log_exporter.sh`** - Deployment script
6. **`.env.template`** - Environment variables template

## Setup Instructions

### 1. Prerequisites

- Google Cloud Project with billing enabled
- N8N running on Cloud Run with PostgreSQL database
- `gcloud` CLI installed and configured
- Required permissions:
  - Cloud Functions Admin
  - Cloud Scheduler Admin
  - Storage Admin
  - Cloud SQL Client

### 2. Environment Configuration

1. Copy the environment template:
   ```bash
   cp .env.template .env
   ```

2. Update the `.env` file with your database configuration:
   ```bash
   DB_POSTGRESDB_HOST=10.75.16.3  # Your Cloud SQL private IP
   DB_POSTGRESDB_DATABASE=n8n
   DB_POSTGRESDB_USER=n8n_user
   DB_POSTGRESDB_PASSWORD=your_actual_password
   GCS_BUCKET_NAME=saas_job_logs
   ```

### 3. Deploy the System

1. Update the deployment script configuration:
   ```bash
   vim deploy_log_exporter.sh
   # Update PROJECT_ID, DB_PASSWORD, and other variables
   ```

2. Make the script executable and run:
   ```bash
   chmod +x deploy_log_exporter.sh
   ./deploy_log_exporter.sh
   ```

3. The script will:
   - Enable required APIs
   - Create the GCS bucket
   - Deploy the Cloud Function
   - Set up the Cloud Scheduler job
   - Test the deployment

### 4. Local Testing (Optional)

For local development and testing:

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Run manually:
   ```bash
   python n8n_log_exporter.py --date 2024-01-15
   python n8n_log_exporter.py --yesterday
   ```

## Data Structure Assumptions

The system assumes your N8N workflows store metadata in the following ways:

### Workflow Metadata
- **saas_edge_id**: Stored in `workflow_entity.meta->>'saas_edge_id'` or `settings->>'saas_edge_id'`
- **job_type**: Derived from workflow name patterns or stored in metadata:
  - Names containing 'webhook' → 'webhook'
  - Names containing 'schedule' → 'scheduled' 
  - Names containing 'trigger' → 'trigger'
  - Default → 'workflow'
- **channel**: Stored in metadata (defaults to 'production')

### Customization

If your metadata structure is different, modify the queries in:
- `n8n_log_exporter.py` (lines 85-130)
- `cloud_function_main.py` (lines 85-130)
- `n8n_log_queries.sql`

## Output Format

### Execution Logs (`executions_YYYYMMDD.json`)
```json
{
  "export_metadata": {
    "export_date": "2024-01-15T12:00:00Z",
    "target_date": "2024-01-14",
    "saas_edge_id": "client001",
    "job_type": "webhook",
    "channel": "production",
    "total_executions": 45,
    "exporter_version": "1.0.0"
  },
  "executions": [
    {
      "execution_id": "12345",
      "saas_edge_id": "client001",
      "job_type": "webhook",
      "channel": "production",
      "workflow_name": "Order Processing Webhook",
      "status": "success",
      "started_at": "2024-01-14T10:30:00Z",
      "stopped_at": "2024-01-14T10:30:05Z",
      "duration_ms": 5000
    }
  ]
}
```

### Summary Statistics (`summary_YYYYMMDD.json`)
```json
{
  "export_metadata": {
    "export_date": "2024-01-15T12:00:00Z",
    "target_date": "2024-01-14",
    "type": "daily_summary",
    "exporter_version": "1.0.0"
  },
  "summary_stats": [
    {
      "saas_edge_id": "client001",
      "job_type": "webhook",
      "channel": "production",
      "execution_date": "2024-01-14",
      "total_executions": 45,
      "successful_executions": 42,
      "failed_executions": 3,
      "success_rate_percent": 93.33,
      "avg_duration_ms": 4200.5
    }
  ]
}
```

## Monitoring and Troubleshooting

### Check Function Logs
```bash
gcloud functions logs read n8n-log-exporter --region=us-central1 --limit=50
```

### Check Scheduler Jobs
```bash
gcloud scheduler jobs list --location=us-central1
gcloud scheduler jobs describe n8n-daily-log-export --location=us-central1
```

### Manual Testing
```bash
# Test the Cloud Function directly
curl -X POST https://REGION-PROJECT.cloudfunctions.net/n8n-log-exporter \
  -H "Content-Type: application/json" \
  -d '{"date":"yesterday"}'

# Check GCS bucket contents
gsutil ls -r gs://saas_job_logs/n8n/
```

### Common Issues

1. **Database Connection Errors**:
   - Verify Cloud SQL instance is running
   - Check VPC network connectivity
   - Confirm database credentials

2. **Permission Errors**:
   - Ensure Cloud Function has proper IAM roles
   - Check GCS bucket permissions
   - Verify Cloud SQL client permissions

3. **No Data Found**:
   - Check if workflows have required metadata fields
   - Verify date range and filters
   - Review SQL queries for your schema

## Customization

### Change Export Schedule
Modify the cron expression in `deploy_log_exporter.sh`:
```bash
--schedule="0 1 * * *"  # Daily at 1 AM UTC
--schedule="0 */6 * * *"  # Every 6 hours
--schedule="0 9 * * 1-5"  # Weekdays at 9 AM UTC
```

### Add Additional Filters
Extend the function to support more filtering options by modifying:
1. Function parameters
2. SQL WHERE clauses
3. GCS folder structure

### Change Output Format
Modify the data preparation sections in the export functions to customize JSON structure.

## Security Considerations

1. **Database Credentials**: Store in Google Secret Manager for production
2. **Function Access**: Use IAM for authentication instead of `--allow-unauthenticated`
3. **Network Security**: Deploy function with VPC connector for private access
4. **Bucket Access**: Use least-privilege IAM roles for GCS access

## Cost Optimization

1. **Function Memory**: Adjust based on data volume (512MB default)
2. **Function Timeout**: Optimize based on export duration
3. **Storage Class**: Use Nearline/Coldline for older logs
4. **Lifecycle Rules**: Set up automatic deletion/archival policies

## Support

For issues or customizations:
1. Check the function logs for detailed error messages
2. Verify database schema matches assumptions
3. Test SQL queries directly against your database
4. Monitor GCS bucket for successful uploads
