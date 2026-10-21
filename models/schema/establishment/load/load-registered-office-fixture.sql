-- Included inside a caller-owned transaction. The checked-in source extract
-- records a Companies House observation; it does not invent address-use dates.
DO $$
DECLARE
    raw_json text := '__REVIEWED_FIXTURE_JSON__';
    expected_hash text := '__REVIEWED_FIXTURE_SHA256__';
    config jsonb;
    owner_id uuid;
    postal_id uuid;
    association_id uuid;
    purpose_id integer;
    run_id uuid;
    snapshot_id uuid;
    record_id uuid;
    source_date date;
BEGIN
    IF encode(digest(raw_json,'sha256'),'hex') IS DISTINCT FROM expected_hash THEN
        RAISE EXCEPTION 'Registered-office fixture changed; review required';
    END IF;
    config := raw_json::jsonb;
    IF config->>'reviewStatus' IS DISTINCT FROM 'accepted'
       OR config->>'mode' IS DISTINCT FROM 'registered-office-observation'
       OR NULLIF(btrim(config->>'reviewEvidence'),'') IS NULL
       OR config->>'sourceSystem' IS DISTINCT FROM 'Companies House'
       OR config->>'sourceField' IS DISTINCT FROM 'registered_office_address'
       OR config->>'sourceUrl' IS DISTINCT FROM
          'https://find-and-update.company-information.service.gov.uk/company/' || (config->>'companyNumber')
       OR NULLIF(btrim(config->>'companyNumber'),'') IS NULL
       OR NULLIF(btrim(config->>'sourceAddressText'),'') IS NULL
       OR NULLIF(btrim(config#>>'{address,address_line_1}'),'') IS NULL
       OR NULLIF(btrim(config#>>'{address,town}'),'') IS NULL
       OR NULLIF(btrim(config#>>'{address,postcode}'),'') IS NULL THEN
        RAISE EXCEPTION 'Registered-office purpose or source evidence is incomplete; review required';
    END IF;
    source_date := (config->>'observedOn')::date;
    IF source_date IS NULL THEN RAISE EXCEPTION 'Registered-office observation date is required'; END IF;

    SELECT i.legal_entity_id INTO owner_id
    FROM establishment.organisation_identifier i
    JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
    JOIN establishment.legal_entity e USING(legal_entity_id)
    WHERE t.name='Companies House number' AND i.value=config->>'companyNumber'
      AND i.is_current AND e.name=config->>'legalEntityName';
    IF owner_id IS NULL THEN
        RAISE EXCEPTION 'Registered-office company number/name does not resolve to an existing legal entity';
    END IF;
    SELECT address_purpose_id INTO STRICT purpose_id
    FROM establishment.address_purpose WHERE code='registered';
    SELECT l.address_id,l.legal_entity_address_id INTO postal_id,association_id
    FROM establishment.legal_entity_address l
    WHERE l.legal_entity_id=owner_id AND l.address_purpose_id=purpose_id AND l.is_current
    FOR UPDATE;
    IF postal_id IS NOT NULL AND NOT EXISTS(
        SELECT 1 FROM establishment.address a WHERE a.address_id=postal_id
        AND ROW(a.address_line_1,a.address_line_2,a.address_line_3,a.town,a.county,a.postcode)
            IS NOT DISTINCT FROM ROW(config#>>'{address,address_line_1}',config#>>'{address,address_line_2}',
                config#>>'{address,address_line_3}',config#>>'{address,town}',
                config#>>'{address,county}',config#>>'{address,postcode}')
    ) THEN RAISE EXCEPTION 'Existing registered office differs; review the change and its business dates'; END IF;
    IF postal_id IS NULL THEN
        SELECT a.address_id INTO postal_id FROM establishment.address a
        WHERE ROW(a.address_line_1,a.address_line_2,a.address_line_3,a.town,a.county,a.postcode)
            IS NOT DISTINCT FROM ROW(config#>>'{address,address_line_1}',config#>>'{address,address_line_2}',
                config#>>'{address,address_line_3}',config#>>'{address,town}',
                config#>>'{address,county}',config#>>'{address,postcode}')
        ORDER BY a.address_id LIMIT 1;
        IF postal_id IS NULL THEN
            INSERT INTO establishment.address(address_line_1,address_line_2,address_line_3,town,county,postcode)
            VALUES(config#>>'{address,address_line_1}',config#>>'{address,address_line_2}',
                config#>>'{address,address_line_3}',config#>>'{address,town}',
                config#>>'{address,county}',config#>>'{address,postcode}')
            RETURNING address_id INTO postal_id;
        END IF;
        INSERT INTO establishment.legal_entity_address
            (legal_entity_id,address_id,address_purpose_id,start_date,end_date,is_current)
        VALUES(owner_id,postal_id,purpose_id,NULL,NULL,true)
        RETURNING legal_entity_address_id INTO association_id;
    END IF;

    run_id := md5('companies-house-registered-office:' || expected_hash)::uuid;
    INSERT INTO migration.migration_run
        (migration_run_id,run_type,source_system,source_database,source_snapshot_date,status,transform_version,notes)
    VALUES(run_id,'companies-house-registered-office','Companies House',NULL,source_date,
           'running','registered-office-v1',config->>'reviewEvidence')
    ON CONFLICT(migration_run_id) DO NOTHING;
    SELECT source_snapshot_id INTO snapshot_id FROM migration.source_snapshot
    WHERE migration_run_id=run_id AND extract_name=config->>'sourceUrl';
    IF snapshot_id IS NULL THEN
        INSERT INTO migration.source_snapshot(migration_run_id,source_system,snapshot_date,extract_name)
        VALUES(run_id,'Companies House',source_date,config->>'sourceUrl')
        RETURNING source_snapshot_id INTO snapshot_id;
    END IF;
    INSERT INTO migration.source_record
        (source_snapshot_id,source_table,source_key,source_row_hash)
    VALUES(snapshot_id,'company_profile',(config->>'companyNumber') || ':registered_office_address',expected_hash)
    ON CONFLICT(source_snapshot_id,source_table,source_key) DO NOTHING;
    SELECT source_record_id INTO STRICT record_id FROM migration.source_record
    WHERE source_snapshot_id=snapshot_id AND source_table='company_profile'
      AND source_key=(config->>'companyNumber') || ':registered_office_address';
    INSERT INTO migration.group_address_evidence
        (source_record_id,legal_entity_id,legal_entity_address_id,source_address_block,
         raw_source_values,mapping_decision,notes)
    VALUES(record_id,owner_id,association_id,'registered_office',config,
           'companies-house-registered-office',
           'Company number match and explicitly published registered-office purpose. Observed on ' ||
           source_date::text || '; business dates unknown. Source: ' || (config->>'sourceUrl'))
    ON CONFLICT(source_record_id) DO NOTHING;
    UPDATE migration.migration_run SET status='completed',completed_at=now()
    WHERE migration_run_id=run_id AND status='running';
END $$;
