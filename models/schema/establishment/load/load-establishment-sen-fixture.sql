BEGIN;
SET LOCAL synchronous_commit = off;
CREATE TEMP TABLE source_establishment_sen (
    urn integer NOT NULL,
    source_bucket integer,
    sen_code text,
    source_sen_name text,
    source_archived integer
) ON COMMIT DROP;
\copy source_establishment_sen FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')
CREATE INDEX ON source_establishment_sen (urn);
ANALYZE source_establishment_sen;
CREATE TEMP TABLE expected_sen_owners ON COMMIT DROP AS
SELECT urn FROM establishment.establishment
WHERE __EXPECTED_URN__ IS NULL OR urn = __EXPECTED_URN__;
CREATE UNIQUE INDEX ON expected_sen_owners (urn);

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM source_establishment_sen)
       OR EXISTS (SELECT 1 FROM source_establishment_sen s WHERE NOT EXISTS (SELECT 1 FROM expected_sen_owners e WHERE e.urn=s.urn))
       OR EXISTS (SELECT 1 FROM expected_sen_owners e WHERE NOT EXISTS (SELECT 1 FROM source_establishment_sen s WHERE s.urn=e.urn)) THEN
        RAISE EXCEPTION 'SEN fixture must identify the requested existing establishment';
    END IF;
    IF EXISTS (
        SELECT 1 FROM source_establishment_sen
        WHERE (sen_code IS NULL AND (source_bucket IS NOT NULL OR source_sen_name IS NOT NULL OR source_archived IS NOT NULL))
           OR (sen_code IS NOT NULL AND (source_bucket IS NULL OR source_bucket NOT BETWEEN 1 AND 4 OR source_sen_name IS NULL))
           OR source_archived NOT IN (0, 1)
    ) OR EXISTS (
        SELECT urn, source_bucket, sen_code FROM source_establishment_sen
        GROUP BY urn, source_bucket, sen_code HAVING count(*) > 1
    ) OR EXISTS (SELECT urn FROM source_establishment_sen GROUP BY urn
                 HAVING bool_or(sen_code IS NULL) AND count(*) <> 1) THEN
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
DO $$ BEGIN
    PERFORM establishment_id FROM establishment.establishment
    WHERE urn IN (SELECT urn FROM expected_sen_owners) ORDER BY urn FOR UPDATE;
END $$;

DELETE FROM establishment.establishment_sen AS link
USING establishment.establishment AS e
WHERE link.establishment_id = e.establishment_id AND e.urn IN (SELECT urn FROM expected_sen_owners)
  AND NOT EXISTS (
      SELECT 1 FROM source_establishment_sen AS src
      JOIN establishment.sen AS s ON s.code = src.sen_code
      WHERE src.source_bucket = 1 AND src.sen_code<>'00' AND (src.source_archived IS NULL OR src.source_archived = 0)
        AND src.urn = e.urn AND s.sen_id = link.sen_id
  );

INSERT INTO establishment.establishment_sen (establishment_id, sen_id)
SELECT e.establishment_id, s.sen_id
FROM source_establishment_sen AS src
JOIN establishment.establishment AS e ON e.urn = src.urn
JOIN establishment.sen AS s ON s.code = src.sen_code
WHERE src.source_bucket = 1 AND src.sen_code<>'00' AND (src.source_archived IS NULL OR src.source_archived = 0)
ON CONFLICT (establishment_id, sen_id) DO NOTHING;

-- Allocate per-owner evidence IDs once, then insert all provenance in sets.
CREATE TEMP TABLE sen_evidence_context ON COMMIT DROP AS
SELECT urn, gen_random_uuid() AS run_id, gen_random_uuid() AS snapshot_id
FROM expected_sen_owners;
CREATE UNIQUE INDEX ON sen_evidence_context (urn);
INSERT INTO migration.migration_run
        (migration_run_id,
         run_type, source_system, source_database, source_snapshot_date,
         status, completed_at, transform_version, notes)
    SELECT context.run_id, 'establishment-sen', 'GIAS BAU', '__SOURCE_DATABASE__', current_date,
           'completed', now(), 'sen-current-v1',
           jsonb_build_object('urn', src.urn,
             'accepted_associations', count(*) FILTER (WHERE source_bucket = 1 AND sen_code<>'00' AND (source_archived IS NULL OR source_archived = 0)),
             'excluded_not_applicable_associations',count(*) FILTER(WHERE sen_code='00'),
             'excluded_archived_associations', count(*) FILTER (WHERE source_archived = 1),
             'excluded_legacy_bucket_associations', count(*) FILTER (WHERE source_bucket>1 AND sen_code<>'00' AND (source_archived IS NULL OR source_archived=0)),
             'source_rows', jsonb_agg(to_jsonb(src) ORDER BY source_bucket, sen_code))::text
    FROM source_establishment_sen AS src JOIN sen_evidence_context context USING (urn)
    GROUP BY src.urn, context.run_id;
    INSERT INTO migration.source_snapshot
        (source_snapshot_id, migration_run_id, source_system, source_database, snapshot_date, extract_name)
    SELECT snapshot_id, run_id, 'GIAS BAU', '__SOURCE_DATABASE__', current_date,
            'establishment-sen-' || urn::text FROM sen_evidence_context;
    INSERT INTO migration.source_record
        (source_snapshot_id, source_table, source_key, source_urn, source_row_hash)
    SELECT context.snapshot_id,
           CASE WHEN source_bucket IS NULL THEN 'dbo.Establishment'
                ELSE 'dbo.EstablishmentToSen' || source_bucket::text END,
           src.urn::text || coalesce('|' || sen_code, ''), src.urn, md5(to_jsonb(src)::text)
    FROM source_establishment_sen AS src JOIN sen_evidence_context context USING (urn);

SELECT count(DISTINCT urn) AS establishments,
       count(*) FILTER (WHERE source_bucket = 1 AND sen_code<>'00' AND (source_archived IS NULL OR source_archived = 0)) AS accepted_associations,
       count(*) FILTER (WHERE source_archived = 1) AS excluded_archived_associations,
       count(*) FILTER (WHERE source_bucket>1 AND sen_code<>'00' AND (source_archived IS NULL OR source_archived=0)) AS excluded_legacy_bucket_associations
FROM source_establishment_sen;
DROP TABLE source_establishment_sen;
DROP TABLE expected_sen_owners;
DROP TABLE sen_evidence_context;
COMMIT;
