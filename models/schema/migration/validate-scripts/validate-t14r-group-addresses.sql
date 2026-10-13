-- T14R retains blank sponsor blocks and one separate academy-trust address.
DO $$
DECLARE sponsor_id uuid; trust_id uuid; latest_run uuid;
BEGIN
    SELECT role.legal_entity_id INTO STRICT sponsor_id FROM establishment.group_identifier i JOIN establishment.group_identifier_type t USING(group_identifier_type_id) JOIN establishment.establishment_party_role role USING(establishment_party_role_id) WHERE t.name='Group UID' AND i.value='2904';
    SELECT role.legal_entity_id INTO STRICT trust_id FROM establishment.group_identifier i JOIN establishment.group_identifier_type t USING(group_identifier_type_id) JOIN establishment.establishment_party_role role USING(establishment_party_role_id) WHERE t.name='Group UID' AND i.value='2905';
    IF sponsor_id=trust_id OR EXISTS(SELECT 1 FROM establishment.legal_entity_address WHERE legal_entity_id=sponsor_id)
       OR (SELECT count(*) FROM establishment.legal_entity_address WHERE legal_entity_id=trust_id AND address_purpose_id=3 AND is_current)<>1
       OR NOT EXISTS(SELECT 1 FROM establishment.legal_entity_address l JOIN establishment.address a USING(address_id) WHERE l.legal_entity_id=trust_id AND l.address_purpose_id=3 AND l.is_current AND a.address_line_1='Grace Building' AND a.address_line_2='8 High Street' AND a.address_line_3 IS NULL AND a.town='Ely' AND a.county IS NULL AND a.postcode='CB7 4JU') THEN
        RAISE EXCEPTION 'T14R sponsor/trust addresses do not match BAU';
    END IF;
    SELECT migration_run_id INTO latest_run FROM migration.migration_run WHERE run_type='group-addresses-t14r' ORDER BY started_at DESC,migration_run_id DESC LIMIT 1;
    IF latest_run IS NULL OR (SELECT count(*) FROM migration.group_address_evidence e JOIN migration.source_record s USING(source_record_id) JOIN migration.source_snapshot ss USING(source_snapshot_id) WHERE ss.migration_run_id=latest_run AND s.source_group_id IN('2904','2905') AND e.legal_entity_id IN(sponsor_id,trust_id))<>4 THEN
        RAISE EXCEPTION 'T14R address evidence is incomplete';
    END IF;
END $$;
SELECT 'T14R group-address checks passed' AS result;
