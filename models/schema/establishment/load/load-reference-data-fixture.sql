BEGIN;
CREATE TEMP TABLE source_reference_data (
    reference_list text NOT NULL,
    source_table text NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    archived integer,
    group_code text,
    PRIMARY KEY (reference_list, code)
) ON COMMIT DROP;
\copy source_reference_data FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

CREATE TEMP TABLE reference_targets (
    ordinal integer, reference_list text PRIMARY KEY, source_table text,
    key_column text, key_kind text
) ON COMMIT DROP;
INSERT INTO reference_targets VALUES
    (1,'establishment_type_category','dbo.EstablishmentTypeGroup','establishment_type_category_id','integer'),
    (2,'establishment_type','dbo.EstablishmentType','establishment_type_id','type'),
    (3,'establishment_status','dbo.EstablishmentStatus','establishment_status_id','integer'),
    (4,'reason_establishment_opened','dbo.ReasonEstablishmentOpened','reason_establishment_opened_id','coded-integer'),
    (5,'reason_establishment_closed','dbo.ReasonEstablishmentClosed','reason_establishment_closed_id','coded-integer'),
    (6,'education_phase','dbo.EducationPhase','education_phase_id','integer'),
    (7,'gender_of_entry_type','dbo.Gender','gender_of_entry_type_id','integer'),
    (8,'admissions_policy','dbo.AdmissionsPolicy','admissions_policy_id','integer'),
    (9,'boarding_provision','dbo.Boarders','boarding_provision_id','integer'),
    (10,'diocese','dbo.Diocese','diocese_id','uuid'),
    (11,'further_education_type','dbo.FurtherEducationType','further_education_type_id','coded-integer'),
    (12,'nursery_provision','dbo.NurseryProvision','nursery_provision_id','integer'),
    (13,'sixth_form_provision','dbo.OfficialSixthForm','sixth_form_provision_id','integer'),
    (14,'section_41_approval_status','dbo.Section41Approved','section_41_approval_status_id','coded-integer'),
    (15,'specialist_provision_type','dbo.TypeOfReservedProvision','specialist_provision_type_id','integer'),
    (16,'religious_character','dbo.ReligiousCharacter','religious_character_id','coded-integer'),
    (17,'religious_ethos','dbo.ReligiousEthos','religious_ethos_id','coded-integer'),
    (18,'sen','dbo.Sen','sen_id','sen'),
    (19,'local_authority_jurisdiction','dbo.LocalAuthorityGroup','local_authority_jurisdiction_id','jurisdiction');

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM reference_targets t WHERE NOT EXISTS
        (SELECT 1 FROM source_reference_data s WHERE s.reference_list=t.reference_list)) THEN
        RAISE EXCEPTION 'Source reference extract must cover all 19 dictionaries';
    END IF;
    IF EXISTS (SELECT 1 FROM source_reference_data s LEFT JOIN reference_targets t USING(reference_list)
        WHERE t.reference_list IS NULL OR s.source_table IS DISTINCT FROM t.source_table
           OR s.archived NOT IN (0,1) OR btrim(s.code)='' OR btrim(s.name)=''
           OR s.code<>btrim(s.code)) THEN
        RAISE EXCEPTION 'Invalid source dictionary, code, label or archive flag';
    END IF;
END $$;

-- Preserve source labels. Only explicit business-scope exclusions are applied.
CREATE TEMP TABLE current_reference_data ON COMMIT DROP AS
SELECT s.* FROM source_reference_data s
WHERE coalesce(archived,0)=0
  AND NOT(reference_list='sen' AND code='00')
  AND NOT (reference_list IN ('education_phase','gender_of_entry_type','admissions_policy','boarding_provision',
                             'nursery_provision','sixth_form_provision','specialist_provision_type') AND code IN ('0','9'))
  AND NOT (reference_list='admissions_policy' AND code='5')
  AND NOT (reference_list IN ('further_education_type','religious_character','religious_ethos','reason_establishment_closed') AND code IN ('00','99'))
  AND NOT (reference_list='reason_establishment_opened' AND code IN ('00','13','99'))
  AND NOT (reference_list='diocese' AND code IN ('0000','9999'))
  AND NOT (reference_list='section_41_approval_status' AND code='3')
  AND (name !~* '^(unknown|not applicable( \(.*\))?|does not apply|not known|not recorded|not collected)$')
  AND (reference_list<>'establishment_status' OR code IN ('1','2','3','4'))
  AND (reference_list<>'local_authority_jurisdiction' OR code IN ('english','welsh'));

DO $$
DECLARE r record; code_expression text; key_expression text; differing boolean;
        run_id uuid; snapshot_id uuid;
