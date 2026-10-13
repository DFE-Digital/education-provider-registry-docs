-- T15R's closed SAT retains its source address without inferring an end date.
DO $$
DECLARE owner_id uuid; latest_run uuid;
BEGIN
    SELECT role.legal_entity_id INTO STRICT owner_id FROM establishment.group_identifier i JOIN establishment.group_identifier_type t USING(group_identifier_type_id) JOIN establishment.establishment_party_role role USING(establishment_party_role_id) WHERE t.name='Group UID' AND i.value='2347';
    IF (SELECT count(*) FROM establishment.legal_entity_address WHERE legal_entity_id=owner_id AND address_purpose_id=3 AND is_current AND start_date IS NULL AND end_date IS NULL)<>1
       OR NOT EXISTS(SELECT 1 FROM establishment.legal_entity_address l JOIN establishment.address a USING(address_id) WHERE l.legal_entity_id=owner_id AND l.address_purpose_id=3 AND l.is_current AND a.address_line_1='Walsall College' AND a.address_line_2='Littleton Street West' AND a.address_line_3 IS NULL AND a.town='Walsall' AND a.county IS NULL AND a.postcode='WS2 8ES') THEN
        RAISE EXCEPTION 'T15R Black Country UTC address does not match BAU';
    END IF;
    SELECT migration_run_id INTO latest_run FROM migration.migration_run WHERE run_type='group-addresses-t15r' ORDER BY started_at DESC,migration_run_id DESC LIMIT 1;
    IF latest_run IS NULL OR (SELECT count(*) FROM migration.group_address_evidence e JOIN migration.source_record s USING(source_record_id) JOIN migration.source_snapshot ss USING(source_snapshot_id) WHERE ss.migration_run_id=latest_run AND s.source_group_id='2347' AND e.legal_entity_id=owner_id)<>2 THEN
        RAISE EXCEPTION 'T15R address evidence is incomplete';
    END IF;
END $$;
SELECT 'T15R group-address checks passed' AS result;
