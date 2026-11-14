-- Development snapshot only. Source group UID is the identity key; no name
-- matching, reviewed fixture assertions, or inferred lifecycle boundaries.
BEGIN;
CREATE TEMP TABLE development_party_source (
    legal_entity_name text, companies_house_number text, ukprn text,
    legal_entity_incorporation_date date, group_uid text, group_id text,
    establishment_party_role_type text, academy_trust_type text, responsibility_type text,
    role_start_date date, role_end_date date, role_end_date_basis text,
    classification_start_date date, classification_end_date date, is_current boolean,
    establishment_urn integer, responsibility_start_date date, responsibility_end_date date,
    end_date_basis text, consolidation_evidence text, responsibility_is_current boolean,
    source_link_id text, source_group_open_date date, source_archived integer,
    party_kind text, party_mapping_evidence text
) ON COMMIT DROP;
\copy development_party_source FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')
DELETE FROM development_party_source s WHERE NOT EXISTS (
    SELECT 1 FROM establishment.establishment e WHERE e.urn=s.establishment_urn);
CREATE INDEX ON development_party_source(group_uid);
ANALYZE development_party_source;

DO $$
DECLARE
    src record;
    run_id uuid := NULLIF(current_setting('epr.migration_run_id',true),'')::uuid;
    entity_id uuid; role_id uuid; owner_id uuid; role_type integer;
    trust_type integer; responsibility_type integer; issuer_id integer;
    uid_type integer; group_type integer; identifier_type integer;
    identifier record; existing_owner uuid;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM migration.migration_run
                   WHERE migration_run_id=run_id AND run_type='development-establishment-seed'
                     AND source_system='GIAS BAU' AND status='running') THEN
        -- Configuration errors must stop the phase, not be counted as bad data.
        RAISE EXCEPTION USING ERRCODE='55000', MESSAGE='Development party load requires a running development seed run';
    END IF;
    SELECT group_identifier_issuer_id INTO STRICT issuer_id
    FROM establishment.group_identifier_issuer WHERE name='GIAS';
    SELECT group_identifier_type_id INTO STRICT uid_type
    FROM establishment.group_identifier_type WHERE name='Group UID';
    SELECT group_identifier_type_id INTO STRICT group_type
    FROM establishment.group_identifier_type WHERE name='Group ID';

    FOR src IN SELECT * FROM development_party_source ORDER BY group_uid,establishment_urn,source_link_id LOOP
        BEGIN
            entity_id := NULL; role_id := NULL; trust_type := NULL;
            SELECT establishment_id INTO STRICT owner_id
            FROM establishment.establishment WHERE urn=src.establishment_urn;
            SELECT establishment_party_role_type_id INTO STRICT role_type
            FROM establishment.establishment_party_role_type WHERE name=src.establishment_party_role_type;
            SELECT responsibility_type_id INTO STRICT responsibility_type
            FROM establishment.establishment_responsibility_type WHERE name=src.responsibility_type;
            IF src.academy_trust_type IS NOT NULL THEN
                SELECT academy_trust_type_id INTO STRICT trust_type
                FROM establishment.academy_trust_type WHERE name=src.academy_trust_type;
            END IF;
            IF src.party_kind IS DISTINCT FROM 'legal_entity' OR NULLIF(btrim(src.group_uid),'') IS NULL THEN
                RAISE EXCEPTION 'Unsupported development party kind or missing source group UID';
            END IF;

            -- Only reuse an explicitly mapped source UID. Never merge by name,
            -- company number, UKPRN or a similar-looking source group identifier.
            SELECT r.legal_entity_id,r.establishment_party_role_id INTO entity_id,role_id
            FROM establishment.group_identifier i
            JOIN establishment.establishment_party_role r USING(establishment_party_role_id)
            WHERE i.group_identifier_type_id=uid_type AND i.group_identifier_issuer_id=issuer_id
              AND i.value=src.group_uid AND r.establishment_party_role_type_id=role_type;
            IF entity_id IS NULL THEN
                IF EXISTS (SELECT 1 FROM establishment.group_identifier
                           WHERE group_identifier_type_id=uid_type AND value=src.group_uid) THEN
                    RAISE EXCEPTION 'Source group UID already belongs to an incompatible role or group';
                END IF;
                INSERT INTO establishment.legal_entity(name,incorporation_date)
                VALUES(src.legal_entity_name,src.legal_entity_incorporation_date)
                RETURNING legal_entity_id INTO entity_id;
                INSERT INTO establishment.establishment_party_role(establishment_party_role_type_id,legal_entity_id)
                VALUES(role_type,entity_id) RETURNING establishment_party_role_id INTO role_id;
                INSERT INTO establishment.group_identifier(establishment_party_role_id,group_identifier_type_id,
                    group_identifier_issuer_id,value,is_current)
                VALUES(role_id,uid_type,issuer_id,src.group_uid,src.is_current);
            END IF;

            -- Retain supplied identifiers if they fit. A conflicting owner is
            -- skipped as data loss rather than resolved into a new identity.
            FOR identifier IN SELECT * FROM (VALUES ('Companies House number',src.companies_house_number),
                                                         ('UKPRN',src.ukprn)) v(kind,value)
                              WHERE value IS NOT NULL LOOP
                SELECT organisation_identifier_type_id INTO STRICT identifier_type
                FROM establishment.organisation_identifier_type WHERE name=identifier.kind;
                SELECT legal_entity_id INTO existing_owner FROM establishment.organisation_identifier
                WHERE organisation_identifier_type_id=identifier_type AND value=identifier.value;
                IF existing_owner IS NOT NULL AND existing_owner<>entity_id THEN
                    RAISE EXCEPTION 'Source group % has a conflicting % owner',src.group_uid,identifier.kind;
                END IF;
                INSERT INTO establishment.organisation_identifier(legal_entity_id,organisation_identifier_type_id,value,is_current)
                SELECT entity_id,identifier_type,identifier.value,true
                WHERE existing_owner IS NULL;
            END LOOP;

            IF src.group_id IS NOT NULL THEN
                INSERT INTO establishment.group_identifier(establishment_party_role_id,group_identifier_type_id,
                    group_identifier_issuer_id,value,is_current)
                SELECT role_id,group_type,issuer_id,src.group_id,src.is_current
                WHERE NOT EXISTS (SELECT 1 FROM establishment.group_identifier
                                  WHERE group_identifier_type_id=group_type AND value=src.group_id
                                    AND establishment_party_role_id=role_id);
            END IF;
            IF trust_type IS NOT NULL THEN
                INSERT INTO establishment.academy_trust_classification(legal_entity_id,academy_trust_type_id,is_current)
                SELECT entity_id,trust_type,src.is_current
                WHERE NOT EXISTS (SELECT 1 FROM establishment.academy_trust_classification
                                  WHERE legal_entity_id=entity_id AND academy_trust_type_id=trust_type);
            END IF;
            INSERT INTO establishment.establishment_responsibility(establishment_id,legal_entity_id,
                responsibility_type_id,academy_trust_type_id,start_date,is_current)
            VALUES(owner_id,entity_id,responsibility_type,trust_type,src.responsibility_start_date,src.responsibility_is_current)
            ON CONFLICT (establishment_id,legal_entity_id,responsibility_type_id,COALESCE(start_date,DATE '-infinity'))
                WHERE legal_entity_id IS NOT NULL DO NOTHING;
        EXCEPTION WHEN data_exception OR integrity_constraint_violation OR raise_exception THEN
            INSERT INTO migration.relationship_load_error(migration_run_id,urn,relationship_kind,error_message,source_row)
            VALUES(run_id,src.establishment_urn,'party','['||SQLSTATE||'] '||SQLERRM,to_jsonb(src));
        END;
    END LOOP;
END $$;
UPDATE migration.migration_run SET notes=(coalesce(notes::jsonb,'{}') || jsonb_build_object('party',
    jsonb_build_object('attempted',(SELECT count(*) FROM development_party_source),
        'loaded',(SELECT count(*) FROM development_party_source)-(SELECT count(*) FROM migration.relationship_load_error WHERE migration_run_id='__RUN_ID__' AND relationship_kind='party'),
        'skipped',(SELECT count(*) FROM migration.relationship_load_error WHERE migration_run_id='__RUN_ID__' AND relationship_kind='party'))))::text
WHERE migration_run_id='__RUN_ID__';
COMMIT;
