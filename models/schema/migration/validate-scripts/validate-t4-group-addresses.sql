-- T4 has two blank federation address blocks. Preserve them as evidence only.
DO $$
DECLARE federation_id uuid; latest_run uuid;
BEGIN
    SELECT i.organisation_group_id INTO STRICT federation_id
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='1809'
      AND i.establishment_party_role_id IS NULL;
    IF (SELECT count(*) FROM establishment.organisation_group_member m
        JOIN establishment.establishment e USING(establishment_id)
        WHERE m.organisation_group_id=federation_id AND e.urn IN(109443,109613))<>2 THEN
        RAISE EXCEPTION 'T4 federation members changed';
    END IF;
    IF EXISTS(SELECT 1 FROM establishment.organisation_group_address
              WHERE organisation_group_id=federation_id) THEN
        RAISE EXCEPTION 'T4 blank source blocks must not create federation address associations';
    END IF;
    SELECT migration_run_id INTO latest_run FROM migration.migration_run
    WHERE run_type='group-addresses-t4' ORDER BY started_at DESC,migration_run_id DESC LIMIT 1;
    IF latest_run IS NULL OR (SELECT count(*) FROM migration.organisation_group_address_evidence evidence
        JOIN migration.source_record source USING(source_record_id)
        JOIN migration.source_snapshot snapshot USING(source_snapshot_id)
        WHERE snapshot.migration_run_id=latest_run
          AND source.source_group_id='1809' AND source.source_urn IS NULL
          AND evidence.organisation_group_id=federation_id
          AND evidence.organisation_group_address_id IS NULL
          AND evidence.mapping_decision='blank-source-block'
          AND evidence.raw_source_values->>'source_type_code'='01'
          AND evidence.raw_source_values->>'source_county_code'='099'
          AND evidence.raw_source_values->>'source_country_code'='00'
          AND evidence.raw_source_values->>'address_line_1' IS NULL
          AND evidence.raw_source_values->>'postcode' IS NULL
          AND evidence.source_address_block IN('primary','contact'))<>2 THEN
        RAISE EXCEPTION 'T4 blank address source evidence is incomplete or changed';
    END IF;
END $$;
SELECT 'T4 group-address checks passed' AS result;

SELECT 'T4' AS test_case,g.name AS federation_name,i.value AS gias_group_uid,
       CASE WHEN link.organisation_group_address_id IS NULL
            THEN 'No address association' ELSE 'Address association recorded' END AS address_status,
       purpose.code AS address_purpose,link.organisation_group_address_id,link.address_id,
       a.address_line_1,a.address_line_2,a.address_line_3,a.town,a.county,a.postcode,
       link.start_date,link.end_date,link.is_current,
       (SELECT count(*) FROM migration.organisation_group_address_evidence evidence
        WHERE evidence.organisation_group_id=g.organisation_group_id) AS source_address_blocks_retained
FROM establishment.organisation_group g
JOIN establishment.group_identifier i USING(organisation_group_id)
JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
LEFT JOIN establishment.organisation_group_address link USING(organisation_group_id)
LEFT JOIN establishment.address_purpose purpose USING(address_purpose_id)
LEFT JOIN establishment.address a USING(address_id)
WHERE t.name='Group UID' AND i.value='1809'
ORDER BY purpose.code,link.start_date NULLS FIRST;
