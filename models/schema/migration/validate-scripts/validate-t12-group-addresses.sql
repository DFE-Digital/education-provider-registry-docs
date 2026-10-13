-- T12 has two blank provisional foundation-trust address blocks.
DO $$
DECLARE owner_id uuid; latest_run uuid;
BEGIN
    SELECT role.legal_entity_id INTO STRICT owner_id FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value='1193';
    IF EXISTS(SELECT 1 FROM establishment.legal_entity_address WHERE legal_entity_id=owner_id) THEN
        RAISE EXCEPTION 'T12 blank source blocks must not create a foundation-trust address';
    END IF;
    SELECT migration_run_id INTO latest_run FROM migration.migration_run
    WHERE run_type='group-addresses-t12' ORDER BY started_at DESC,migration_run_id DESC LIMIT 1;
    IF latest_run IS NULL OR (SELECT count(*) FROM migration.group_address_evidence evidence
       JOIN migration.source_record source USING(source_record_id) JOIN migration.source_snapshot snapshot USING(source_snapshot_id)
       WHERE snapshot.migration_run_id=latest_run AND source.source_group_id='1193'
         AND evidence.legal_entity_id=owner_id AND evidence.legal_entity_address_id IS NULL
         AND evidence.mapping_decision='blank-source-block'
         AND evidence.raw_source_values->>'address_line_1' IS NULL
         AND evidence.raw_source_values->>'postcode' IS NULL)<>2 THEN
        RAISE EXCEPTION 'T12 blank address evidence is incomplete';
    END IF;
END $$;
SELECT 'T12 group-address checks passed' AS result;
