-- T6 has two blank foundation-trust address blocks.
DO $$
DECLARE owner uuid; latest_run uuid;
BEGIN
    SELECT role.legal_entity_id INTO STRICT owner
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
    JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='1337';
    IF EXISTS(SELECT 1 FROM establishment.legal_entity_address WHERE legal_entity_id=owner) THEN
        RAISE EXCEPTION 'T6 blank source blocks must not create legal-entity address associations';
    END IF;
    SELECT migration_run_id INTO latest_run FROM migration.migration_run
    WHERE run_type='group-addresses-t6' ORDER BY started_at DESC,migration_run_id DESC LIMIT 1;
    IF latest_run IS NULL OR (SELECT count(*) FROM migration.group_address_evidence evidence
        JOIN migration.source_record source USING(source_record_id)
        JOIN migration.source_snapshot snapshot USING(source_snapshot_id)
        WHERE snapshot.migration_run_id=latest_run AND source.source_group_id='1337'
          AND evidence.legal_entity_id=owner AND evidence.legal_entity_address_id IS NULL
          AND evidence.mapping_decision='blank-source-block'
          AND evidence.raw_source_values->>'source_type_code'='02'
          AND evidence.raw_source_values->>'source_county_code'='099'
          AND evidence.raw_source_values->>'source_country_code'='00'
          AND evidence.raw_source_values->>'address_line_1' IS NULL
          AND evidence.raw_source_values->>'postcode' IS NULL
          AND evidence.source_address_block IN('primary','contact'))<>2 THEN
        RAISE EXCEPTION 'T6 blank address evidence is incomplete or changed';
    END IF;
END $$;
SELECT 'T6 group-address checks passed' AS result;

SELECT le.name AS address_owner,i.value AS gias_group_uid,
       CASE WHEN link.legal_entity_address_id IS NULL THEN 'No address association'
            ELSE 'Address association recorded' END AS address_status,
       purpose.code AS address_purpose,a.address_line_1,a.address_line_2,a.address_line_3,
       a.town,a.county,a.postcode,link.start_date,link.end_date,link.is_current,
       (SELECT count(*) FROM migration.group_address_evidence evidence
        WHERE evidence.legal_entity_id=le.legal_entity_id) AS source_address_blocks_retained
FROM establishment.group_identifier i
JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
JOIN establishment.legal_entity le USING(legal_entity_id)
LEFT JOIN establishment.legal_entity_address link USING(legal_entity_id)
LEFT JOIN establishment.address_purpose purpose USING(address_purpose_id)
LEFT JOIN establishment.address a USING(address_id)
WHERE t.name='Group UID' AND i.value='1337';
