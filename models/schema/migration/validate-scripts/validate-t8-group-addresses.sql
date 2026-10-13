-- T8 retains separate administrative addresses for former and current operators.
DO $$
DECLARE former_owner uuid; current_owner uuid; latest_run uuid;
BEGIN
    SELECT role.legal_entity_id INTO STRICT former_owner FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value='4920';
    SELECT role.legal_entity_id INTO STRICT current_owner FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value='3643';
    IF former_owner=current_owner OR (SELECT count(*) FROM establishment.legal_entity_address
       WHERE legal_entity_id IN(former_owner,current_owner) AND address_purpose_id=3 AND is_current)<>2 THEN
        RAISE EXCEPTION 'T8 requires separate current administrative addresses for both operators';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM establishment.legal_entity_address l JOIN establishment.address a USING(address_id)
       WHERE l.legal_entity_id=former_owner AND l.address_purpose_id=3 AND l.is_current
         AND a.address_line_1='Teign School Chudleigh Road' AND a.address_line_2='Kingsteignton'
         AND a.address_line_3 IS NULL AND a.town='Newton Abbot' AND a.county IS NULL AND a.postcode='TQ12 3JG')
       OR NOT EXISTS(SELECT 1 FROM establishment.legal_entity_address l JOIN establishment.address a USING(address_id)
       WHERE l.legal_entity_id=current_owner AND l.address_purpose_id=3 AND l.is_current
         AND a.address_line_1 IS NULL AND a.address_line_2='Balkwill Road'
         AND a.address_line_3 IS NULL AND a.town='Kingsbridge' AND a.county IS NULL AND a.postcode='TQ7 1PL') THEN
        RAISE EXCEPTION 'T8 target addresses do not match BAU';
    END IF;
    SELECT migration_run_id INTO latest_run FROM migration.migration_run
    WHERE run_type='group-addresses-t8' ORDER BY started_at DESC,migration_run_id DESC LIMIT 1;
    IF latest_run IS NULL OR (SELECT count(*) FROM migration.group_address_evidence evidence
       JOIN migration.source_record source USING(source_record_id) JOIN migration.source_snapshot snapshot USING(source_snapshot_id)
       WHERE snapshot.migration_run_id=latest_run AND source.source_group_id IN('4920','3643')
         AND evidence.legal_entity_id IN(former_owner,current_owner))<>4 THEN
        RAISE EXCEPTION 'T8 address evidence is incomplete';
    END IF;
END $$;
SELECT 'T8 group-address checks passed' AS result;

SELECT i.value AS gias_group_uid,le.name AS address_owner,p.code AS address_purpose,
       a.address_line_1,a.address_line_2,a.address_line_3,a.town,a.county,a.postcode,
       l.start_date,l.end_date,l.is_current
FROM establishment.group_identifier i
JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
JOIN establishment.legal_entity le USING(legal_entity_id)
LEFT JOIN establishment.legal_entity_address l USING(legal_entity_id)
LEFT JOIN establishment.address_purpose p USING(address_purpose_id)
LEFT JOIN establishment.address a USING(address_id)
WHERE t.name='Group UID' AND i.value IN('4920','3643')
ORDER BY i.value;
