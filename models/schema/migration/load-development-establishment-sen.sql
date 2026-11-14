BEGIN;
CREATE TEMP TABLE source_development_sen (
    urn integer NOT NULL,
    source_bucket integer,
    sen_code text,
    source_sen_name text,
    source_archived integer
) ON COMMIT DROP;
\copy source_development_sen FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')
DELETE FROM source_development_sen s WHERE NOT EXISTS (
    SELECT 1 FROM establishment.establishment e WHERE e.urn=s.urn);
ANALYZE source_development_sen;

INSERT INTO migration.relationship_load_error (migration_run_id, urn, relationship_kind, error_message, source_row)
SELECT '__RUN_ID__', src.urn, 'sen',
       CASE WHEN src.source_bucket<>1 THEN 'Ignored legacy SEN association bucket'
            WHEN src.source_archived NOT IN (0,1) THEN 'Ignored SEN association with invalid archive flag'
            WHEN src.sen_code IS NULL THEN 'Ignored malformed SEN association'
            WHEN s.sen_id IS NULL OR s.name IS DISTINCT FROM src.source_sen_name THEN 'Ignored unsupported or changed SEN association'
       END,
       to_jsonb(src)
FROM source_development_sen src
LEFT JOIN establishment.sen s ON s.code=src.sen_code
WHERE src.source_bucket<>1 OR src.source_archived NOT IN (0,1)
   OR (src.sen_code IS NULL AND (src.source_bucket IS NOT NULL OR src.source_sen_name IS NOT NULL OR src.source_archived IS NOT NULL))
   OR (src.sen_code<>'00' AND (s.sen_id IS NULL OR s.name IS DISTINCT FROM src.source_sen_name));

INSERT INTO establishment.establishment_sen (establishment_id, sen_id)
SELECT e.establishment_id, s.sen_id
FROM source_development_sen src
JOIN establishment.establishment e ON e.urn=src.urn
JOIN establishment.sen s ON s.code=src.sen_code AND s.name=src.source_sen_name
WHERE src.source_bucket=1 AND (src.source_archived IS NULL OR src.source_archived=0)
  AND src.sen_code<>'00'
ON CONFLICT (establishment_id, sen_id) DO NOTHING;
UPDATE migration.migration_run SET notes=(coalesce(notes::jsonb,'{}') || jsonb_build_object('sen',
    jsonb_build_object('source_rows',(SELECT count(*) FROM source_development_sen),
        'associations',(SELECT count(*) FROM establishment.establishment_sen),
        'skipped',(SELECT count(*) FROM migration.relationship_load_error WHERE migration_run_id='__RUN_ID__' AND relationship_kind='sen'))))::text
WHERE migration_run_id='__RUN_ID__';
COMMIT;
