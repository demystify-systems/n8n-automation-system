"""
Google Cloud Function for N8N Log Export Automation
===================================================

This Cloud Function is triggered by Cloud Scheduler to automatically export
N8N logs daily to Google Cloud Storage with the specified folder structure.

Deployment:
    gcloud functions deploy n8n-log-exporter \
        --runtime python39 \
        --trigger-http \
        --entry-point export_logs_handler \
        --allow-unauthenticated \
        --memory 512MB \
        --timeout 540s \
        --set-env-vars GCS_BUCKET_NAME=saas_job_logs,DB_POSTGRESDB_HOST=10.75.16.3

Cloud Scheduler:
    gcloud scheduler jobs create http n8n-daily-log-export \
        --schedule="0 1 * * *" \
        --uri=https://YOUR_REGION-YOUR_PROJECT.cloudfunctions.net/n8n-log-exporter \
        --http-method=POST \
        --headers="Content-Type=application/json" \
        --message-body='{"date":"yesterday"}'

Requirements (requirements.txt):
    google-cloud-storage==2.10.0
    psycopg2-binary==2.9.7
    functions-framework==3.4.0
"""

import os
import json
import logging
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Any
import psycopg2
from google.cloud import storage
import functions_framework

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class N8NLogExporter:
    """N8N log exporter to Google Cloud Storage (Cloud Function version)"""
    
    def __init__(self):
        """Initialize the exporter with database and GCS connections"""
        # Database configuration from environment variables
        self.db_config = {
            'host': os.environ.get('DB_POSTGRESDB_HOST'),
            'port': int(os.environ.get('DB_POSTGRESDB_PORT', 5432)),
            'database': os.environ.get('DB_POSTGRESDB_DATABASE', 'n8n'),
            'user': os.environ.get('DB_POSTGRESDB_USER', 'n8n'),
            'password': os.environ.get('DB_POSTGRESDB_PASSWORD')
        }
        
        # Validate required database config
        if not all([self.db_config['host'], self.db_config['password']]):
            raise ValueError("Missing required database configuration")
        
        # GCS configuration
        self.bucket_name = os.environ.get('GCS_BUCKET_NAME', 'saas_job_logs')
        self.gcs_prefix = 'n8n'
        
        # Initialize GCS client
        self.storage_client = storage.Client()
        self.bucket = self.storage_client.bucket(self.bucket_name)
        
        logger.info(f"Initialized N8N Log Exporter for bucket: {self.bucket_name}")
    
    def get_db_connection(self):
        """Get database connection with retry logic"""
        max_retries = 3
        for attempt in range(max_retries):
            try:
                conn = psycopg2.connect(**self.db_config)
                logger.info("Database connection established")
                return conn
            except psycopg2.Error as e:
                logger.error(f"Database connection attempt {attempt + 1} failed: {e}")
                if attempt == max_retries - 1:
                    raise
        return None
    
    def extract_execution_logs(self, 
                             target_date: str,
                             saas_edge_id: Optional[str] = None,
                             job_type: Optional[str] = None,
                             channel: Optional[str] = None) -> List[Dict[str, Any]]:
        """Extract execution logs from database"""
        
        # Simple test query to verify database connection and schema
        query = """
        SELECT 
          e.id as execution_id,
          'unknown' as saas_edge_id,
          'workflow' as job_type,
          'production' as channel,
          'test_workflow' as workflow_name,
          e.status,
          COALESCE(e.mode, 'manual') as mode,
          e."startedAt",
          e."stoppedAt",
          e."createdAt",
          COALESCE(e.finished, false) as finished,
          e."retryOf",
          DATE(COALESCE(e."startedAt", e."createdAt")) as execution_date,
          CASE 
            WHEN e."startedAt" IS NOT NULL AND e."stoppedAt" IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (e."stoppedAt" - e."startedAt")) * 1000
            ELSE NULL 
          END as duration_ms
        FROM execution_entity e
        WHERE DATE(COALESCE(e."startedAt", e."createdAt")) = %s
        ORDER BY e."createdAt" DESC
        LIMIT 100;
        """
        
        conn = self.get_db_connection()
        try:
            with conn.cursor() as cursor:
                cursor.execute(query, (target_date,))
                
                columns = [desc[0] for desc in cursor.description]
                rows = cursor.fetchall()
                
                logs = []
                for row in rows:
                    log_entry = dict(zip(columns, row))
                    # Convert datetime objects to ISO strings
                    for key, value in log_entry.items():
                        if isinstance(value, datetime):
                            log_entry[key] = value.isoformat()
                    logs.append(log_entry)
                
                logger.info(f"Extracted {len(logs)} execution logs for date: {target_date}")
                return logs
                
        except Exception as e:
            logger.error(f"Error extracting logs: {e}")
            raise
        finally:
            conn.close()
    
    def extract_summary_stats(self,
                            target_date: str,
                            saas_edge_id: Optional[str] = None,
                            job_type: Optional[str] = None,
                            channel: Optional[str] = None) -> List[Dict[str, Any]]:
        """Extract summary statistics for the date"""
        
        # Simple summary stats query
        query = """
        SELECT 
          'unknown' as saas_edge_id,
          'workflow' as job_type,
          'production' as channel,
          DATE(COALESCE(e."startedAt", e."createdAt")) as execution_date,
          COUNT(*) as total_executions,
          COUNT(CASE WHEN e.status = 'success' THEN 1 END) as successful,
          COUNT(CASE WHEN e.status = 'error' THEN 1 END) as failed,
          COUNT(CASE WHEN e.status = 'running' THEN 1 END) as running,
          COUNT(CASE WHEN e.status = 'waiting' THEN 1 END) as waiting,
          AVG(
            CASE 
              WHEN e."startedAt" IS NOT NULL AND e."stoppedAt" IS NOT NULL 
              THEN EXTRACT(EPOCH FROM (e."stoppedAt" - e."startedAt")) * 1000
              ELSE NULL 
            END
          ) as avg_duration_ms,
          MIN(e."startedAt") as first_execution,
          MAX(e."stoppedAt") as last_execution,
          COUNT(*) as unique_workflows,
          ROUND((COUNT(CASE WHEN e.status = 'success' THEN 1 END)::float / NULLIF(COUNT(*), 0) * 100)::numeric, 2) as success_rate_percent,
          ROUND((COUNT(CASE WHEN e.status = 'error' THEN 1 END)::float / NULLIF(COUNT(*), 0) * 100)::numeric, 2) as failure_rate_percent
        FROM execution_entity e
        WHERE DATE(COALESCE(e."startedAt", e."createdAt")) = %s
        GROUP BY DATE(COALESCE(e."startedAt", e."createdAt"))
        ORDER BY execution_date;
        """
        
        conn = self.get_db_connection()
        try:
            with conn.cursor() as cursor:
                cursor.execute(query, (target_date,))
                
                columns = [desc[0] for desc in cursor.description]
                rows = cursor.fetchall()
                
                stats = []
                for row in rows:
                    stat_entry = dict(zip(columns, row))
                    # Convert datetime and decimal objects
                    for key, value in stat_entry.items():
                        if isinstance(value, datetime):
                            stat_entry[key] = value.isoformat()
                        elif hasattr(value, '__float__'):
                            stat_entry[key] = float(value)
                    stats.append(stat_entry)
                
                logger.info(f"Extracted {len(stats)} summary stats for date: {target_date}")
                return stats
                
        except Exception as e:
            logger.error(f"Error extracting summary stats: {e}")
            raise
        finally:
            conn.close()
    
    def upload_to_gcs(self, data: Dict[str, Any], blob_path: str) -> bool:
        """Upload data to Google Cloud Storage"""
        try:
            blob = self.bucket.blob(blob_path)
            blob.upload_from_string(
                json.dumps(data, indent=2, default=str),
                content_type='application/json'
            )
            logger.info(f"Successfully uploaded to: gs://{self.bucket_name}/{blob_path}")
            return True
        except Exception as e:
            logger.error(f"Failed to upload to GCS: {e}")
            return False
    
    def generate_gcs_path(self, saas_edge_id: str, job_type: str, channel: str, 
                         date: str, filename: str) -> str:
        """Generate GCS blob path following the required structure"""
        return f"{self.gcs_prefix}/{saas_edge_id}/{job_type}/{channel}/{date}/{filename}"
    
    def export_logs(self, 
                   target_date: str,
                   saas_edge_id: Optional[str] = None,
                   job_type: Optional[str] = None,
                   channel: Optional[str] = None) -> Dict[str, Any]:
        """Main export function"""
        
        logger.info(f"Starting log export for date: {target_date}")
        
        # Extract logs and summary stats
        logs = self.extract_execution_logs(target_date, saas_edge_id, job_type, channel)
        stats = self.extract_summary_stats(target_date, saas_edge_id, job_type, channel)
        
        if not logs and not stats:
            logger.info("No logs found for the specified criteria")
            return {"status": "success", "message": "No logs found", "uploaded_files": []}
        
        # Group logs by saas_edge_id, job_type, channel for separate files
        grouped_logs = {}
        for log in logs:
            key = (log['saas_edge_id'], log['job_type'], log['channel'])
            if key not in grouped_logs:
                grouped_logs[key] = []
            grouped_logs[key].append(log)
        
        uploaded_files = []
        
        # Upload grouped logs
        for (edge_id, j_type, chan), log_group in grouped_logs.items():
            # Prepare log data structure
            log_data = {
                "export_metadata": {
                    "export_date": datetime.now().isoformat(),
                    "target_date": target_date,
                    "saas_edge_id": edge_id,
                    "job_type": j_type,
                    "channel": chan,
                    "total_executions": len(log_group),
                    "exporter_version": "1.0.0"
                },
                "executions": log_group
            }
            
            # Generate file path
            filename = f"executions_{target_date.replace('-', '')}.json"
            blob_path = self.generate_gcs_path(edge_id, j_type, chan, target_date, filename)
            
            # Upload to GCS
            if self.upload_to_gcs(log_data, blob_path):
                uploaded_files.append(blob_path)
        
        # Upload summary stats (if any)
        if stats:
            # Upload summary for each unique combination
            processed_combinations = set()
            for stat in stats:
                combination = (stat['saas_edge_id'], stat['job_type'], stat['channel'])
                if combination in processed_combinations:
                    continue
                processed_combinations.add(combination)
                
                filename = f"summary_{target_date.replace('-', '')}.json"
                blob_path = self.generate_gcs_path(
                    stat['saas_edge_id'], 
                    stat['job_type'], 
                    stat['channel'], 
                    target_date, 
                    filename
                )
                
                # Create summary for this specific combination
                filtered_summary = {
                    "export_metadata": {
                        "export_date": datetime.now().isoformat(),
                        "target_date": target_date,
                        "type": "daily_summary",
                        "exporter_version": "1.0.0"
                    },
                    "summary_stats": [s for s in stats if (
                        s['saas_edge_id'] == stat['saas_edge_id'] and
                        s['job_type'] == stat['job_type'] and 
                        s['channel'] == stat['channel']
                    )]
                }
                
                if self.upload_to_gcs(filtered_summary, blob_path):
                    uploaded_files.append(blob_path)
        
        logger.info(f"Export completed. Uploaded {len(uploaded_files)} files to GCS")
        
        return {
            "status": "success",
            "target_date": target_date,
            "total_executions": len(logs),
            "total_groups": len(grouped_logs),
            "uploaded_files": uploaded_files
        }

@functions_framework.http
def export_logs_handler(request):
    """Cloud Function HTTP handler for log exports"""
    try:
        # Parse request data
        request_json = request.get_json(silent=True)
        if not request_json:
            request_json = {}
        
        # Determine target date
        date_param = request_json.get('date', 'yesterday')
        if date_param == 'yesterday':
            target_date = (datetime.now() - timedelta(days=1)).strftime("%Y-%m-%d")
        elif date_param == 'today':
            target_date = datetime.now().strftime("%Y-%m-%d")
        else:
            target_date = date_param
        
        # Extract optional filters
        saas_edge_id = request_json.get('saas_edge_id')
        job_type = request_json.get('job_type')
        channel = request_json.get('channel')
        
        # Initialize exporter and run export
        exporter = N8NLogExporter()
        result = exporter.export_logs(
            target_date=target_date,
            saas_edge_id=saas_edge_id,
            job_type=job_type,
            channel=channel
        )
        
        # Return success response
        return {
            "statusCode": 200,
            "body": result
        }
        
    except Exception as e:
        logger.error(f"Export failed: {e}", exc_info=True)
        return {
            "statusCode": 500,
            "body": {
                "status": "error",
                "message": str(e),
                "error_type": type(e).__name__
            }
        }
