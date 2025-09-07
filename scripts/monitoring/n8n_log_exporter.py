#!/usr/bin/env python3
"""
N8N Log Exporter to Google Cloud Storage
=========================================

This script extracts execution logs from the N8N PostgreSQL database and uploads them 
to GCS with the folder structure: gs://saas_job_logs/n8n/<saas_edge_id>/<job_type>/<channel>/<date>/

Features:
- Connects to Cloud SQL PostgreSQL instance
- Extracts logs by saas_edge_id, job_type, channel, and date
- Uploads structured JSON logs to GCS
- Supports filtering and incremental exports
- Error handling and retry logic
- Logging for monitoring and debugging

Usage:
    python n8n_log_exporter.py --date 2024-01-15 [--saas-edge-id ID] [--job-type TYPE] [--channel CHAN]

Requirements:
    pip install google-cloud-storage psycopg2-binary python-dotenv
"""

import os
import json
import logging
import argparse
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Any
import psycopg2
from google.cloud import storage
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler('n8n_log_exporter.log')
    ]
)
logger = logging.getLogger(__name__)

class N8NLogExporter:
    """N8N log exporter to Google Cloud Storage"""
    
    def __init__(self):
        """Initialize the exporter with database and GCS connections"""
        # Database configuration
        self.db_config = {
            'host': os.getenv('DB_POSTGRESDB_HOST', 'localhost'),
            'port': int(os.getenv('DB_POSTGRESDB_PORT', 5432)),
            'database': os.getenv('DB_POSTGRESDB_DATABASE', 'n8n'),
            'user': os.getenv('DB_POSTGRESDB_USER', 'n8n'),
            'password': os.getenv('DB_POSTGRESDB_PASSWORD')
        }
        
        # GCS configuration
        self.bucket_name = os.getenv('GCS_BUCKET_NAME', 'saas_job_logs')
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
        
        query = """
        WITH workflow_metadata AS (
          SELECT 
            id as workflow_id,
            name,
            COALESCE(
              meta->>'saas_edge_id',
              settings->>'saas_edge_id',
              'unknown'
            ) as saas_edge_id,
            COALESCE(
              meta->>'job_type',
              settings->>'job_type',
              CASE 
                WHEN name ILIKE '%webhook%' THEN 'webhook'
                WHEN name ILIKE '%schedule%' THEN 'scheduled'
                WHEN name ILIKE '%trigger%' THEN 'trigger'
                ELSE 'workflow'
              END
            ) as job_type,
            COALESCE(
              meta->>'channel',
              settings->>'channel',
              'production'
            ) as channel
          FROM workflow_entity
          WHERE deletedAt IS NULL
        )
        SELECT 
          e.id as execution_id,
          w.saas_edge_id,
          w.job_type,
          w.channel,
          w.name as workflow_name,
          e.status,
          e.mode,
          e.startedAt,
          e.stoppedAt,
          e.createdAt,
          e.finished,
          e.retryOf,
          DATE(COALESCE(e.startedAt, e.createdAt)) as execution_date,
          CASE 
            WHEN e.startedAt IS NOT NULL AND e.stoppedAt IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (e.stoppedAt - e.startedAt)) * 1000
            ELSE NULL 
          END as duration_ms
        FROM execution_entity e
        INNER JOIN workflow_metadata w ON e.workflowId = w.workflow_id
        WHERE e.deletedAt IS NULL
          AND DATE(COALESCE(e.startedAt, e.createdAt)) = %s
          AND (%s IS NULL OR w.saas_edge_id = %s)
          AND (%s IS NULL OR w.job_type = %s)
          AND (%s IS NULL OR w.channel = %s)
        ORDER BY w.saas_edge_id, w.job_type, w.channel, e.createdAt DESC;
        """
        
        conn = self.get_db_connection()
        try:
            with conn.cursor() as cursor:
                cursor.execute(query, (
                    target_date, saas_edge_id, saas_edge_id,
                    job_type, job_type, channel, channel
                ))
                
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
        
        query = """
        WITH workflow_metadata AS (
          SELECT 
            id as workflow_id,
            name,
            COALESCE(
              meta->>'saas_edge_id',
              settings->>'saas_edge_id',
              'unknown'
            ) as saas_edge_id,
            COALESCE(
              meta->>'job_type',
              settings->>'job_type',
              CASE 
                WHEN name ILIKE '%webhook%' THEN 'webhook'
                WHEN name ILIKE '%schedule%' THEN 'scheduled'
                WHEN name ILIKE '%trigger%' THEN 'trigger'
                ELSE 'workflow'
              END
            ) as job_type,
            COALESCE(
              meta->>'channel',
              settings->>'channel',
              'production'
            ) as channel
          FROM workflow_entity
          WHERE deletedAt IS NULL
        ),
        daily_stats AS (
          SELECT 
            w.saas_edge_id,
            w.job_type,
            w.channel,
            DATE(COALESCE(e.startedAt, e.createdAt)) as execution_date,
            COUNT(*) as total_executions,
            COUNT(CASE WHEN e.status = 'success' THEN 1 END) as successful,
            COUNT(CASE WHEN e.status = 'error' THEN 1 END) as failed,
            COUNT(CASE WHEN e.status = 'running' THEN 1 END) as running,
            COUNT(CASE WHEN e.status = 'waiting' THEN 1 END) as waiting,
            AVG(
              CASE 
                WHEN e.startedAt IS NOT NULL AND e.stoppedAt IS NOT NULL 
                THEN EXTRACT(EPOCH FROM (e.stoppedAt - e.startedAt)) * 1000
                ELSE NULL 
              END
            ) as avg_duration_ms,
            MIN(e.startedAt) as first_execution,
            MAX(e.stoppedAt) as last_execution,
            COUNT(DISTINCT w.workflow_id) as unique_workflows
          FROM execution_entity e
          INNER JOIN workflow_metadata w ON e.workflowId = w.workflow_id
          WHERE e.deletedAt IS NULL
            AND DATE(COALESCE(e.startedAt, e.createdAt)) = %s
            AND (%s IS NULL OR w.saas_edge_id = %s)
            AND (%s IS NULL OR w.job_type = %s)
            AND (%s IS NULL OR w.channel = %s)
          GROUP BY w.saas_edge_id, w.job_type, w.channel, DATE(COALESCE(e.startedAt, e.createdAt))
        )
        SELECT 
          *,
          ROUND((successful::float / NULLIF(total_executions, 0) * 100)::numeric, 2) as success_rate_percent,
          ROUND((failed::float / NULLIF(total_executions, 0) * 100)::numeric, 2) as failure_rate_percent
        FROM daily_stats
        ORDER BY saas_edge_id, job_type, channel;
        """
        
        conn = self.get_db_connection()
        try:
            with conn.cursor() as cursor:
                cursor.execute(query, (
                    target_date, saas_edge_id, saas_edge_id,
                    job_type, job_type, channel, channel
                ))
                
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
            summary_data = {
                "export_metadata": {
                    "export_date": datetime.now().isoformat(),
                    "target_date": target_date,
                    "type": "daily_summary",
                    "exporter_version": "1.0.0"
                },
                "summary_stats": stats
            }
            
            # Upload summary for each unique combination
            for stat in stats:
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
                    **summary_data,
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

def main():
    """Main CLI entry point"""
    parser = argparse.ArgumentParser(description="Export N8N logs to Google Cloud Storage")
    parser.add_argument("--date", required=True, help="Target date (YYYY-MM-DD)")
    parser.add_argument("--saas-edge-id", help="Filter by SaaS Edge ID")
    parser.add_argument("--job-type", help="Filter by job type")
    parser.add_argument("--channel", help="Filter by channel")
    parser.add_argument("--yesterday", action="store_true", help="Export yesterday's logs")
    
    args = parser.parse_args()
    
    # Use yesterday's date if specified
    if args.yesterday:
        target_date = (datetime.now() - timedelta(days=1)).strftime("%Y-%m-%d")
    else:
        target_date = args.date
    
    try:
        exporter = N8NLogExporter()
        result = exporter.export_logs(
            target_date=target_date,
            saas_edge_id=args.saas_edge_id,
            job_type=args.job_type,
            channel=args.channel
        )
        
        print(json.dumps(result, indent=2))
        
    except Exception as e:
        logger.error(f"Export failed: {e}")
        print(json.dumps({"status": "error", "message": str(e)}, indent=2))
        exit(1)

if __name__ == "__main__":
    main()
