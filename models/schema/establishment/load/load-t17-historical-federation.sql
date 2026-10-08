BEGIN;
CREATE TEMP TABLE t17_federation_fixture (
    group_uid text,group_name text,group_open_date date,group_close_date date,
    establishment_urn integer,joined_date date,left_date date,source_link_id text,source_archived integer
) ON COMMIT DROP;
\copy t17_federation_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv,HEADER true,DELIMITER '|',NULL 'NULL')
DO $$ BEGIN
 IF (SELECT count(*) FROM t17_federation_fixture)<>1 OR NOT EXISTS (
   SELECT 1 FROM t17_federation_fixture WHERE group_uid='1537' AND establishment_urn=103630
    AND group_name='The Federation of Beaufort School and Langley School'
    AND group_open_date=DATE '2012-04-01' AND group_close_date=DATE '2020-07-01'
    AND joined_date=DATE '2012-04-01' AND left_date=DATE '2020-06-16'
    AND source_link_id='1245' AND source_archived=1)
 THEN RAISE EXCEPTION 'T17 historical federation fixture changed'; END IF;
 IF EXISTS (SELECT 1 FROM establishment.group_identifier i
            JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
            WHERE t.name='Group UID' AND i.value='1537' AND i.organisation_group_id IS NULL)
 THEN RAISE EXCEPTION 'T17 federation UID belongs to a party role'; END IF;
 IF NOT EXISTS (SELECT 1 FROM establishment.group_identifier i
                JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
                WHERE t.name='Group UID' AND i.value='1537')
    AND EXISTS (SELECT 1 FROM establishment.organisation_group WHERE name='The Federation of Beaufort School and Langley School')
 THEN RAISE EXCEPTION 'T17 federation has only a name match; identity review required'; END IF;
END $$;
INSERT INTO establishment.organisation_group (name,organisation_group_type_id,open_date,close_date)
SELECT f.group_name,t.organisation_group_type_id,f.group_open_date,f.group_close_date
FROM t17_federation_fixture f CROSS JOIN establishment.organisation_group_type t
WHERE t.name='Federation' AND NOT EXISTS (
 SELECT 1 FROM establishment.group_identifier i JOIN establishment.group_identifier_type it USING(group_identifier_type_id)
 WHERE it.name='Group UID' AND i.value=f.group_uid);
INSERT INTO establishment.group_identifier
 (organisation_group_id,group_identifier_type_id,group_identifier_issuer_id,value,is_current)
SELECT g.organisation_group_id,t.group_identifier_type_id,issuer.group_identifier_issuer_id,f.group_uid,false
FROM t17_federation_fixture f JOIN establishment.organisation_group g
 ON g.name=f.group_name AND g.open_date=f.group_open_date AND g.close_date=f.group_close_date
JOIN establishment.organisation_group_type gt USING(organisation_group_type_id)
CROSS JOIN establishment.group_identifier_type t CROSS JOIN establishment.group_identifier_issuer issuer
WHERE gt.name='Federation' AND t.name='Group UID' AND issuer.name='GIAS'
ON CONFLICT(group_identifier_type_id,value) DO NOTHING;
CREATE TEMP TABLE t17_group_context AS
SELECT g.organisation_group_id FROM establishment.group_identifier i
JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
JOIN establishment.organisation_group g USING(organisation_group_id)
JOIN establishment.organisation_group_type gt USING(organisation_group_type_id)
WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='1537' AND NOT i.is_current
 AND gt.name='Federation' AND g.local_authority_id IS NULL
 AND g.name='The Federation of Beaufort School and Langley School'
 AND g.open_date=DATE '2012-04-01' AND g.close_date=DATE '2020-07-01';
DO $$ BEGIN IF (SELECT count(*) FROM t17_group_context)<>1
 THEN RAISE EXCEPTION 'T17 existing federation UID has a conflicting identity or lifecycle'; END IF; END $$;
INSERT INTO establishment.organisation_group_member
 (organisation_group_id,establishment_id,joined_date,left_date,is_lead_member)
SELECT c.organisation_group_id,e.establishment_id,f.joined_date,f.left_date,NULL
FROM t17_federation_fixture f CROSS JOIN t17_group_context c
JOIN establishment.establishment e ON e.urn=f.establishment_urn
WHERE NOT EXISTS (SELECT 1 FROM establishment.organisation_group_member m
 WHERE m.organisation_group_id=c.organisation_group_id AND m.establishment_id=e.establishment_id
 AND m.joined_date=f.joined_date);
CREATE TEMP TABLE t17_evidence_context AS
WITH run AS (
 INSERT INTO migration.migration_run(run_type,source_system,source_database,status,transform_version)
 VALUES('t17-historical-membership','GIAS BAU','gias_bau_test_local','completed','t17-v1') RETURNING migration_run_id
), snapshot AS (
 INSERT INTO migration.source_snapshot(migration_run_id,source_system,source_database,snapshot_date,extract_name)
 SELECT migration_run_id,'GIAS BAU','gias_bau_test_local',CURRENT_DATE,'t17-historical-federation-1537' FROM run
 RETURNING source_snapshot_id
), record AS (
 INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_group_id,source_urn)
 SELECT source_snapshot_id,'dbo.EstablishmentGroup/GroupLink','1245','1537',103630 FROM snapshot
 RETURNING source_record_id
)
SELECT source_record_id FROM record;
INSERT INTO migration.organisation_group_member_evidence
 (organisation_group_member_id,source_record_id,left_date_basis,inference_rule,review_status,notes)
SELECT m.organisation_group_member_id,c.source_record_id,'inferred',
 'Membership end is the earlier known establishment/group closure upper bound.','accepted',
 'T17 Source GroupLink 1245: archived=1; effectiveDate=2012-04-01; membership end 2020-06-16 inferred from Langley closure, before federation closure 2020-07-01. Source member Beaufort 103627 / link 1246 not imported. Membership scope: supplied URNs only; not the complete source group. Federation is not a legal entity or responsibility.'
FROM establishment.organisation_group_member m CROSS JOIN t17_group_context g CROSS JOIN t17_evidence_context c
JOIN establishment.establishment e ON e.urn=103630
WHERE m.organisation_group_id=g.organisation_group_id AND m.establishment_id=e.establishment_id
 AND m.joined_date=DATE '2012-04-01';
COMMIT;
