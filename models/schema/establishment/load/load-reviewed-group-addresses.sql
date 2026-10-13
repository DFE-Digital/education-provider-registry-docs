CREATE TEMP TABLE reviewed_fixture ON COMMIT DROP AS
SELECT '__REVIEWED_FIXTURE_JSON__'::text AS raw_json,
       '__REVIEWED_FIXTURE_SHA256__'::text AS expected_sha256;
CREATE TEMP TABLE group_address_fixture (
    source_group_id integer,source_type_code text,source_address_block text,
    address_line_1 text,address_line_2 text,address_line_3 text,town text,county text,postcode text,
    source_county_code text,source_country_code text,source_uprn text,source_site_name text
) ON COMMIT DROP;
\copy group_address_fixture FROM '__FIXTURE_PATH__' WITH(FORMAT csv,HEADER true,DELIMITER '|',NULL 'NULL')
DO $$
DECLARE c record; owner_id uuid; owner_kind text; association uuid; postal uuid; purpose integer;
        run_id uuid; snapshot uuid; source_id uuid; raw jsonb; present boolean; decision text;
        config jsonb; mapping jsonb; case_label text; purpose_code text;
BEGIN
    SELECT raw_json::jsonb INTO config FROM reviewed_fixture
    WHERE encode(digest(raw_json,'sha256'),'hex')=expected_sha256;
    IF config IS NULL OR config->>'reviewStatus' IS DISTINCT FROM 'accepted'
       OR NULLIF(btrim(config->>'reviewEvidence'),'') IS NULL
       OR config->>'mode' IS DISTINCT FROM 'current-observation' THEN
        RAISE EXCEPTION 'Reviewed address mapping changed; manual migration decision required';
    END IF;
    case_label:=config->>'fixture';
    IF jsonb_array_length(config->'sourceGroups')=0
       OR jsonb_array_length(config->'blockMappings')=0
       OR (SELECT count(*) FROM group_address_fixture)<>jsonb_array_length(config->'blockMappings')
       OR (SELECT count(DISTINCT (source_group_id,source_address_block)) FROM group_address_fixture)<>jsonb_array_length(config->'blockMappings')
       OR EXISTS(SELECT 1 FROM group_address_fixture f WHERE NOT EXISTS(
            SELECT 1 FROM jsonb_array_elements(config->'sourceGroups') g
            JOIN jsonb_array_elements(config->'blockMappings') m ON (m->>'groupUid')::integer=(g->>'uid')::integer
            WHERE f.source_group_id=(g->>'uid')::integer AND f.source_type_code=g->>'typeCode'
              AND f.source_address_block=m->>'block')
            OR f.county IS NOT NULL OR f.source_county_code IS DISTINCT FROM config->>'sourceCountyCode'
            OR f.source_country_code IS DISTINCT FROM config->>'sourceCountryCode') THEN
        RAISE EXCEPTION '% address source scope/reference codes changed; review required',case_label;
    END IF;
    CREATE TEMP TABLE group_address_owners ON COMMIT DROP AS
    SELECT (g->>'uid')::integer AS source_group_id,g->>'ownerKey' AS owner_key,
           'legal_entity'::text AS owner_kind,r.legal_entity_id AS owner_id
    FROM jsonb_array_elements(config->'sourceGroups') g
    JOIN establishment.group_identifier i ON i.value=g->>'uid'
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
    JOIN establishment.establishment_party_role r USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS'
      AND coalesce(g->>'ownerKind','legal_entity')='legal_entity'
    UNION ALL
    SELECT (g->>'uid')::integer,g->>'ownerKey','organisation_group'::text,i.organisation_group_id
    FROM jsonb_array_elements(config->'sourceGroups') g
    JOIN establishment.group_identifier i ON i.value=g->>'uid'
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.establishment_party_role_id IS NULL
      AND coalesce(g->>'ownerKind','legal_entity')='organisation_group'
    UNION ALL
    SELECT (g->>'uid')::integer,g->>'ownerKey','person'::text,r.person_id
    FROM jsonb_array_elements(config->'sourceGroups') g
    JOIN establishment.group_identifier i ON i.value=g->>'uid'
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
    JOIN establishment.establishment_party_role r USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND r.person_id IS NOT NULL
      AND coalesce(g->>'ownerKind','legal_entity')='person';
    IF (SELECT count(*) FROM group_address_owners)<>jsonb_array_length(config->'sourceGroups')
       OR EXISTS(SELECT 1 FROM group_address_owners WHERE NULLIF(btrim(owner_key),'') IS NULL)
       OR EXISTS(SELECT 1 FROM group_address_owners o GROUP BY o.owner_key HAVING count(DISTINCT (o.owner_kind,o.owner_id))<>1)
       OR EXISTS(SELECT 1 FROM group_address_owners o GROUP BY o.owner_kind,o.owner_id HAVING count(DISTINCT o.owner_key)<>1) THEN
        RAISE EXCEPTION '% address owner identity differs from the accepted fixture; review required',case_label;
    END IF;
    run_id:=current_setting('epr.migration_run_id')::uuid;
    IF NOT EXISTS(SELECT 1 FROM migration.migration_run WHERE migration_run_id=run_id
                  AND run_type=config->>'runType' AND status='running') THEN
        RAISE EXCEPTION '% addresses require a running scoped migration',case_label;
    END IF;
    IF (config ? 'urn' AND NOT EXISTS(SELECT 1 FROM establishment.establishment WHERE urn=(config->>'urn')::integer))
       OR (config ? 'urns' AND (SELECT count(*) FROM establishment.establishment
            WHERE urn IN (SELECT value::integer FROM jsonb_array_elements_text(config->'urns')))
            <>jsonb_array_length(config->'urns')) THEN
        RAISE EXCEPTION 'Load the reviewed establishment and parties before addresses';
    END IF;
    INSERT INTO migration.source_snapshot(migration_run_id,source_system,source_database,snapshot_date,extract_name)
    SELECT run_id,source_system,source_database,source_snapshot_date,config->>'snapshotName'
    FROM migration.migration_run r WHERE migration_run_id=run_id
      AND NOT EXISTS(SELECT 1 FROM migration.source_snapshot WHERE migration_run_id=run_id AND extract_name=config->>'snapshotName');
    SELECT source_snapshot_id INTO STRICT snapshot FROM migration.source_snapshot
    WHERE migration_run_id=run_id AND extract_name=config->>'snapshotName';
    FOR c IN SELECT * FROM group_address_fixture ORDER BY source_group_id,source_address_block LOOP
        SELECT o.owner_id,o.owner_kind INTO STRICT owner_id,owner_kind FROM group_address_owners o WHERE o.source_group_id=c.source_group_id;
        SELECT m INTO STRICT mapping FROM jsonb_array_elements(config->'blockMappings') m
        WHERE (m->>'groupUid')::integer=c.source_group_id AND m->>'block'=c.source_address_block;
        purpose:=(mapping->>'purposeId')::integer;
        raw:=to_jsonb(c);
        present:=NULLIF(btrim(concat(c.address_line_1,c.address_line_2,c.address_line_3,c.town,c.county,c.postcode)),'') IS NOT NULL;
        association:=NULL; postal:=NULL;
        IF present IS DISTINCT FROM (purpose IS NOT NULL) THEN
            RAISE EXCEPTION '% populated/blank address mapping changed; manual migration decision required',case_label;
        END IF;
        IF owner_kind='person' AND present THEN
            RAISE EXCEPTION '% populated person address requires a separate model and migration decision',case_label;
        END IF;
        IF present THEN
            SELECT code INTO STRICT purpose_code FROM establishment.address_purpose WHERE address_purpose_id=purpose;
            IF owner_kind='legal_entity' THEN
                SELECT address_id,legal_entity_address_id INTO postal,association FROM establishment.legal_entity_address
                WHERE legal_entity_id=owner_id AND address_purpose_id=purpose AND is_current FOR UPDATE;
            ELSE
                SELECT address_id,organisation_group_address_id INTO postal,association FROM establishment.organisation_group_address
                WHERE organisation_group_id=owner_id AND address_purpose_id=purpose AND is_current FOR UPDATE;
            END IF;
            IF postal IS NOT NULL AND NOT EXISTS(SELECT 1 FROM establishment.address a WHERE address_id=postal
                AND ROW(a.address_line_1,a.address_line_2,a.address_line_3,a.town,a.county,a.postcode)
                    IS NOT DISTINCT FROM ROW(NULLIF(btrim(c.address_line_1),''),NULLIF(btrim(c.address_line_2),''),
                        NULLIF(btrim(c.address_line_3),''),NULLIF(btrim(c.town),''),NULLIF(btrim(c.county),''),NULLIF(btrim(c.postcode),''))) THEN
                RAISE EXCEPTION '% existing address differs; manual migration decision required',case_label;
            END IF;
            IF postal IS NULL THEN
                SELECT address_id INTO postal FROM establishment.address a
                WHERE ROW(a.address_line_1,a.address_line_2,a.address_line_3,a.town,a.county,a.postcode)
                    IS NOT DISTINCT FROM ROW(NULLIF(btrim(c.address_line_1),''),NULLIF(btrim(c.address_line_2),''),
                        NULLIF(btrim(c.address_line_3),''),NULLIF(btrim(c.town),''),NULLIF(btrim(c.county),''),NULLIF(btrim(c.postcode),''))
                ORDER BY address_id LIMIT 1;
                IF postal IS NULL THEN
                    INSERT INTO establishment.address(address_line_1,address_line_2,address_line_3,town,county,postcode)
                    VALUES(NULLIF(btrim(c.address_line_1),''),NULLIF(btrim(c.address_line_2),''),NULLIF(btrim(c.address_line_3),''),
                           NULLIF(btrim(c.town),''),NULLIF(btrim(c.county),''),NULLIF(btrim(c.postcode),'')) RETURNING address_id INTO postal;
                END IF;
                IF owner_kind='legal_entity' THEN
                    INSERT INTO establishment.legal_entity_address(legal_entity_id,address_id,address_purpose_id,start_date,end_date,is_current)
                    VALUES(owner_id,postal,purpose,NULL,NULL,true) RETURNING legal_entity_address_id INTO association;
                ELSE
                    INSERT INTO establishment.organisation_group_address(organisation_group_id,address_id,address_purpose_id,start_date,end_date,is_current)
                    VALUES(owner_id,postal,purpose,NULL,NULL,true) RETURNING organisation_group_address_id INTO association;
                END IF;
            END IF;
            decision:='source-'||c.source_address_block||'-'||purpose_code;
        ELSE decision:='blank-source-block'; END IF;
        INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_group_id,source_urn,source_row_hash)
        VALUES(snapshot,'EstablishmentGroup',c.source_group_id::text||':'||c.source_address_block,c.source_group_id::text,(config->>'urn')::integer,md5(raw::text))
        ON CONFLICT(source_snapshot_id,source_table,source_key) DO NOTHING;
        SELECT source_record_id INTO STRICT source_id FROM migration.source_record
        WHERE source_snapshot_id=snapshot AND source_table='EstablishmentGroup'
          AND source_key=c.source_group_id::text||':'||c.source_address_block;
        IF NOT EXISTS(SELECT 1 FROM migration.source_record WHERE source_record_id=source_id AND source_row_hash=md5(raw::text)) THEN
            RAISE EXCEPTION '% source changed within the same migration run',case_label;
        END IF;
        IF owner_kind='legal_entity' THEN
            INSERT INTO migration.group_address_evidence(source_record_id,legal_entity_id,legal_entity_address_id,
                source_address_block,raw_source_values,mapping_decision,notes)
            VALUES(source_id,owner_id,association,c.source_address_block,raw,decision,
                case_label||' reviewed fixture: '||(config->>'reviewEvidence'))
            ON CONFLICT(source_record_id) DO NOTHING;
        ELSIF owner_kind='organisation_group' THEN
            INSERT INTO migration.organisation_group_address_evidence(source_record_id,organisation_group_id,
                organisation_group_address_id,source_address_block,raw_source_values,mapping_decision,notes)
            VALUES(source_id,owner_id,association,c.source_address_block,raw,decision,
                case_label||' reviewed fixture: '||(config->>'reviewEvidence'))
            ON CONFLICT(source_record_id) DO NOTHING;
        ELSE
            INSERT INTO migration.person_address_evidence(source_record_id,person_id,
                source_address_block,raw_source_values,mapping_decision,notes)
            VALUES(source_id,owner_id,c.source_address_block,raw,decision,
                case_label||' reviewed fixture: '||(config->>'reviewEvidence'))
            ON CONFLICT(source_record_id) DO NOTHING;
        END IF;
    END LOOP;
END $$;
