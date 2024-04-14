# Timescale DB

Create table :

```postgresql
CREATE TABLE conditions (
   time        TIMESTAMPTZ       NOT NULL,
   location    TEXT              NOT NULL,
   device      TEXT              NOT NULL,
   temperature DOUBLE PRECISION  NULL,
   humidity    DOUBLE PRECISION  NULL
);
```

Create hypertable:

```postgresql
SELECT create_hypertable('<table name>', by_range('<column name>', chunk_time_interval));
```

```postgresql
SELECT create_hypertable('conditions', by_range('time', INTERVAL '1 day'));
SELECT create_hypertable('conditions', by_range('time', INTERVAL '24 hours'));
```



## Partitioning

```postgresql
SELECT create_hypertable('conditions', by_range('time', INTERVAL '1 day')); -- Partition on time
SELECT * FROM add_dimension('conditions', by_hash('device', 4)); -- Add partitionaing on device
```



## Indexing

Unique indexes :

```postgresql
CREATE UNIQUE INDEX idx_userid_deviceid_time
  ON conditions(device, time);
```



A good rule of thumb with indexes is to think in layers. Start by choosing the columns that you typically want to run equality operators on, such as `device = 'device01'`. Then finish by choosing columns you want to use range operators on, such as `time > 0930`.

```postgresql
CREATE INDEX ON conditions (device, time DESC);
```

When you create a hypertable with the [`create_hypertable`](https://docs.timescale.com/api/latest/hypertable/create_hypertable/) command, a time index is created on your data.

If you do not want to create these default indexes, you can set `create_default_indexes` to `false` when you run the `create_hypertable` command. For example:

```postgresql
SELECT create_hypertable('conditions', by_range('time'))
  CREATE_DEFAULT_INDEXES false;
```


### [Reindex hypertables to fix large indexes](https://docs.timescale.com/use-timescale/latest/schema-management/troubleshooting/#reindex-hypertables-to-fix-large-indexes)

```postgresql
reindex table _timescaledb_internal._hyper_1_1_chunk
```



## Compression

### Enable Compression

```postgresql
ALTER TABLE <table_name> SET (timescaledb.compress,
   timescaledb.compress_orderby = '<column_name> [ASC | DESC] [ NULLS { FIRST | LAST } ] [, ...]',
   timescaledb.compress_segmentby = '<column_name> [, ...]',
   timescaledb.compress_chunk_time_interval='interval'
);
```



### Disable Compression

Decompress all chunks :

> When compressing your data, you can reduce the amount of storage space for your Timescale instance. But you should always leave some additional storage capacity. This gives you the flexibility to decompress chunks when necessary, for actions such as bulk inserts.

```postgresql
SELECT decompress_chunk(c, true) FROM show_chunks('<table_name>') c;
```

Disable compression :

```postgresql
ALTER TABLE '<table_name>' SET (timescaledb.compress = false);
```



### Manually Compression

Compress all chunks

```postgresql
SELECT compress_chunk(i, if_not_compressed=>true) from show_chunks('<table_name>',older_than=> INTERVAL '1 week') i;
```

Compress by chunk name :

```postgresql
SELECT compress_chunk( '_timescaledb_internal.<chunk_name>');
```



Get compression status :

```postgresql
SELECT *FROM chunk_compression_stats('<table_name>');
```



### Check Chunks size

```postgresql
SELECT chunk_schema,
	chunk_name,
	compression_status,
	pg_size_pretty(before_compression_total_bytes) AS before_compression,
	pg_size_pretty(after_compression_total_bytes) AS after_compression
  FROM chunk_compression_stats('<table name>')
```



## Queries

### Explain  a query

```postgresql
EXPLAIN SELECT * FROM "data";
```

