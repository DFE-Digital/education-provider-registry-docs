BEGIN;
CREATE TEMP TABLE development_group_source (
    group_uid text NOT NULL, group_id text, group_name text NOT NULL,
    group_type text NOT NULL, local_authority_code integer,
    group_open_date date, group_close_date date, establishment_urn integer NOT NULL,
    joined_date date, source_link_id text NOT NULL, source_archived integer NOT NULL,
    source_link_type text
) ON COMMIT DROP;
\copy development_group_source FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

DO $$
DECLARE g record; member record; organisation_id uuid; authority_id uuid; run_id uuid;
BEGIN
    run_id := NULLIF(current_setting('epr.migration_run_id', true), '')::uuid;
    FOR g IN SELECT group_uid, min(group_id) group_id, min(group_name) group_name,
                    min(group_type) group_type, min(local_authority_code) local_authority_code,
                    min(group_open_date) group_open_date, min(group_close_date) group_close_date,
                    count(*) member_count, count(DISTINCT establishment_urn) distinct_members
             FROM development_group_source GROUP BY group_uid LOOP
        BEGIN
            IF g.group_type NOT IN ('Federation','Children''s-centre group')
               OR g.member_count <> g.distinct_members
               OR EXISTS (SELECT 1 FROM development_group_source x WHERE x.group_uid=g.group_uid AND x.source_archived<>0)
               OR g.group_close_date IS NOT NULL THEN
                RAISE EXCEPTION 'Invalid development organisation group';
            END IF;
            IF g.group_type='Federation' AND g.member_count < 1 THEN RAISE EXCEPTION 'Empty federation'; END IF;
            IF g.group_type='Children''s-centre group' THEN
                SELECT local_authority_area_id INTO authority_id FROM establishment.local_authority_area WHERE code=g.local_authority_code;
                IF authority_id IS NULL THEN RAISE EXCEPTION 'Unmapped children''s-centre authority'; END IF;
            END IF;
            SELECT i.organisation_group_id INTO organisation_id
            FROM establishment.group_identifier i
            JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
            JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
            WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value=g.group_uid;
            IF organisation_id IS NULL THEN
                INSERT INTO establishment.organisation_group(name, organisation_group_type_id, local_authority_area_id, open_date, close_date)
                SELECT g.group_name, organisation_group_type_id, authority_id, g.group_open_date, g.group_close_date
                FROM establishment.organisation_group_type WHERE name=g.group_type
                RETURNING organisation_group_id INTO organisation_id;
            END IF;
            INSERT INTO establishment.group_identifier(organisation_group_id,group_identifier_type_id,group_identifier_issuer_id,value,is_current)
            SELECT organisation_id,t.group_identifier_type_id,issuer.group_identifier_issuer_id,v.value,true
            FROM (VALUES ('Group UID',g.group_uid),('Group ID',g.group_id)) v(kind,value)
            JOIN establishment.group_identifier_type t ON t.name=v.kind
            CROSS JOIN establishment.group_identifier_issuer issuer
            WHERE issuer.name='GIAS' AND v.value IS NOT NULL
            ON CONFLICT (group_identifier_type_id,value) DO NOTHING;
            INSERT INTO establishment.organisation_group_member(organisation_group_id,establishment_id,joined_date,left_date)
            SELECT organisation_id,e.establishment_id,s.joined_date,NULL
            FROM development_group_source s JOIN establishment.establishment e ON e.urn=s.establishment_urn
            WHERE s.group_uid=g.group_uid
              AND NOT EXISTS (SELECT 1 FROM establishment.organisation_group_member m
                              WHERE m.organisation_group_id=organisation_id AND m.establishment_id=e.establishment_id
                                AND m.joined_date IS NOT DISTINCT FROM s.joined_date);
        EXCEPTION WHEN OTHERS THEN
            IF run_id IS NOT NULL THEN
                INSERT INTO migration.relationship_load_error(migration_run_id,urn,relationship_kind,error_message)
                SELECT run_id,establishment_urn,'organisation-group','Development organisation group '||g.group_uid||' was skipped.'
                FROM development_group_source WHERE group_uid=g.group_uid;
            END IF;
        END;
    END LOOP;
END $$;
COMMIT;
