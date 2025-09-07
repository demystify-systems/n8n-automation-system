-- N8N LOG EXTRACTION QUERIES
-- Extract logs by saas_edge_id, job_type, channel, and date
-- 
-- Assumptions:
-- - saas_edge_id is stored in workflow meta or settings JSON
-- - job_type can be derived from workflow name or meta
-- - channel (production/staging) is in workflow settings or meta

-- ==========================================
-- 1. EXTRACT EXECUTIONS WITH METADATA
-- ==========================================
WITH workflow_metadata AS (
  SELECT 
    id as workflow_id,
    name,
    -- Extract saas_edge_id from workflow meta/settings JSON
    COALESCE(
      meta->>'saas_edge_id',
      settings->>'saas_edge_id',
      'unknown'
    ) as saas_edge_id,
    -- Extract job_type from workflow meta/name
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
    -- Extract channel (production/staging/dev)
    COALESCE(
      meta->>'channel',
      settings->>'channel',
      'production'
    ) as channel,
    active,
    createdAt,
    updatedAt
  FROM workflow_entity
  WHERE deletedAt IS NULL OR deletedAt IS NULL  -- Only active workflows
),
execution_logs AS (
  SELECT 
    e.id as execution_id,
    e.status,
    e.mode,
    e.startedAt,
    e.stoppedAt,
    e.createdAt,
    e.finished,
    e.retryOf,
    w.saas_edge_id,
    w.job_type,
    w.channel,
    w.name as workflow_name,
    -- Calculate duration
    CASE 
      WHEN e.startedAt IS NOT NULL AND e.stoppedAt IS NOT NULL 
      THEN EXTRACT(EPOCH FROM (e.stoppedAt - e.startedAt)) * 1000 -- milliseconds
      ELSE NULL 
    END as duration_ms,
    -- Extract date for partitioning
    DATE(COALESCE(e.startedAt, e.createdAt)) as execution_date
  FROM execution_entity e
  INNER JOIN workflow_metadata w ON e.workflowId = w.workflow_id
  WHERE e.deletedAt IS NULL
)

-- Main extraction query with parameters
SELECT 
  saas_edge_id,
  job_type,
  channel,
  execution_date,
  COUNT(*) as total_executions,
  COUNT(CASE WHEN status = 'success' THEN 1 END) as successful_executions,
  COUNT(CASE WHEN status = 'error' THEN 1 END) as failed_executions,
  COUNT(CASE WHEN status = 'running' THEN 1 END) as running_executions,
  COUNT(CASE WHEN status = 'waiting' THEN 1 END) as waiting_executions,
  AVG(duration_ms) as avg_duration_ms,
  MIN(startedAt) as first_execution,
  MAX(stoppedAt) as last_execution,
  -- JSON aggregation for detailed logs
  json_agg(
    json_build_object(
      'execution_id', execution_id,
      'status', status,
      'mode', mode,
      'workflow_name', workflow_name,
      'started_at', startedAt,
      'stopped_at', stoppedAt,
      'duration_ms', duration_ms,
      'retry_of', retryOf,
      'finished', finished
    )
  ) as executions_detail
FROM execution_logs
WHERE execution_date = $1  -- Parameter: target date (YYYY-MM-DD)
  AND ($2 IS NULL OR saas_edge_id = $2)  -- Parameter: saas_edge_id filter (optional)
  AND ($3 IS NULL OR job_type = $3)      -- Parameter: job_type filter (optional)  
  AND ($4 IS NULL OR channel = $4)       -- Parameter: channel filter (optional)
GROUP BY saas_edge_id, job_type, channel, execution_date
ORDER BY saas_edge_id, job_type, channel;

