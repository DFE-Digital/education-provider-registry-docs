DO $$
DECLARE parties uuid[]; latest_run uuid;
BEGIN
    SELECT array_agg(r.legal_entity_id) INTO parties FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.establishment_party_role r USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value IN('2777','2779','4949');
    IF cardinality(parties)<>3 OR (SELECT count(DISTINCT p) FROM unnest(parties) p)<>3 THEN
        RAISE EXCEPTION 'T1 address owners must remain three distinct parties';
    END IF;
    IF (SELECT count(*) FROM establishment.legal_entity_address WHERE legal_entity_id=ANY(parties) AND is_current)<>2
       OR EXISTS(SELECT 1 FROM establishment.legal_entity_address WHERE legal_entity_id=ANY(parties) AND address_purpose_id<>3) THEN
        RAISE EXCEPTION 'T1 requires two administrative associations, with no invented registered/contact addresses';
    END IF;
    IF EXISTS(SELECT 1 FROM establishment.legal_entity_address a JOIN establishment.establishment_party_role r USING(legal_entity_id)
              JOIN establishment.group_identifier i USING(establishment_party_role_id)
              WHERE i.value='4949') THEN RAISE EXCEPTION 'T1 sponsor address was invented'; END IF;
    SELECT migration_run_id INTO latest_run FROM migration.migration_run WHERE run_type='group-addresses-t1'
    ORDER BY started_at DESC,migration_run_id DESC LIMIT 1;
    IF latest_run IS NULL OR (SELECT count(*) FROM migration.group_address_evidence e
        JOIN migration.source_record r USING(source_record_id) JOIN migration.source_snapshot s USING(source_snapshot_id)
        WHERE s.migration_run_id=latest_run)<>6 THEN RAISE EXCEPTION 'T1 six source address blocks must retain provenance'; END IF;
    IF (SELECT count(*) FROM migration.group_address_evidence e JOIN migration.source_record r USING(source_record_id)
        JOIN migration.source_snapshot s USING(source_snapshot_id) WHERE s.migration_run_id=latest_run
        AND e.mapping_decision='blank-source-block' AND e.legal_entity_address_id IS NULL)<>4 THEN
        RAISE EXCEPTION 'T1 missing-address evidence is incorrect';
    END IF;
    IF (SELECT count(*) FROM migration.group_address_evidence e
        JOIN migration.source_record r USING(source_record_id) JOIN migration.source_snapshot s USING(source_snapshot_id)
        JOIN establishment.legal_entity_address link USING(legal_entity_address_id) JOIN establishment.address a USING(address_id)
        WHERE s.migration_run_id=latest_run AND e.mapping_decision='source-primary-administrative'
          AND link.legal_entity_id=e.legal_entity_id AND link.address_purpose_id=3 AND a.county IS NULL
          AND link.is_current AND link.start_date IS NULL AND link.end_date IS NULL
          AND ROW(a.address_line_1,a.address_line_2,a.address_line_3,a.town,a.postcode)
              IS NOT DISTINCT FROM ROW(NULLIF(btrim(e.raw_source_values->>'address_line_1'),''),NULLIF(btrim(e.raw_source_values->>'address_line_2'),''),
                    NULLIF(btrim(e.raw_source_values->>'address_line_3'),''),NULLIF(btrim(e.raw_source_values->>'town'),''),NULLIF(btrim(e.raw_source_values->>'postcode'),'')))<>2 THEN
        RAISE EXCEPTION 'T1 target addresses do not agree with retained source assertions';
    END IF;
END $$;
SELECT 'T1 group-address checks passed' AS result;
