CREATE TEMP TABLE reviewed_fixture ON COMMIT DROP AS
SELECT '__REVIEWED_FIXTURE_JSON__'::text AS raw_json,
       '__REVIEWED_FIXTURE_SHA256__'::text AS expected_sha256;
CREATE TEMP TABLE historical_membership_fixture (
    group_uid text,group_name text,group_open_date date,group_close_date date,
    establishment_urn integer,joined_date date,left_date date,source_link_id text,source_archived integer
) ON COMMIT DROP;
\copy historical_membership_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv,HEADER true,DELIMITER '|',NULL 'NULL')
DO $$
DECLARE config jsonb; row_source record; group_id uuid; school_id uuid; member_id uuid;
        run_id uuid; snapshot_id uuid; source_id uuid; existing_left date;
BEGIN
    SELECT raw_json::jsonb INTO config FROM reviewed_fixture
    WHERE encode(digest(raw_json,'sha256'),'hex')=expected_sha256;
    IF config IS NULL OR config->>'reviewStatus' IS DISTINCT FROM 'accepted'
       OR config->>'mode' IS DISTINCT FROM 'historical-group-membership'
       OR NULLIF(btrim(config->>'reviewEvidence'),'') IS NULL
       OR config->>'groupType' IS DISTINCT FROM 'Federation'
       OR (config->>'identifierCurrent')::boolean IS DISTINCT FROM false THEN
        RAISE EXCEPTION 'Historical membership decision changed; manual review required';
    END IF;
    IF (SELECT count(*) FROM historical_membership_fixture)=0
       OR (SELECT count(*) FROM historical_membership_fixture)<>jsonb_array_length(config->'expectedSourceRows')
       OR (SELECT count(DISTINCT group_uid) FROM historical_membership_fixture)<>1
       OR (SELECT count(DISTINCT source_link_id) FROM historical_membership_fixture)<>(SELECT count(*) FROM historical_membership_fixture)
       OR EXISTS(SELECT 1 FROM historical_membership_fixture f WHERE f.source_archived<>1
          OR NOT EXISTS(SELECT 1 FROM jsonb_populate_recordset(NULL::pg_temp.historical_membership_fixture,config->'expectedSourceRows') e
                        WHERE to_jsonb(f)=to_jsonb(e))) THEN
        RAISE EXCEPTION 'Historical membership source differs from reviewed fixture; review required';
    END IF;
    SELECT * INTO STRICT row_source FROM historical_membership_fixture LIMIT 1;
    SELECT i.organisation_group_id INTO group_id
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value=row_source.group_uid;
    IF group_id IS NULL THEN
        IF EXISTS(SELECT 1 FROM establishment.group_identifier i
                  JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
                  WHERE t.name='Group UID' AND i.value=row_source.group_uid)
           OR EXISTS(SELECT 1 FROM establishment.organisation_group WHERE name=row_source.group_name) THEN
            RAISE EXCEPTION 'Historical group UID/name ownership conflict; identity review required';
        END IF;
        INSERT INTO establishment.organisation_group(name,organisation_group_type_id,open_date,close_date)
        SELECT row_source.group_name,organisation_group_type_id,row_source.group_open_date,row_source.group_close_date
        FROM establishment.organisation_group_type WHERE name=config->>'groupType'
        RETURNING organisation_group_id INTO STRICT group_id;
        INSERT INTO establishment.group_identifier(organisation_group_id,group_identifier_type_id,group_identifier_issuer_id,value,is_current)
        SELECT group_id,t.group_identifier_type_id,issuer.group_identifier_issuer_id,row_source.group_uid,false
        FROM establishment.group_identifier_type t CROSS JOIN establishment.group_identifier_issuer issuer
        WHERE t.name='Group UID' AND issuer.name='GIAS';
    END IF;
    IF EXISTS(SELECT 1 FROM historical_membership_fixture f WHERE
         ROW(f.group_name,f.group_open_date,f.group_close_date)
         IS DISTINCT FROM ROW(row_source.group_name,row_source.group_open_date,row_source.group_close_date))
       OR NOT EXISTS(SELECT 1 FROM establishment.organisation_group g
           JOIN establishment.organisation_group_type gt USING(organisation_group_type_id)
           JOIN establishment.group_identifier i USING(organisation_group_id)
           JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
           JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
           WHERE g.organisation_group_id=group_id AND t.name='Group UID' AND issuer.name='GIAS'
             AND i.value=row_source.group_uid AND NOT i.is_current AND gt.name=config->>'groupType'
             AND g.local_authority_id IS NULL
             AND ROW(g.name,g.open_date,g.close_date) IS NOT DISTINCT FROM ROW(row_source.group_name,row_source.group_open_date,row_source.group_close_date)) THEN
        RAISE EXCEPTION 'Historical group UID has conflicting identity/lifecycle; review required';
    END IF;
    INSERT INTO migration.migration_run(run_type,source_system,source_database,status,transform_version,completed_at,notes)
    VALUES(config->>'runType',config->>'sourceSystem',config->>'sourceDatabase','completed',config->>'transformVersion',now(),config->>'reviewEvidence')
    RETURNING migration_run_id INTO run_id;
    INSERT INTO migration.source_snapshot(migration_run_id,source_system,source_database,snapshot_date,extract_name)
    VALUES(run_id,config->>'sourceSystem',config->>'sourceDatabase',CURRENT_DATE,config->>'extractName')
    RETURNING source_snapshot_id INTO snapshot_id;
    FOR row_source IN SELECT * FROM historical_membership_fixture ORDER BY source_link_id LOOP
        SELECT establishment_id INTO STRICT school_id FROM establishment.establishment WHERE urn=row_source.establishment_urn;
        SELECT organisation_group_member_id,left_date INTO member_id,existing_left
        FROM establishment.organisation_group_member
        WHERE organisation_group_id=group_id AND establishment_id=school_id
          AND joined_date IS NOT DISTINCT FROM row_source.joined_date FOR UPDATE;
        IF member_id IS NULL THEN
            INSERT INTO establishment.organisation_group_member(organisation_group_id,establishment_id,joined_date,left_date)
            VALUES(group_id,school_id,row_source.joined_date,row_source.left_date)
            RETURNING organisation_group_member_id INTO member_id;
        ELSIF existing_left IS DISTINCT FROM row_source.left_date THEN
            RAISE EXCEPTION 'Historical membership end conflicts with reviewed fixture; review required';
        END IF;
        INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_group_id,source_urn,source_row_hash)
        VALUES(snapshot_id,config->>'sourceTable',row_source.source_link_id,row_source.group_uid,row_source.establishment_urn,md5(to_jsonb(row_source)::text))
        RETURNING source_record_id INTO source_id;
        INSERT INTO migration.organisation_group_member_evidence(organisation_group_member_id,source_record_id,left_date_basis,inference_rule,review_status,notes)
        VALUES(member_id,source_id,config->>'leftDateBasis',config->>'inferenceRule','accepted',config->>'reviewEvidence');
    END LOOP;
END $$;
