# TimescaleDB Reference Guide

## Table Creation

Create a standard table for time-series data:

```postgresql
CREATE TABLE conditions (
   time        TIMESTAMPTZ       NOT NULL,
   location    TEXT              NOT NULL,
   device      TEXT              NOT NULL,
   temperature DOUBLE PRECISION  NULL,
   humidity    DOUBLE PRECISION  NULL
);
```

## Hypertable Management

Convert a regular table to a hypertable:

```postgresql
SELECT create_hypertable('<table name>', by_range('<column name>', chunk_time_interval));
```

Example with specific time intervals:

```postgresql
SELECT create_hypertable('conditions', by_range('time', INTERVAL '1 day'));
SELECT create_hypertable('conditions', by_range('time', INTERVAL '24 hours'));
```

Create hypertable without default indexes:

```postgresql
SELECT create_hypertable('conditions', by_range('time'))
  CREATE_DEFAULT_INDEXES false;
```

Get hypertable information:

```postgresql
SELECT * FROM timescaledb_information.dimensions;
```

## Partitioning

Create a hypertable with time partitioning:

```postgresql
SELECT create_hypertable('conditions', by_range('time', INTERVAL '1 day')); -- Partition on time
```

Add additional dimension for multi-dimensional partitioning:

```postgresql
SELECT * FROM add_dimension('conditions', by_hash('device', 4)); -- Add partitioning on device
```

## Indexing

Create a unique index:

```postgresql
CREATE UNIQUE INDEX idx_userid_deviceid_time
  ON conditions(device, time);
```

Create an optimized index for time-series queries:

```postgresql
CREATE INDEX ON conditions (device, time DESC);
```

B-Tree Index creation (note: can be resource-intensive):

```postgresql
CREATE UNIQUE INDEX ON data_histories (tag_unique_id, receive_time);
```

Reindex a specific chunk:

```postgresql
REINDEX TABLE "_timescaledb_internal._hyper_1_1_chunk";
```

Reindex multiple chunks with progress reporting (chunks newer than 1 day):

```postgresql
DO $$ 
DECLARE 
    chunk_record record;
    total_chunks integer;
    counter integer := 0;
BEGIN 
    SELECT COUNT(*) INTO total_chunks
    FROM show_chunks('data_histories', newer_than => INTERVAL '1 day');
    
    FOR chunk_record IN
        SELECT show_chunks AS chunk_name
        FROM show_chunks('data_histories', newer_than => INTERVAL '1 day')
    LOOP 
        counter := counter + 1;
        
        RAISE NOTICE 'Reindexing table % . Progress: % of %', chunk_record.chunk_name, counter, total_chunks; 
        EXECUTE format('REINDEX TABLE %s;', chunk_record.chunk_name);
    END LOOP; 
END $$;
```

Monitor index usage and size:

```postgresql
-- Check index sizes
SELECT pg_size_pretty(hypertable_index_size('data_histories_receive_time_idx')) AS index_size;
SELECT pg_size_pretty(hypertable_index_size('data_histories_tag_unique_id_receive_time_idx')) AS index_size;

-- Find unused or low-usage indexes
SELECT 
    s.schemaname,
    s.relname AS table_name,
    s.indexrelname AS index_name,
    pg_size_pretty(pg_relation_size(s.indexrelid)) AS index_size,
    s.idx_scan AS index_scans, -- Number of index scans since last reset
    i.indisunique AS is_unique,
    i.indisprimary AS is_primary
FROM 
    pg_stat_user_indexes s
JOIN 
    pg_index i ON s.indexrelid = i.indexrelid
WHERE 
    s.idx_scan = 0  -- index has never been used
    AND NOT i.indisprimary -- don't suggest dropping primary keys
    AND NOT i.indisunique -- don't suggest dropping unique constraints
ORDER BY 
    pg_relation_size(s.indexrelid) DESC;

-- Track index usage over time
SELECT relname, indexrelname, last_idx_scan, idx_scan
FROM pg_stat_user_indexes
ORDER BY idx_scan;

-- Reset indexes scan counter
SELECT pg_stat_reset();
```

## Compression

### Enable Compression

Enable compression on a table:

```postgresql
ALTER TABLE <table_name> SET (timescaledb.compress,
   timescaledb.compress_orderby = '<column_name> [ASC | DESC] [ NULLS { FIRST | LAST } ] [, ...]',
   timescaledb.compress_segmentby = '<column_name> [, ...]',
   timescaledb.compress_chunk_time_interval='interval'
);
```

Add a compression policy:

```postgresql
SELECT add_compression_policy('<table_name>', INTERVAL '1 days'); --> compress records every day
```

### Disable Compression

Disable compression (only works if no chunks are currently compressed):

```postgresql
ALTER TABLE '<table_name>' SET (timescaledb.compress = false);
```

Decompress all chunks:

```postgresql
SELECT
	decompress_chunk ( C, TRUE ) 
FROM
	show_chunks ( '<table_name>' ) C;
```

### Manual Compression

Compress all chunks older than 1 week:

```postgresql
SELECT
	compress_chunk ( i, if_not_compressed => TRUE ) 
FROM
	show_chunks ( '<table_name>', older_than => INTERVAL '1 week' ) i;
```

