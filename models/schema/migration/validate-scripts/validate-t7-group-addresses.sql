-- T7 retains blank person-sponsor blocks and one operating-trust primary address.
DO $$
DECLARE sponsor uuid; trust uuid; latest_run uuid;
BEGIN
    SELECT role.person_id INTO STRICT sponsor FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value='2613';
    SELECT role.legal_entity_id INTO STRICT trust FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value='3147';
    IF (SELECT count(*) FROM establishment.legal_entity_address
        WHERE legal_entity_id=trust AND is_current AND address_purpose_id=3)<>1
       OR EXISTS(SELECT 1 FROM establishment.legal_entity_address
                 WHERE legal_entity_id=trust AND address_purpose_id<>3) THEN
        RAISE EXCEPTION 'T7 requires one administrative address for the operating trust';
    END IF;
    SELECT migration_run_id INTO latest_run FROM migration.migration_run
    WHERE run_type='group-addresses-t7' ORDER BY started_at DESC,migration_run_id DESC LIMIT 1;
    IF latest_run IS NULL OR (SELECT count(*) FROM migration.person_address_evidence evidence
        JOIN migration.source_record source USING(source_record_id)
        JOIN migration.source_snapshot snapshot USING(source_snapshot_id)
        WHERE snapshot.migration_run_id=latest_run AND source.source_group_id='2613'
          AND evidence.person_id=sponsor AND evidence.mapping_decision='blank-source-block'
          AND evidence.raw_source_values->>'source_type_code'='05'
          AND evidence.raw_source_values->>'address_line_1' IS NULL
          AND evidence.raw_source_values->>'postcode' IS NULL
          AND evidence.source_address_block IN('primary','contact'))<>2 THEN
        RAISE EXCEPTION 'T7 person-sponsor blank address evidence is incomplete';
    END IF;
    IF (SELECT count(*) FROM migration.group_address_evidence evidence
        JOIN migration.source_record source USING(source_record_id)
        JOIN migration.source_snapshot snapshot USING(source_snapshot_id)
        WHERE snapshot.migration_run_id=latest_run AND source.source_group_id='3147'
          AND evidence.legal_entity_id=trust)<>2 THEN
        RAISE EXCEPTION 'T7 operating-trust address evidence is incomplete';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM migration.group_address_evidence evidence
        JOIN migration.source_record source USING(source_record_id)
        JOIN migration.source_snapshot snapshot USING(source_snapshot_id)
        JOIN establishment.legal_entity_address link USING(legal_entity_address_id)
        JOIN establishment.address a USING(address_id)
        WHERE snapshot.migration_run_id=latest_run AND source.source_group_id='3147'
          AND evidence.source_address_block='primary'
          AND evidence.mapping_decision='source-primary-administrative'
          AND link.legal_entity_id=trust AND link.address_purpose_id=3
          AND link.is_current AND link.start_date IS NULL AND link.end_date IS NULL
          AND a.address_line_1='Dunstone Education Trust Black Bull Lane'
          AND a.address_line_2='Fulwood' AND a.address_line_3 IS NULL
          AND a.town='Preston' AND a.county IS NULL AND a.postcode='PR2 9YR') THEN
        RAISE EXCEPTION 'T7 operating-trust address does not match BAU';
    END IF;
END $$;
SELECT 'T7 group-address checks passed' AS result;

SELECT le.name AS address_owner,i.value AS gias_group_uid,
       purpose.code AS address_purpose,a.address_line_1,a.address_line_2,a.address_line_3,
       a.town,a.county,a.postcode,link.start_date,link.end_date,link.is_current
FROM establishment.group_identifier i
JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
JOIN establishment.legal_entity le USING(legal_entity_id)
LEFT JOIN establishment.legal_entity_address link USING(legal_entity_id)
LEFT JOIN establishment.address_purpose purpose USING(address_purpose_id)
LEFT JOIN establishment.address a USING(address_id)
WHERE t.name='Group UID' AND i.value='3147';
