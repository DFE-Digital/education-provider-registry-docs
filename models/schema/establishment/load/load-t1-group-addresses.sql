CREATE TEMP TABLE t1_address_fixture (
    source_group_id integer,source_type_code text,source_address_block text,
    address_line_1 text,address_line_2 text,address_line_3 text,town text,county text,postcode text,
    source_county_code text,source_country_code text,source_uprn text,source_site_name text
) ON COMMIT DROP;
\copy t1_address_fixture FROM '__FIXTURE_PATH__' WITH(FORMAT csv,HEADER true,DELIMITER '|',NULL 'NULL')
DO $$
DECLARE c record; party uuid; association uuid; postal uuid; purpose integer;
        run_id uuid; snapshot uuid; source_id uuid; raw jsonb; present boolean; decision text;
BEGIN
    IF (SELECT count(*) FROM t1_address_fixture)<>6
       OR (SELECT count(DISTINCT (source_group_id,source_address_block)) FROM t1_address_fixture)<>6
       OR EXISTS(SELECT 1 FROM t1_address_fixture WHERE source_group_id NOT IN(2777,2779,4949)
                 OR source_address_block NOT IN('primary','contact')
                 OR source_type_code IS DISTINCT FROM CASE source_group_id WHEN 2777 THEN '06' WHEN 2779 THEN '10' ELSE '05' END
                 OR county IS NOT NULL OR source_county_code IS DISTINCT FROM '099'
                 OR source_country_code IS DISTINCT FROM '00') THEN
        RAISE EXCEPTION 'T1 address source scope/reference codes changed; review required';
    END IF;
    run_id:=current_setting('epr.migration_run_id')::uuid;
    IF NOT EXISTS(SELECT 1 FROM migration.migration_run WHERE migration_run_id=run_id
                  AND run_type='group-addresses-t1' AND status='running') THEN
        RAISE EXCEPTION 'T1 addresses require a running scoped migration';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM establishment.establishment WHERE urn=136102) THEN
        RAISE EXCEPTION 'Load T1 establishment and parties before addresses';
    END IF;
    INSERT INTO migration.source_snapshot(migration_run_id,source_system,source_database,snapshot_date,extract_name)
    SELECT run_id,source_system,source_database,source_snapshot_date,'T1 group primary/contact addresses'
    FROM migration.migration_run r WHERE migration_run_id=run_id
      AND NOT EXISTS(SELECT 1 FROM migration.source_snapshot WHERE migration_run_id=run_id AND extract_name='T1 group primary/contact addresses');
    SELECT source_snapshot_id INTO STRICT snapshot FROM migration.source_snapshot
    WHERE migration_run_id=run_id AND extract_name='T1 group primary/contact addresses';
    FOR c IN SELECT * FROM t1_address_fixture ORDER BY source_group_id,source_address_block LOOP
        SELECT r.legal_entity_id INTO STRICT party FROM establishment.group_identifier i
        JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
        JOIN establishment.establishment_party_role r USING(establishment_party_role_id)
        WHERE t.name='Group UID' AND i.value=c.source_group_id::text;
        raw:=to_jsonb(c);
        present:=NULLIF(btrim(concat(c.address_line_1,c.address_line_2,c.address_line_3,c.town,c.county,c.postcode)),'') IS NOT NULL;
        association:=NULL; postal:=NULL;
        IF present THEN
            -- T1's reviewed observation has primary SAT/MAT blocks only.
            IF c.source_address_block<>'primary' OR c.source_group_id=4949 THEN
                RAISE EXCEPTION 'T1 newly populated address block requires review';
            END IF;
            purpose:=3;
            SELECT address_id,legal_entity_address_id INTO postal,association FROM establishment.legal_entity_address
            WHERE legal_entity_id=party AND address_purpose_id=purpose AND is_current FOR UPDATE;
            IF postal IS NOT NULL AND NOT EXISTS(SELECT 1 FROM establishment.address a WHERE address_id=postal
                AND ROW(a.address_line_1,a.address_line_2,a.address_line_3,a.town,a.county,a.postcode)
                    IS NOT DISTINCT FROM ROW(NULLIF(btrim(c.address_line_1),''),NULLIF(btrim(c.address_line_2),''),
                        NULLIF(btrim(c.address_line_3),''),NULLIF(btrim(c.town),''),NULLIF(btrim(c.county),''),NULLIF(btrim(c.postcode),''))) THEN
                RAISE EXCEPTION 'T1 existing address differs; manual migration decision required';
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
                INSERT INTO establishment.legal_entity_address(legal_entity_id,address_id,address_purpose_id,start_date,end_date,is_current)
                VALUES(party,postal,purpose,NULL,NULL,true) RETURNING legal_entity_address_id INTO association;
            END IF;
            decision:='source-primary-administrative';
        ELSE decision:='blank-source-block'; END IF;
        INSERT INTO migration.source_record(source_snapshot_id,source_table,source_key,source_group_id,source_urn,source_row_hash)
        VALUES(snapshot,'EstablishmentGroup',c.source_group_id::text||':'||c.source_address_block,c.source_group_id::text,136102,md5(raw::text))
        ON CONFLICT(source_snapshot_id,source_table,source_key) DO NOTHING;
        SELECT source_record_id INTO STRICT source_id FROM migration.source_record
        WHERE source_snapshot_id=snapshot AND source_table='EstablishmentGroup'
          AND source_key=c.source_group_id::text||':'||c.source_address_block;
        IF NOT EXISTS(SELECT 1 FROM migration.source_record WHERE source_record_id=source_id AND source_row_hash=md5(raw::text)) THEN
            RAISE EXCEPTION 'T1 source changed within the same migration run';
        END IF;
        INSERT INTO migration.group_address_evidence(source_record_id,legal_entity_id,legal_entity_address_id,
            source_address_block,raw_source_values,mapping_decision,notes)
        VALUES(source_id,party,association,c.source_address_block,raw,decision,
            'T1 bounded source mapping. Current administrative association with unknown business start/end dates, not observation dates. Primary address is not a verified registered office. Blank blocks create no address. County label lookup unavailable: county remains unknown; raw codes retained. No person contact fields extracted.')
        ON CONFLICT(source_record_id) DO NOTHING;
    END LOOP;
END $$;
