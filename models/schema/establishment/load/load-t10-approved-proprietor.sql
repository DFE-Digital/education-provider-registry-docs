-- Case-specific approved decision. Reuse the resolved Outwood company, never
-- allocate another party by proprietor name or create a Proprietor party role.
CREATE TEMP TABLE t10_decision AS SELECT '__T10_DECISION_JSON__'::jsonb decision;
CREATE TEMP TABLE t10_local_context(
 urn integer,establishment_name text,type_code text,status_code text,
 open_date date,close_date date,ukprn text,local_authority_code text,
 proprietorType_code text,additional_proprietor_rows integer
) ON COMMIT DROP;
\copy t10_local_context FROM '__FIXTURE_PATH__' WITH(FORMAT csv,HEADER true,DELIMITER '|',NULL 'NULL')
DO $$
DECLARE
 d jsonb; party uuid; school uuid; responsibility uuid; run_id uuid;
 snapshot_id uuid; record_id uuid; context_snapshot uuid; context_record uuid;
BEGIN
 SELECT decision INTO STRICT d FROM t10_decision;
 IF d->>'fixture' IS DISTINCT FROM 'T10' OR d->>'snapshotDate' IS DISTINCT FROM '2026-06-16'
   OR d->>'approvedOn' IS DISTINCT FROM '2026-10-09' OR d->>'companyNumber' IS DISTINCT FROM '06995649'
   OR d->>'organisationUkprn' IS DISTINCT FROM '10058273'
   OR d->>'propsName' IS DISTINCT FROM 'Outwood Grange Academies Trust'
   OR d->'school' IS DISTINCT FROM '{"urn":148341,"name":"Outwood Alternative Provision Eston","establishmentNumber":6003,"establishmentTypeId":17,"educationPhaseId":8,"statusCode":"1","openDate":"2021-02-18","closeDate":null,"ukprn":10092329,"localAuthorityCode":"807"}'::jsonb
   OR COALESCE(d->>'reviewEvidence','') NOT LIKE 'T10 user-approved controlled establishment and shared-party assertion%'
 THEN RAISE EXCEPTION 'T10 approved decision changed; manual review required'; END IF;
 IF (SELECT count(*) FROM t10_local_context)<>1 OR NOT EXISTS(
   SELECT 1 FROM t10_local_context WHERE urn=148341 AND establishment_name='Outwood Alternative Provision Eston'
     AND type_code='11' AND status_code='8' AND open_date=DATE '2018-11-10' AND close_date=DATE '2018-11-10'
     AND ukprn IS NULL AND local_authority_code='865' AND proprietorType_code='03' AND additional_proprietor_rows=0)
 THEN RAISE EXCEPTION 'T10 raw local context changed'; END IF;
 run_id:=current_setting('epr.migration_run_id')::uuid;
 IF NOT EXISTS(SELECT 1 FROM migration.migration_run WHERE migration_run_id=run_id AND run_type='t10-additive' AND status='running')
 THEN RAISE EXCEPTION 'T10 approved mapping requires its running additive migration'; END IF;
 SELECT i.legal_entity_id INTO STRICT party FROM establishment.organisation_identifier i
 JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
 WHERE t.name='Companies House number' AND i.value='06995649' AND i.is_current;
 IF NOT EXISTS(SELECT 1 FROM establishment.organisation_identifier i
   JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
   WHERE i.legal_entity_id=party AND t.name='UKPRN' AND i.value='10058273' AND i.is_current)
 THEN RAISE EXCEPTION 'T10 company and organisation UKPRN ownership differ'; END IF;
 SELECT e.establishment_id INTO STRICT school FROM establishment.establishment e
 JOIN establishment.establishment_lifecycle l USING(establishment_id)
 JOIN establishment.establishment_status s USING(establishment_status_id)
 JOIN establishment.establishment_geography geo USING(establishment_id)
 JOIN establishment.local_authority la USING(local_authority_id)
 WHERE e.urn=148341 AND e.name='Outwood Alternative Provision Eston' AND e.ukprn=10092329
   AND e.establishment_number=6003 AND e.establishment_type_id=17 AND e.education_phase_id=8
   AND l.open_date=DATE '2021-02-18' AND l.close_date IS NULL AND s.name='Open' AND la.code=807;
 INSERT INTO establishment.establishment_responsibility(establishment_id,legal_entity_id,responsibility_type_id,is_current)
   SELECT school,party,responsibility_type_id,true FROM establishment.establishment_responsibility_type WHERE name='Proprietor'
   ON CONFLICT DO NOTHING;
 SELECT r.establishment_responsibility_id INTO STRICT responsibility FROM establishment.establishment_responsibility r
 JOIN establishment.establishment_responsibility_type t USING(responsibility_type_id)
 WHERE r.establishment_id=school AND r.legal_entity_id=party AND t.name='Proprietor'
   AND r.start_date IS NULL AND r.end_date IS NULL AND r.is_current;
 INSERT INTO migration.source_snapshot(migration_run_id,source_system,snapshot_date,extract_name)
   SELECT run_id,'GIAS public extract',DATE '2026-06-16',d->>'extractPath'
   WHERE NOT EXISTS(SELECT 1 FROM migration.source_snapshot WHERE migration_run_id=run_id
     AND source_system='GIAS public extract' AND extract_name=d->>'extractPath');
 SELECT source_snapshot_id INTO STRICT snapshot_id FROM migration.source_snapshot WHERE migration_run_id=run_id
   AND source_system='GIAS public extract' AND extract_name=d->>'extractPath';
 INSERT INTO migration.source_snapshot(migration_run_id,source_system,source_database,snapshot_date,extract_name)
   SELECT run_id,'GIAS BAU','gias_bau_test_local',DATE '2026-10-09','T10 conflicting local context'
   WHERE NOT EXISTS(SELECT 1 FROM migration.source_snapshot WHERE migration_run_id=run_id AND extract_name='T10 conflicting local context');
 SELECT source_snapshot_id INTO STRICT context_snapshot FROM migration.source_snapshot
   WHERE migration_run_id=run_id AND extract_name='T10 conflicting local context';
 INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_urn,source_row_hash)
   VALUES(snapshot_id,'Establishment extract approved T10 fixture','148341',148341,md5(d::text))
   ON CONFLICT DO NOTHING;
 SELECT source_record_id INTO STRICT record_id FROM migration.source_record WHERE source_snapshot_id=snapshot_id AND source_key='148341';
 INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_urn,source_row_hash)
   SELECT context_snapshot,'dbo.Establishment/IndependentSchools (context only)','148341',148341,md5(to_jsonb(c)::text)
   FROM t10_local_context c ON CONFLICT DO NOTHING;
 SELECT source_record_id INTO STRICT context_record FROM migration.source_record WHERE source_snapshot_id=context_snapshot AND source_key='148341';
 INSERT INTO migration.identity_resolution(source_record_id,target_entity_type,target_entity_id,resolution_method,confidence,decision_status,decided_at,decided_by,rationale)
   SELECT record_id,'establishment',school,'accepted-controlled-establishment','accepted-fixture-assumption','accepted',now(),'User approval 2026-10-09',d::text
   WHERE NOT EXISTS(SELECT 1 FROM migration.identity_resolution WHERE source_record_id=record_id AND target_entity_type='establishment');
 INSERT INTO migration.identity_resolution(source_record_id,target_entity_type,target_entity_id,resolution_method,confidence,decision_status,decided_at,decided_by,rationale)
   SELECT record_id,'legal_entity',party,'accepted-shared-proprietor','assumed','accepted',now(),'User approval 2026-10-09',d->>'reviewEvidence'
   WHERE NOT EXISTS(SELECT 1 FROM migration.identity_resolution WHERE source_record_id=record_id AND target_entity_type='legal_entity');
 INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,first_observed_date,review_status,notes)
   SELECT responsibility,record_id,DATE '2026-06-16','accepted',
     'T10 approved PropsName=Outwood Grange Academies Trust; ' || (d->>'reviewEvidence') || ' Responsibility dates unknown; no ownership or Proprietor party role asserted.'
   WHERE NOT EXISTS(SELECT 1 FROM migration.establishment_responsibility_evidence WHERE establishment_responsibility_id=responsibility AND source_record_id=record_id);
 INSERT INTO migration.establishment_responsibility_evidence(establishment_responsibility_id,source_record_id,review_status,notes)
   SELECT responsibility,context_record,'accepted','T10 rejected local values retained as context only: ' || to_jsonb(c)::text
   FROM t10_local_context c
   WHERE NOT EXISTS(SELECT 1 FROM migration.establishment_responsibility_evidence WHERE establishment_responsibility_id=responsibility AND source_record_id=context_record);
END $$;
