BEGIN;
CREATE TEMP TABLE source_establishment_sen (
    urn integer NOT NULL,
    source_bucket integer,
    sen_code text,
    source_sen_name text,
    source_archived integer
) ON COMMIT DROP;
\copy source_establishment_sen FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM source_establishment_sen)
       OR EXISTS (SELECT 1 FROM source_establishment_sen WHERE urn <> __EXPECTED_URN__)
       OR NOT EXISTS (SELECT 1 FROM establishment.establishment WHERE urn = __EXPECTED_URN__) THEN
        RAISE EXCEPTION 'SEN fixture must identify the requested existing establishment';
    END IF;
    IF EXISTS (
        SELECT 1 FROM source_establishment_sen
        WHERE (sen_code IS NULL AND (source_bucket IS NOT NULL OR source_sen_name IS NOT NULL OR source_archived IS NOT NULL))
           OR (sen_code IS NOT NULL AND (source_bucket IS NULL OR source_bucket NOT BETWEEN 1 AND 4 OR source_sen_name IS NULL))
           OR source_archived NOT IN (0, 1)
    ) OR EXISTS (
        SELECT source_bucket, sen_code FROM source_establishment_sen
        GROUP BY source_bucket, sen_code HAVING count(*) > 1
    ) OR (EXISTS (SELECT 1 FROM source_establishment_sen WHERE sen_code IS NULL)
          AND (SELECT count(*) FROM source_establishment_sen) <> 1) THEN
        RAISE EXCEPTION 'Invalid or duplicate SEN source association, archive flag or missing lookup reference';
    END IF;
    IF EXISTS (
        SELECT 1 FROM source_establishment_sen AS src
        LEFT JOIN establishment.sen AS s ON s.code = src.sen_code
        WHERE src.sen_code IS NOT NULL AND src.sen_code<>'00'
          AND (src.source_archived IS NULL OR src.source_archived = 0)
          AND (s.sen_id IS NULL OR s.name IS DISTINCT FROM src.source_sen_name)
    ) THEN
        RAISE EXCEPTION 'Unsupported current SEN code or differing source label';
    END IF;
    IF EXISTS (
        SELECT 1 FROM source_establishment_sen
        WHERE source_bucket > 1 AND sen_code<>'00' AND (source_archived IS NULL OR source_archived = 0)
    ) THEN
        RAISE EXCEPTION 'Current SEN association in legacy bucket 2-4 requires a reviewed disposition';
    END IF;
END $$;

-- Serialise complete-set replays for this establishment.
SELECT establishment_id FROM establishment.establishment
WHERE urn = __EXPECTED_URN__ FOR UPDATE;

DELETE FROM establishment.establishment_sen AS link
USING establishment.establishment AS e
WHERE link.establishment_id = e.establishment_id AND e.urn = __EXPECTED_URN__
  AND NOT EXISTS (
      SELECT 1 FROM source_establishment_sen AS src
      JOIN establishment.sen AS s ON s.code = src.sen_code
      WHERE src.source_bucket = 1 AND src.sen_code<>'00' AND (src.source_archived IS NULL OR src.source_archived = 0)
        AND s.sen_id = link.sen_id
  );

INSERT INTO establishment.establishment_sen (establishment_id, sen_id)
SELECT e.establishment_id, s.sen_id
FROM source_establishment_sen AS src
JOIN establishment.establishment AS e ON e.urn = src.urn
JOIN establishment.sen AS s ON s.code = src.sen_code
WHERE src.source_bucket = 1 AND src.sen_code<>'00' AND (src.source_archived IS NULL OR src.source_archived = 0)
ON CONFLICT (establishment_id, sen_id) DO NOTHING;

DO $$
DECLARE run_id uuid; snapshot_id uuid;
BEGIN
    INSERT INTO migration.migration_run
        (run_type, source_system, source_database, source_snapshot_date,
         status, completed_at, transform_version, notes)
    SELECT 'establishment-sen', 'GIAS BAU', '__SOURCE_DATABASE__', current_date,
           'completed', now(), 'sen-current-v1',
           jsonb_build_object('urn', __EXPECTED_URN__,
             'accepted_associations', count(*) FILTER (WHERE source_bucket = 1 AND sen_code<>'00' AND (source_archived IS NULL OR source_archived = 0)),
             'excluded_not_applicable_associations',count(*) FILTER(WHERE sen_code='00'),
             'excluded_archived_associations', count(*) FILTER (WHERE source_archived = 1),
             'source_rows', jsonb_agg(to_jsonb(src) ORDER BY source_bucket, sen_code))::text
    FROM source_establishment_sen AS src
    RETURNING migration_run_id INTO run_id;
    INSERT INTO migration.source_snapshot
        (migration_run_id, source_system, source_database, snapshot_date, extract_name)
    VALUES (run_id, 'GIAS BAU', '__SOURCE_DATABASE__', current_date,
            'establishment-sen-' || __EXPECTED_URN__::text)
    RETURNING source_snapshot_id INTO snapshot_id;
    INSERT INTO migration.source_record
        (source_snapshot_id, source_table, source_key, source_urn, source_row_hash)
    SELECT snapshot_id,
           CASE WHEN source_bucket IS NULL THEN 'dbo.Establishment'
                ELSE 'dbo.EstablishmentToSen' || source_bucket::text END,
           urn::text || coalesce('|' || sen_code, ''), urn, md5(to_jsonb(src)::text)
    FROM source_establishment_sen AS src;
END $$;

SELECT __EXPECTED_URN__ AS urn,
       count(*) FILTER (WHERE source_bucket = 1 AND sen_code<>'00' AND (source_archived IS NULL OR source_archived = 0)) AS accepted_associations,
       count(*) FILTER (WHERE source_archived = 1) AS excluded_archived_associations
FROM source_establishment_sen;
DROP TABLE source_establishment_sen;
COMMIT;
