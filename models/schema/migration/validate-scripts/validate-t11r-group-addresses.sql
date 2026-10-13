-- T11R's accepted sponsor/trust identity has one Oasis administrative address.
DO $$
DECLARE owner_id uuid; latest_run uuid;
BEGIN
    SELECT DISTINCT role.legal_entity_id INTO STRICT owner_id FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value IN('4075','4076');
    IF owner_id IS NULL OR (SELECT count(DISTINCT role.legal_entity_id) FROM establishment.group_identifier i
       JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
       JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
       WHERE t.name='Group UID' AND i.value IN('4075','4076'))<>1
       OR (SELECT count(*) FROM establishment.legal_entity_address WHERE legal_entity_id=owner_id
           AND address_purpose_id=3 AND is_current)<>1 THEN
        RAISE EXCEPTION 'T11R requires one shared Oasis administrative address';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM establishment.legal_entity_address l JOIN establishment.address a USING(address_id)
       WHERE l.legal_entity_id=owner_id AND l.address_purpose_id=3 AND l.is_current
         AND a.address_line_1='75 Westminster Bridge Road' AND a.address_line_2 IS NULL
         AND a.address_line_3 IS NULL AND a.town='London' AND a.county IS NULL AND a.postcode='SE1 7HS') THEN
        RAISE EXCEPTION 'T11R Oasis address does not match BAU';
    END IF;
    SELECT migration_run_id INTO latest_run FROM migration.migration_run
    WHERE run_type='group-addresses-t11r' ORDER BY started_at DESC,migration_run_id DESC LIMIT 1;
    IF latest_run IS NULL OR (SELECT count(*) FROM migration.group_address_evidence evidence
       JOIN migration.source_record source USING(source_record_id) JOIN migration.source_snapshot snapshot USING(source_snapshot_id)
       WHERE snapshot.migration_run_id=latest_run AND source.source_group_id IN('4075','4076')
         AND evidence.legal_entity_id=owner_id)<>4 THEN
        RAISE EXCEPTION 'T11R address evidence is incomplete';
    END IF;
END $$;
SELECT 'T11R group-address checks passed' AS result;