Compress a specific chunk by name:

```postgresql
SELECT compress_chunk( '_timescaledb_internal.<chunk_name>' );
```

Compress all chunks:

```postgresql
SELECT
	compress_chunk ( i, if_not_compressed => TRUE ) 
FROM
	show_chunks ( 'data_histories') i;
```

### Compression Policy Management

View current compression policies:

```postgresql
SELECT * FROM timescaledb_information.jobs WHERE proc_name='policy_compression';
```

Remove a compression policy:

```postgresql
SELECT remove_compression_policy('<table_name>');
```

## Columnstore

Enable columnstore on a table:

```postgresql
-- Remove existing compression policy if needed
SELECT remove_compression_policy('data_histories');

-- Enable columnstore
ALTER TABLE data_histories SET (
   timescaledb.enable_columnstore = true, 
   timescaledb.segmentby = 'tag_unique_id');
   
-- Add columnstore policy
CALL add_columnstore_policy(
   'data_histories',
   INTERVAL '3h',
   hypercore_use_access_method => true
);
```

Remove columnstore policy:

```postgresql
CALL remove_columnstore_policy('data_histories');
```

Monitor columnstore compression:

```postgresql
-- Watch compression changes
SELECT 
  pg_size_pretty(before_compression_total_bytes) as before,
  pg_size_pretty(after_compression_total_bytes) as after
FROM hypertable_compression_stats('data_histories');
```

## Chunk Management

List chunks older than a specific time:

```postgresql
SELECT
  *
FROM
  show_chunks ('data_histories', older_than => INTERVAL '24 hours');
```

View compression stats for chunks:

```postgresql
SELECT
	chunk_schema,
	chunk_name,
	compression_status,
	pg_size_pretty ( before_compression_total_bytes ) AS before_compression,
	pg_size_pretty ( after_compression_total_bytes ) AS after_compression 
FROM
	chunk_compression_stats ( '<table_name>' )
```

Get detailed chunk size information:

```postgresql
SELECT
	chunk_name,
	pg_size_pretty ( table_bytes ) AS table_bytes,
	pg_size_pretty ( index_bytes ) AS index_bytes,
	pg_size_pretty ( toast_bytes ) AS toast_bytes,
	pg_size_pretty ( total_bytes ) AS total_bytes 
FROM
	chunks_detailed_size ( '<table_name>' )
```

Get detailed information for a specific table with compression stats:

```postgresql
SELECT
  c.chunk_schema,
  d.chunk_name,
  c.compression_status,
  pg_size_pretty (d.table_bytes) AS table_bytes,
  pg_size_pretty (d.index_bytes) AS index_bytes,
  pg_size_pretty (d.toast_bytes) AS toast_bytes,
  pg_size_pretty (d.total_bytes) AS total_bytes,
  pg_size_pretty (c.before_compression_total_bytes) AS before_compression,
  pg_size_pretty (c.after_compression_total_bytes) AS after_compression
FROM
  chunks_detailed_size ('data_histories') d
  JOIN chunk_compression_stats ('data_histories') c ON d.chunk_name = c.chunk_name
ORDER BY chunk_name;
```

## Database Metrics

Get table sizes for all tables in the public schema:

```postgresql
SELECT TABLE_NAME,
  pg_size_pretty (pg_total_relation_size (quote_ident(TABLE_NAME)))
FROM
  information_schema.TABLES
WHERE
  table_schema = 'public'
ORDER BY
  2 DESC;
```

Get approximate row count for a table:

```postgresql
SELECT
  approximate_row_count AS "TotalCount"
FROM
  approximate_row_count ('data_histories');
```

Full approximate row count information:

```postgresql
SELECT
  *
FROM
  approximate_row_count ('data_histories');
```

## Performance Tuning

View memory configuration parameters:

```postgresql
SELECT name, setting, unit
FROM pg_settings
WHERE name IN (
  'shared_buffers',
  'work_mem',
  'maintenance_work_mem',
  'temp_buffers',
  'effective_cache_size',
  'max_connections'
);
```

Check database sizes:

```postgresql
SELECT
  pg_database.datname,
  pg_size_pretty(pg_database_size(pg_database.datname)) AS size
FROM
  pg_database;
```

Monitor active connections and queries:

```postgresql
SELECT
  datname,
  usename,
  application_name,
  client_addr,
  STATE,
  backend_start,
  query_start,
  wait_event_type,
  wait_event
FROM
  pg_stat_activity;
```

## Common Queries

Analyze a table for query optimization:

```postgresql
ANALYSE data_histories;
```

Explain a query execution plan:

```postgresql
EXPLAIN SELECT * FROM "data";
```

Change a table to unlogged mode (faster inserts, but unsafe for replication):

```postgresql
ALTER TABLE data_histories SET UNLOGGED;
```

## Materialized Views

Create a continuous materialized view for aggregation:

```postgresql
CREATE MATERIALIZED VIEW avg_temp_hourly
WITH (timescaledb.continuous) AS
SELECT time_bucket('1 hour', receive_time) AS bucket, tag_unique_id, value
FROM data_histories
GROUP BY bucket, tag_unique_id;
```