-- ==========================================
-- 2. EXTRACT WORKFLOW DEFINITIONS
-- ==========================================
SELECT 
  w.id as workflow_id,
  w.name,
  -- Extract metadata
  COALESCE(w.meta->>'saas_edge_id', w.settings->>'saas_edge_id', 'unknown') as saas_edge_id,
  COALESCE(
    w.meta->>'job_type',
    w.settings->>'job_type',
    CASE 
      WHEN w.name ILIKE '%webhook%' THEN 'webhook'
      WHEN w.name ILIKE '%schedule%' THEN 'scheduled'
      WHEN w.name ILIKE '%trigger%' THEN 'trigger'
      ELSE 'workflow'
    END
  ) as job_type,
  COALESCE(w.meta->>'channel', w.settings->>'channel', 'production') as channel,
  w.active,
  w.triggerCount,
  w.createdAt,
  w.updatedAt,
  -- Workflow structure (simplified)
  json_build_object(
    'nodes_count', json_array_length(w.nodes),
    'connections_count', json_array_length(w.connections),
    'has_trigger', CASE WHEN w.nodes::text ILIKE '%trigger%' THEN true ELSE false END,
    'has_webhook', CASE WHEN w.nodes::text ILIKE '%webhook%' THEN true ELSE false END
  ) as workflow_summary
FROM workflow_entity w
WHERE (w.deletedAt IS NULL OR w.deletedAt IS NULL)
  AND ($1 IS NULL OR DATE(w.updatedAt) = $1)  -- Parameter: target date
  AND ($2 IS NULL OR COALESCE(w.meta->>'saas_edge_id', w.settings->>'saas_edge_id', 'unknown') = $2)
  AND ($3 IS NULL OR COALESCE(
    w.meta->>'job_type',
    w.settings->>'job_type',
    CASE 
      WHEN w.name ILIKE '%webhook%' THEN 'webhook'
      WHEN w.name ILIKE '%schedule%' THEN 'scheduled'
      WHEN w.name ILIKE '%trigger%' THEN 'trigger'
      ELSE 'workflow'
    END
  ) = $3)
  AND ($4 IS NULL OR COALESCE(w.meta->>'channel', w.settings->>'channel', 'production') = $4)
ORDER BY saas_edge_id, job_type, channel, w.updatedAt DESC;

-- ==========================================
-- 3. EXTRACT EXECUTION DATA (DETAILED)
-- ==========================================
WITH workflow_metadata AS (
  SELECT 
    id as workflow_id,
    name,
    COALESCE(meta->>'saas_edge_id', settings->>'saas_edge_id', 'unknown') as saas_edge_id,
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
    COALESCE(meta->>'channel', settings->>'channel', 'production') as channel
  FROM workflow_entity
  WHERE deletedAt IS NULL OR deletedAt IS NULL
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
  END as duration_ms,
  -- Get execution data if needed (be careful with size)
  CASE 
    WHEN $5 = true THEN ed.data 
    ELSE NULL 
  END as execution_data
FROM execution_entity e
INNER JOIN workflow_metadata w ON e.workflowId = w.workflow_id
LEFT JOIN execution_data ed ON e.id = ed.executionId
WHERE e.deletedAt IS NULL
  AND DATE(COALESCE(e.startedAt, e.createdAt)) = $1  -- Parameter: target date
  AND ($2 IS NULL OR w.saas_edge_id = $2)            -- Parameter: saas_edge_id filter
  AND ($3 IS NULL OR w.job_type = $3)                -- Parameter: job_type filter
  AND ($4 IS NULL OR w.channel = $4)                 -- Parameter: channel filter
ORDER BY w.saas_edge_id, w.job_type, w.channel, e.createdAt DESC;

-- ==========================================
-- 4. SUMMARY QUERY FOR DAILY REPORTS
-- ==========================================
WITH workflow_metadata AS (
  SELECT 
    id as workflow_id,
    name,
    COALESCE(meta->>'saas_edge_id', settings->>'saas_edge_id', 'unknown') as saas_edge_id,
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
    COALESCE(meta->>'channel', settings->>'channel', 'production') as channel
  FROM workflow_entity
  WHERE deletedAt IS NULL OR deletedAt IS NULL
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
    AND DATE(COALESCE(e.startedAt, e.createdAt)) = $1
  GROUP BY w.saas_edge_id, w.job_type, w.channel, DATE(COALESCE(e.startedAt, e.createdAt))
)
SELECT 
  *,
  ROUND((successful::float / total_executions * 100)::numeric, 2) as success_rate_percent,
  ROUND((failed::float / total_executions * 100)::numeric, 2) as failure_rate_percent
FROM daily_stats
ORDER BY saas_edge_id, job_type, channel;