BEGIN
    IF EXISTS (SELECT 1 FROM reference_targets t WHERE NOT EXISTS
        (SELECT 1 FROM current_reference_data s WHERE s.reference_list=t.reference_list)) THEN
        RAISE EXCEPTION 'Source filtering left a required reference dictionary empty';
    END IF;
    DELETE FROM establishment.establishment_sen WHERE sen_id IN (SELECT sen_id FROM establishment.sen WHERE code='00');
    FOR r IN SELECT * FROM reference_targets ORDER BY ordinal LOOP
        IF r.key_kind NOT IN ('uuid','jurisdiction') AND EXISTS (
            SELECT 1 FROM current_reference_data WHERE reference_list=r.reference_list AND code !~ '^[0-9]+$'
        ) THEN RAISE EXCEPTION 'Non-numeric business code in %',r.reference_list; END IF;
        IF r.key_kind='integer' AND EXISTS (
            SELECT 1 FROM current_reference_data WHERE reference_list=r.reference_list AND code::integer::text<>code
        ) THEN RAISE EXCEPTION 'Non-canonical integer business code in %',r.reference_list; END IF;

        IF r.key_kind='uuid' THEN
            EXECUTE format('INSERT INTO establishment.%I(%I,code,name) SELECT md5(''epr/''||reference_list||''/''||code)::uuid,code,name
                FROM current_reference_data WHERE reference_list=$1
                ON CONFLICT(code) DO UPDATE SET name=excluded.name',r.reference_list,r.key_column) USING r.reference_list;
        ELSIF r.key_kind='type' THEN
            UPDATE establishment.establishment_type t SET name=s.name,
                establishment_type_category_id=c.establishment_type_category_id,
                academy_route_id=CASE WHEN s.code IN ('34','44','42','45') THEN 1 WHEN s.code IN ('28','33','43','46') THEN 2 END
            FROM current_reference_data s JOIN establishment.establishment_type_category c ON c.code=s.group_code::integer
            WHERE s.reference_list=r.reference_list AND t.code=s.code;
            INSERT INTO establishment.establishment_type(code,name,establishment_type_category_id,academy_route_id)
            SELECT s.code,s.name,c.establishment_type_category_id,
                CASE WHEN s.code IN ('34','44','42','45') THEN 1 WHEN s.code IN ('28','33','43','46') THEN 2 END
            FROM current_reference_data s JOIN establishment.establishment_type_category c ON c.code=s.group_code::integer
            WHERE s.reference_list=r.reference_list AND NOT EXISTS(SELECT 1 FROM establishment.establishment_type t WHERE t.code=s.code)
            ORDER BY s.code;
        ELSE
            code_expression:=CASE WHEN r.key_kind='integer' THEN 's.code::integer' ELSE 's.code' END;
            EXECUTE format('UPDATE establishment.%I t SET name=s.name FROM current_reference_data s
                WHERE s.reference_list=$1 AND t.code=%s',r.reference_list,code_expression) USING r.reference_list;
            EXECUTE format('INSERT INTO establishment.%I(code,name) SELECT %s,s.name FROM current_reference_data s
                WHERE s.reference_list=$1 AND NOT EXISTS(SELECT 1 FROM establishment.%I t WHERE t.code=%s)
                ORDER BY %s',r.reference_list,code_expression,r.reference_list,code_expression,code_expression) USING r.reference_list;
        END IF;
        code_expression:='t.code::text';
        -- Full-set reconciliation; foreign keys protect referenced stale values.
        EXECUTE format('DELETE FROM establishment.%I t WHERE NOT EXISTS
            (SELECT 1 FROM current_reference_data s WHERE s.reference_list=$1 AND s.code=(%s))',r.reference_list,code_expression)
            USING r.reference_list;
        EXECUTE format('SELECT EXISTS ((SELECT %s AS code,name FROM establishment.%I t EXCEPT SELECT code,name FROM current_reference_data WHERE reference_list=$1)
            UNION ALL (SELECT code,name FROM current_reference_data WHERE reference_list=$1 EXCEPT SELECT %s,name FROM establishment.%I t))',
            code_expression,r.reference_list,code_expression,r.reference_list) INTO differing USING r.reference_list;
        IF differing THEN RAISE EXCEPTION 'Source/target reference reconciliation failed for %',r.reference_list; END IF;
    END LOOP;

    INSERT INTO migration.migration_run(run_type,source_system,source_database,source_snapshot_date,status,completed_at,transform_version,notes)
    SELECT 'reference-data','GIAS BAU','__SOURCE_DATABASE__',current_date,'completed',now(),'source-reference-v1',
        jsonb_build_object('source_rows',jsonb_agg(to_jsonb(s) || jsonb_build_object('included',EXISTS(
            SELECT 1 FROM current_reference_data c WHERE c.reference_list=s.reference_list AND c.code=s.code)) ORDER BY reference_list,code),
            'source_count',count(*),'included_count',(SELECT count(*) FROM current_reference_data))::text
    FROM source_reference_data s RETURNING migration_run_id INTO run_id;
    INSERT INTO migration.source_snapshot(migration_run_id,source_system,source_database,snapshot_date,extract_name)
    VALUES(run_id,'GIAS BAU','__SOURCE_DATABASE__',current_date,'source-reference-data') RETURNING source_snapshot_id INTO snapshot_id;
    INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_row_hash)
    SELECT snapshot_id,source_table,code,md5(to_jsonb(s)::text) FROM source_reference_data s;
END $$;

SELECT t.reference_list,count(s.code) AS source_rows,count(c.code) AS included_rows,
       count(s.code)-count(c.code) AS excluded_rows
FROM reference_targets t JOIN source_reference_data s USING(reference_list)
LEFT JOIN current_reference_data c USING(reference_list,code)
GROUP BY t.ordinal,t.reference_list ORDER BY t.ordinal;
DROP TABLE current_reference_data,source_reference_data,reference_targets;
COMMIT;
