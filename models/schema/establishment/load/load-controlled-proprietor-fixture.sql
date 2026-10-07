-- Reviewed proprietor overlay. The fixed target UUID is a controlled fixture
-- allocation, not a source identifier and not a name-based matching rule.
BEGIN;
CREATE TEMP TABLE controlled_proprietor AS
SELECT '__CONTROLLED_PROPRIETOR_JSON__'::jsonb AS decision;
CREATE TEMP TABLE proprietor_local_context (
    urn integer, establishment_name text, establishment_type_code text,
    status_code text, proprietor_type_code text, proprietor_type text,
    additional_proprietor_rows integer
);
\copy proprietor_local_context FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

DO $$
DECLARE d jsonb; party_id uuid; run_id uuid;
BEGIN
    SELECT decision INTO STRICT d FROM controlled_proprietor;
    party_id := (d->>'legalEntityId')::uuid;
    run_id := NULLIF(current_setting('epr.migration_run_id',true),'')::uuid;
    IF run_id IS NULL OR NOT EXISTS (SELECT 1 FROM migration.migration_run
        WHERE migration_run_id=run_id AND status IN ('running','completed')) THEN
        RAISE EXCEPTION 'Controlled proprietor requires an active or completed migration run';
    END IF;
    IF NULLIF(btrim(d->>'reviewEvidence'),'') IS NULL THEN
        RAISE EXCEPTION 'Controlled proprietor requires an explicit accepted identity decision';
    END IF;
    IF (SELECT count(*) FROM proprietor_local_context) <> jsonb_array_length(d->'schools')
       OR (SELECT count(DISTINCT urn) FROM proprietor_local_context) <> jsonb_array_length(d->'schools')
       OR EXISTS (
        SELECT 1 FROM jsonb_to_recordset(d->'schools') AS s(urn integer,name text,"propsName" text)
        LEFT JOIN proprietor_local_context l USING (urn)
        LEFT JOIN establishment.establishment e USING (urn)
        WHERE l.urn IS NULL OR l.establishment_name IS DISTINCT FROM s.name
          OR l.establishment_type_code IS DISTINCT FROM '10' OR l.status_code IS DISTINCT FROM '1'
          OR e.establishment_type_id IS DISTINCT FROM 15 OR e.name IS DISTINCT FROM s.name
          OR NULLIF(btrim(s."propsName"),'') IS NULL
    ) THEN RAISE EXCEPTION 'Controlled proprietor endpoints differ from the accepted selection'; END IF;
    IF EXISTS (SELECT 1 FROM establishment.legal_entity
        WHERE (legal_entity_id=party_id AND name IS DISTINCT FROM d->>'name')
           OR (legal_entity_id<>party_id AND lower(btrim(name))=lower(btrim(d->>'name')))) THEN
        RAISE EXCEPTION 'Controlled proprietor identity collision; review required';
    END IF;
END $$;

INSERT INTO establishment.legal_entity (legal_entity_id,name)
SELECT (decision->>'legalEntityId')::uuid,decision->>'name' FROM controlled_proprietor
ON CONFLICT (legal_entity_id) DO NOTHING;

INSERT INTO establishment.establishment_responsibility
    (establishment_id,legal_entity_id,responsibility_type_id,is_current)
SELECT e.establishment_id,(c.decision->>'legalEntityId')::uuid,rt.responsibility_type_id,true
FROM controlled_proprietor c
CROSS JOIN jsonb_to_recordset(c.decision->'schools') AS s(urn integer)
JOIN establishment.establishment e USING (urn)
CROSS JOIN establishment.establishment_responsibility_type rt
WHERE rt.name='Proprietor'
ON CONFLICT DO NOTHING;

-- Both observations belong to the same rebuild run. External extract and
-- local screening have different source systems, databases and dates.
INSERT INTO migration.source_snapshot
    (migration_run_id,source_system,source_database,snapshot_date,extract_name)
SELECT r.migration_run_id,'GIAS public extract',NULL,(c.decision->>'snapshotDate')::date,
       c.decision->>'extractPath'
FROM controlled_proprietor c
JOIN migration.migration_run r ON r.migration_run_id=current_setting('epr.migration_run_id')::uuid
WHERE NOT EXISTS (SELECT 1 FROM migration.source_snapshot s
    WHERE s.migration_run_id=r.migration_run_id AND s.source_system='GIAS public extract'
      AND s.extract_name=c.decision->>'extractPath');

INSERT INTO migration.source_snapshot
    (migration_run_id,source_system,source_database,snapshot_date,extract_name)
SELECT r.migration_run_id,'GIAS BAU',r.source_database,r.source_snapshot_date,
       (c.decision->>'fixture') || '-local-proprietor-context'
FROM controlled_proprietor c
JOIN migration.migration_run r ON r.migration_run_id=current_setting('epr.migration_run_id')::uuid
WHERE NOT EXISTS (SELECT 1 FROM migration.source_snapshot s
    WHERE s.migration_run_id=r.migration_run_id AND s.source_system='GIAS BAU'
      AND s.extract_name=(c.decision->>'fixture') || '-local-proprietor-context');

CREATE TEMP TABLE proprietor_lineage AS
SELECT e.establishment_id,r.establishment_responsibility_id,l.*,
       c.decision,(j->>'PropsName') AS accepted_name
