-- Template. Generate the executable seed from the evidence-checked JSON mapping.
-- Mapping SHA256: __MAPPING_SHA256__
BEGIN;
CREATE TEMP TABLE council_mapping_document ON COMMIT DROP AS
SELECT '__MAPPING_JSON__'::jsonb AS document;

CREATE TEMP TABLE council_seed_entities ON COMMIT DROP AS
SELECT c.* FROM council_mapping_document d,
jsonb_to_recordset(d.document->'councils') AS c(
    "legalEntityId" uuid, name text, "legalEntityTypeId" integer,
    "incorporationDate" date, "dissolutionDate" date, "evidenceUrls" jsonb);

CREATE TEMP TABLE council_seed_periods ON COMMIT DROP AS
SELECT (a->>'areaCode')::integer AS area_code, p.*
FROM council_mapping_document d,
LATERAL jsonb_array_elements(d.document->'areas') a,
LATERAL jsonb_to_recordset(a->'periods') AS p(
    "periodId" uuid, "councilId" uuid, "startDate" date, "endDate" date, "isCurrent" boolean)
WHERE a->>'reviewStatus' = 'evidence_checked';

DO $$
BEGIN
    IF (SELECT (document->>'backfillComplete')::boolean FROM council_mapping_document)
       AND EXISTS (SELECT 1 FROM council_mapping_document d,
                   LATERAL jsonb_array_elements(d.document->'areas') a
                   WHERE a->>'reviewStatus' IS DISTINCT FROM 'evidence_checked'
                      OR coalesce(jsonb_array_length(a->'periods'),0)=0)
    THEN RAISE EXCEPTION 'Completed council backfill contains unresolved areas'; END IF;

    IF (SELECT (document->>'schemaVersion')::integer FROM council_mapping_document) IS DISTINCT FROM 1
       OR EXISTS (SELECT 1 FROM council_seed_entities WHERE "legalEntityTypeId" IS DISTINCT FROM 9
                  OR "legalEntityId" IS NULL OR nullif(btrim(name),'') IS NULL
                  OR coalesce(jsonb_array_length("evidenceUrls"),0) = 0)
       OR EXISTS (SELECT "legalEntityId" FROM council_seed_entities GROUP BY 1 HAVING count(*) > 1)
       OR EXISTS (SELECT "periodId" FROM council_seed_periods GROUP BY 1 HAVING count(*) > 1)
       OR EXISTS (SELECT 1 FROM council_seed_periods p LEFT JOIN council_seed_entities c
                  ON c."legalEntityId"=p."councilId" WHERE c."legalEntityId" IS NULL)
    THEN RAISE EXCEPTION 'Invalid council mapping identities, forms or evidence'; END IF;

    IF EXISTS (
        SELECT 1 FROM council_mapping_document d, LATERAL jsonb_array_elements(d.document->'areas') a
        LEFT JOIN establishment.local_authority_area t ON t.code=(a->>'areaCode')::integer
        WHERE t.code IS NULL OR t.name IS DISTINCT FROM a->>'areaName'
           OR a->>'reviewStatus' NOT IN ('evidence_checked','pending')
           OR (a->>'reviewStatus'='pending' AND jsonb_array_length(a->'periods')<>0)
           OR (a->>'reviewStatus'='evidence_checked' AND jsonb_array_length(a->'periods')=0)
    ) OR (SELECT count(*) FROM establishment.local_authority_area) <>
         (SELECT jsonb_array_length(document->'areas') FROM council_mapping_document) +
         (SELECT count(DISTINCT l.entity_id) FROM migration.council_reorganisation_lineage l
          JOIN migration.council_reorganisation e USING(event_id)
          WHERE e.status='applied' AND l.entity_kind='local_authority_area' AND l.action='created')
       OR (SELECT count(DISTINCT (a->>'areaCode')::integer)
           FROM council_mapping_document d,LATERAL jsonb_array_elements(d.document->'areas') a) <>
          (SELECT jsonb_array_length(document->'areas') FROM council_mapping_document)
    THEN RAISE EXCEPTION 'Council mapping area scope or labels changed; source review required'; END IF;

    IF EXISTS (
        SELECT 1 FROM council_seed_entities c JOIN establishment.legal_entity t
        ON t.legal_entity_id=c."legalEntityId"
        WHERE t.name IS DISTINCT FROM c.name OR t.legal_entity_type_id IS DISTINCT FROM 9
           OR t.incorporation_date IS DISTINCT FROM c."incorporationDate"
           OR t.dissolution_date IS DISTINCT FROM c."dissolutionDate"
    ) OR EXISTS (
        SELECT 1 FROM council_seed_entities c JOIN establishment.legal_entity t
        ON lower(btrim(t.name))=lower(btrim(c.name)) AND t.legal_entity_id<>c."legalEntityId"
    ) THEN RAISE EXCEPTION 'Council identity collision or changed decision; review required'; END IF;

    IF EXISTS (
        SELECT 1 FROM council_seed_periods p JOIN establishment.local_authority_area_council_period t
        ON t.local_authority_area_council_period_id=p."periodId"
        JOIN establishment.local_authority_area a USING(local_authority_area_id)
        WHERE (a.code IS DISTINCT FROM p.area_code OR t.legal_entity_id IS DISTINCT FROM p."councilId"
           OR t.start_date IS DISTINCT FROM p."startDate" OR t.end_date IS DISTINCT FROM p."endDate"
           OR t.is_current IS DISTINCT FROM p."isCurrent") AND NOT EXISTS(
               SELECT 1 FROM migration.council_reorganisation_lineage l JOIN migration.council_reorganisation e USING(event_id)
               WHERE e.status='applied' AND l.entity_kind='council_period' AND l.entity_id=p."periodId"
                 AND a.code=p.area_code AND t.legal_entity_id=p."councilId"
                 AND l.action='changed' AND (l.before_row->>'local_authority_area_id')::uuid=t.local_authority_area_id
                 AND (l.before_row->>'legal_entity_id')::uuid=p."councilId"
                 AND (l.before_row->>'start_date')::date IS NOT DISTINCT FROM p."startDate"
                 AND (l.before_row->>'end_date')::date IS NOT DISTINCT FROM p."endDate"
                 AND (l.before_row->>'is_current')::boolean=p."isCurrent")
    ) THEN RAISE EXCEPTION 'Council period changed; review required'; END IF;
END $$;

INSERT INTO establishment.legal_entity(legal_entity_id,name,legal_entity_type_id,incorporation_date,dissolution_date)
SELECT "legalEntityId",name,9,"incorporationDate","dissolutionDate" FROM council_seed_entities
ON CONFLICT (legal_entity_id) DO NOTHING;

INSERT INTO establishment.local_authority_area_council_period
    (local_authority_area_council_period_id,local_authority_area_id,legal_entity_id,start_date,end_date,is_current)
SELECT p."periodId",a.local_authority_area_id,p."councilId",p."startDate",p."endDate",p."isCurrent"
FROM council_seed_periods p JOIN establishment.local_authority_area a ON a.code=p.area_code
ON CONFLICT (local_authority_area_council_period_id) DO NOTHING;
COMMIT;
