-- T13 has one address for the separate Grantham academy trust, not the controlled proprietor.
DO $$
DECLARE trust_id uuid; latest_run uuid;
BEGIN
    SELECT role.legal_entity_id INTO STRICT trust_id FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value='3641';
    IF (SELECT count(*) FROM establishment.legal_entity_address WHERE legal_entity_id=trust_id AND address_purpose_id=3 AND is_current)<>1
       OR NOT EXISTS(SELECT 1 FROM establishment.legal_entity_address l JOIN establishment.address a USING(address_id)
         WHERE l.legal_entity_id=trust_id AND l.address_purpose_id=3 AND l.is_current
           AND a.address_line_1='The King''s School' AND a.address_line_2='Brook Street' AND a.address_line_3 IS NULL
           AND a.town='Grantham' AND a.county IS NULL AND a.postcode='NG31 6RP') THEN
        RAISE EXCEPTION 'T13 Grantham academy-trust address does not match BAU';
    END IF;
    SELECT migration_run_id INTO latest_run FROM migration.migration_run WHERE run_type='group-addresses-t13' ORDER BY started_at DESC,migration_run_id DESC LIMIT 1;
    IF latest_run IS NULL OR (SELECT count(*) FROM migration.group_address_evidence e JOIN migration.source_record s USING(source_record_id) JOIN migration.source_snapshot ss USING(source_snapshot_id)
      WHERE ss.migration_run_id=latest_run AND s.source_group_id='3641' AND e.legal_entity_id=trust_id)<>2 THEN
        RAISE EXCEPTION 'T13 address evidence is incomplete';
    END IF;
END $$;
SELECT 'T13 group-address checks passed' AS result;