FROM controlled_proprietor c
CROSS JOIN LATERAL (
    SELECT jsonb_build_object('urn',x.urn,'PropsName',x."propsName") AS j
    FROM jsonb_to_recordset(c.decision->'schools') AS x(urn integer,"propsName" text)
) selected
JOIN proprietor_local_context l ON l.urn=(j->>'urn')::integer
JOIN establishment.establishment e USING (urn)
JOIN establishment.establishment_responsibility r ON r.establishment_id=e.establishment_id
   AND r.legal_entity_id=(c.decision->>'legalEntityId')::uuid
JOIN establishment.establishment_responsibility_type rt ON rt.responsibility_type_id=r.responsibility_type_id
WHERE rt.name='Proprietor' AND r.start_date IS NULL AND r.end_date IS NULL AND r.is_current;

INSERT INTO migration.source_record (source_snapshot_id,source_table,source_key,source_urn,source_row_hash)
SELECT s.source_snapshot_id,'Establishment extract PropsName',l.urn::text,l.urn,
       md5(l.urn::text || '|' || l.accepted_name)
FROM proprietor_lineage l
JOIN migration.source_snapshot s ON s.migration_run_id=current_setting('epr.migration_run_id')::uuid
    AND s.source_system='GIAS public extract' AND s.extract_name=l.decision->>'extractPath'
ON CONFLICT (source_snapshot_id,source_table,source_key) DO NOTHING;

INSERT INTO migration.source_record (source_snapshot_id,source_table,source_key,source_urn,source_row_hash)
SELECT s.source_snapshot_id,'dbo.IndependentSchools (context only)',l.urn::text,l.urn,
       md5(concat_ws('|',l.urn,l.proprietor_type_code,l.proprietor_type,l.additional_proprietor_rows))
FROM proprietor_lineage l
JOIN migration.source_snapshot s ON s.migration_run_id=current_setting('epr.migration_run_id')::uuid
    AND s.source_system='GIAS BAU'
    AND s.extract_name=(l.decision->>'fixture') || '-local-proprietor-context'
ON CONFLICT (source_snapshot_id,source_table,source_key) DO NOTHING;

INSERT INTO migration.identity_resolution
    (source_record_id,target_entity_type,target_entity_id,resolution_method,
     confidence,decision_status,decided_at,decided_by,rationale)
SELECT sr.source_record_id,'legal_entity',(l.decision->>'legalEntityId')::uuid,
       'controlled-reviewed-proprietor','accepted-fixture-assumption','accepted',now(),
       'T9 accepted fixture decision',l.decision->>'reviewEvidence'
FROM proprietor_lineage l
JOIN migration.source_record sr ON sr.source_urn=l.urn
JOIN migration.source_snapshot ss USING (source_snapshot_id)
WHERE ss.migration_run_id=current_setting('epr.migration_run_id')::uuid
  AND ss.source_system='GIAS public extract' AND ss.extract_name=l.decision->>'extractPath'
  AND NOT EXISTS (SELECT 1 FROM migration.identity_resolution ir
      WHERE ir.source_record_id=sr.source_record_id AND ir.target_entity_type='legal_entity'
        AND ir.target_entity_id=(l.decision->>'legalEntityId')::uuid);

INSERT INTO migration.establishment_responsibility_evidence
    (establishment_responsibility_id,source_record_id,first_observed_date,review_status,notes)
SELECT l.establishment_responsibility_id,sr.source_record_id,
       CASE WHEN ss.source_system='GIAS public extract' THEN ss.snapshot_date ELSE NULL END,
       'accepted',
       CASE WHEN ss.source_system='GIAS public extract' THEN
         'Controlled accepted PropsName=' || l.accepted_name || '; ' || (l.decision->>'reviewEvidence') ||
         ' Responsibility dates unknown; legal form unverified; ownership not asserted.'
       ELSE
         'Local context only: proprietorType_code=' || coalesce(l.proprietor_type_code,'NULL') ||
         '; proprietor_type=' || coalesce(l.proprietor_type,'NULL') ||
         '; additional_proprietor_rows=' || l.additional_proprietor_rows ||
         '. Obfuscated local proprietor identity is not resolved to Acorn; additional rows not imported.'
       END
FROM proprietor_lineage l
JOIN migration.source_record sr ON sr.source_urn=l.urn
JOIN migration.source_snapshot ss USING (source_snapshot_id)
WHERE ss.migration_run_id=current_setting('epr.migration_run_id')::uuid
  AND ((ss.source_system='GIAS public extract' AND ss.extract_name=l.decision->>'extractPath')
    OR (ss.source_system='GIAS BAU' AND ss.extract_name=(l.decision->>'fixture') || '-local-proprietor-context'))
  AND NOT EXISTS (SELECT 1 FROM migration.establishment_responsibility_evidence ev
      WHERE ev.establishment_responsibility_id=l.establishment_responsibility_id
        AND ev.source_record_id=sr.source_record_id);

DO $$ BEGIN
    IF (SELECT count(*) FROM proprietor_lineage) <>
       (SELECT jsonb_array_length(decision->'schools') FROM controlled_proprietor) THEN
        RAISE EXCEPTION 'Controlled proprietor did not retain all current undated responsibilities';
    END IF;
END $$;
COMMIT;
