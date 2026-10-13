CREATE TEMP TABLE reviewed_fixture ON COMMIT DROP AS
SELECT '__REVIEWED_FIXTURE_JSON__'::text AS raw_json,
       '__REVIEWED_FIXTURE_SHA256__'::text AS expected_sha256;
CREATE TEMP TABLE proprietor_local_context(
 urn integer,establishment_name text,type_code text,status_code text,
 open_date date,close_date date,ukprn text,local_authority_code text,
 proprietorType_code text,additional_proprietor_rows integer
) ON COMMIT DROP;
\copy proprietor_local_context FROM '__FIXTURE_PATH__' WITH(FORMAT csv,HEADER true,DELIMITER '|',NULL 'NULL')
DO $$
DECLARE
 d jsonb; party uuid; school uuid; responsibility uuid; run_id uuid;
 snapshot_id uuid; record_id uuid; context_snapshot uuid; context_record uuid; case_label text;
BEGIN
 SELECT raw_json::jsonb INTO d FROM reviewed_fixture
 WHERE encode(digest(raw_json,'sha256'),'hex')=expected_sha256;
 case_label:=COALESCE(d->>'fixture','Reviewed proprietor');
 IF d IS NULL OR d->>'reviewStatus' IS DISTINCT FROM 'accepted'
    OR d->>'mode' IS DISTINCT FROM 'shared-existing-proprietor'
    OR NULLIF(btrim(d->>'reviewEvidence'),'') IS NULL THEN
    RAISE EXCEPTION '% approved decision changed; manual review required',case_label;
 END IF;
 IF (SELECT count(*) FROM proprietor_local_context)<>jsonb_array_length(d->'expectedLocalContext')
    OR EXISTS(SELECT 1 FROM proprietor_local_context c WHERE NOT EXISTS(
       SELECT 1 FROM jsonb_populate_recordset(NULL::pg_temp.proprietor_local_context,d->'expectedLocalContext') e
       WHERE to_jsonb(c)=to_jsonb(e))) THEN
    RAISE EXCEPTION '% raw local context changed; manual review required',case_label;
 END IF;
 run_id:=current_setting('epr.migration_run_id')::uuid;
 IF NOT EXISTS(SELECT 1 FROM migration.migration_run WHERE migration_run_id=run_id AND run_type=d->>'runType' AND status='running')
 THEN RAISE EXCEPTION '% approved mapping requires its running additive migration',case_label; END IF;
 SELECT i.legal_entity_id INTO STRICT party FROM establishment.organisation_identifier i
 JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
 WHERE t.name='Companies House number' AND i.value=d->>'companyNumber' AND i.is_current;
 IF NOT EXISTS(SELECT 1 FROM establishment.organisation_identifier i
   JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
   WHERE i.legal_entity_id=party AND t.name='UKPRN' AND i.value=d->>'organisationUkprn' AND i.is_current)
 THEN RAISE EXCEPTION '% company and organisation UKPRN ownership differ; manual review required',case_label; END IF;
 SELECT e.establishment_id INTO STRICT school FROM establishment.establishment e
 JOIN establishment.establishment_lifecycle l USING(establishment_id)
 JOIN establishment.establishment_status s USING(establishment_status_id)
 JOIN establishment.establishment_geography geo USING(establishment_id)
 JOIN establishment.local_authority la USING(local_authority_id)
 WHERE e.urn=(d->'school'->>'urn')::integer
   AND ROW(e.name,e.ukprn,e.establishment_number,e.establishment_type_id,e.education_phase_id,
           l.open_date,l.close_date,s.name,la.code::text)
       IS NOT DISTINCT FROM ROW(d->'school'->>'name',(d->'school'->>'ukprn')::numeric,
           (d->'school'->>'establishmentNumber')::integer,(d->'school'->>'establishmentTypeId')::integer,
           (d->'school'->>'educationPhaseId')::integer,(d->'school'->>'openDate')::date,
           (d->'school'->>'closeDate')::date,d->>'targetSchoolStatus',d->'school'->>'localAuthorityCode');
 INSERT INTO establishment.establishment_responsibility(establishment_id,legal_entity_id,responsibility_type_id,is_current)
   SELECT school,party,responsibility_type_id,true FROM establishment.establishment_responsibility_type WHERE name='Proprietor'
   ON CONFLICT DO NOTHING;
 SELECT r.establishment_responsibility_id INTO STRICT responsibility FROM establishment.establishment_responsibility r
 JOIN establishment.establishment_responsibility_type t USING(responsibility_type_id)
 WHERE r.establishment_id=school AND r.legal_entity_id=party AND t.name='Proprietor'
   AND r.start_date IS NULL AND r.end_date IS NULL AND r.is_current;
 INSERT INTO migration.source_snapshot(migration_run_id,source_system,snapshot_date,extract_name)
   SELECT run_id,'GIAS public extract',(d->>'snapshotDate')::date,d->>'extractPath'
   WHERE NOT EXISTS(SELECT 1 FROM migration.source_snapshot WHERE migration_run_id=run_id
     AND source_system='GIAS public extract' AND extract_name=d->>'extractPath');
 SELECT source_snapshot_id INTO STRICT snapshot_id FROM migration.source_snapshot WHERE migration_run_id=run_id
   AND source_system='GIAS public extract' AND extract_name=d->>'extractPath';
 INSERT INTO migration.source_snapshot(migration_run_id,source_system,source_database,snapshot_date,extract_name)
   SELECT run_id,'GIAS BAU',d->>'sourceDatabase',(d->>'contextObservationDate')::date,d->>'contextExtractName'
   WHERE NOT EXISTS(SELECT 1 FROM migration.source_snapshot WHERE migration_run_id=run_id AND extract_name=d->>'contextExtractName');
 SELECT source_snapshot_id INTO STRICT context_snapshot FROM migration.source_snapshot
   WHERE migration_run_id=run_id AND extract_name=d->>'contextExtractName';
 INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_urn,source_row_hash)
   VALUES(snapshot_id,d->>'approvedSourceTable',d->'school'->>'urn',(d->'school'->>'urn')::integer,md5(d::text))
   ON CONFLICT DO NOTHING;
 SELECT source_record_id INTO STRICT record_id FROM migration.source_record WHERE source_snapshot_id=snapshot_id AND source_key=d->'school'->>'urn';
 INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_urn,source_row_hash)
   SELECT context_snapshot,d->>'contextSourceTable',d->'school'->>'urn',(d->'school'->>'urn')::integer,md5(to_jsonb(c)::text)
   FROM proprietor_local_context c ON CONFLICT DO NOTHING;
 SELECT source_record_id INTO STRICT context_record FROM migration.source_record WHERE source_snapshot_id=context_snapshot AND source_key=d->'school'->>'urn';
 INSERT INTO migration.identity_resolution(source_record_id,target_entity_type,target_entity_id,resolution_method,confidence,decision_status,decided_at,decided_by,rationale)
   SELECT record_id,'establishment',school,'accepted-controlled-establishment','accepted-fixture-assumption','accepted',now(),d->>'approvedBy',d::text
   WHERE NOT EXISTS(SELECT 1 FROM migration.identity_resolution WHERE source_record_id=record_id AND target_entity_type='establishment');
 INSERT INTO migration.identity_resolution(source_record_id,target_entity_type,target_entity_id,resolution_method,confidence,decision_status,decided_at,decided_by,rationale)
   SELECT record_id,'legal_entity',party,'accepted-shared-proprietor','assumed','accepted',now(),d->>'approvedBy',d->>'reviewEvidence'
   WHERE NOT EXISTS(SELECT 1 FROM migration.identity_resolution WHERE source_record_id=record_id AND target_entity_type='legal_entity');
 INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,first_observed_date,review_status,notes)
   SELECT responsibility,record_id,(d->>'snapshotDate')::date,'accepted',
     case_label||' approved PropsName='||(d->>'propsName')||'; ' || (d->>'reviewEvidence') || ' Responsibility dates unknown; no ownership or Proprietor party role asserted.'
   WHERE NOT EXISTS(SELECT 1 FROM migration.establishment_responsibility_evidence WHERE establishment_responsibility_id=responsibility AND source_record_id=record_id);
 INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,review_status,notes)
   SELECT responsibility,context_record,'accepted',case_label||' rejected local values retained as context only: ' || to_jsonb(c)::text
   FROM proprietor_local_context c
   WHERE NOT EXISTS(SELECT 1 FROM migration.establishment_responsibility_evidence WHERE establishment_responsibility_id=responsibility AND source_record_id=context_record);
END $$;
