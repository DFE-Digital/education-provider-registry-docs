-- Shared validation for the established core-Establishment fixture.
-- The establishment-party-role tables have their own bounded T1 fixture
-- and validation. Organisation groups, group identifiers and specialist/SEN
-- child tables are optional slices and are validated by their own fixtures or
-- source-specific assertions when populated.
DO $$
DECLARE
    r record;
    n bigint;
BEGIN
    FOR r IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'establishment'
          AND table_type = 'BASE TABLE'
          AND table_name NOT IN (
              'academy_trust_classification',
              'academy_trust_type',
              'establishment_party_role',
              'establishment_party_role_type',
              'establishment_responsibility',
              'group_identifier',
              'legal_entity',
              'organisation_group',
              'organisation_group_member',
              'organisation_identifier',
              'organisation_identifier_type',
              'person',
              'establishment_responsibility_type',
              'specialist_provision',
              'resourced_provision',
              'sen_unit_provision'
          )
        ORDER BY table_name
    LOOP
        EXECUTE format('SELECT count(*) FROM establishment.%I', r.table_name) INTO n;
        IF n = 0 THEN
            RAISE EXCEPTION 'Required establishment table is empty: %', r.table_name;
        END IF;
    END LOOP;
END
$$;

-- Test the identifier range without retaining any test rows. Each nested
-- block rolls back its insert through an intentionally raised exception.
DO $$
DECLARE
    test_urn integer;
    fixture_type integer;
BEGIN
    SELECT establishment_type_id INTO STRICT fixture_type
    FROM establishment.establishment LIMIT 1;

    FOREACH test_urn IN ARRAY ARRAY[1, 20001, 136102, 999999] LOOP
        BEGIN
            INSERT INTO establishment.establishment (urn, name, establishment_type_id)
            VALUES (test_urn, 'URN boundary test', fixture_type)
            ON CONFLICT (urn) DO NOTHING;
            RAISE EXCEPTION USING ERRCODE = 'ZX001', MESSAGE = 'Rollback accepted URN test';
        EXCEPTION WHEN SQLSTATE 'ZX001' THEN
            NULL;
        END;
    END LOOP;

    FOREACH test_urn IN ARRAY ARRAY[-1, 0, 1000000] LOOP
        BEGIN
            INSERT INTO establishment.establishment (urn, name, establishment_type_id)
            VALUES (test_urn, 'URN boundary test', fixture_type);
            RAISE EXCEPTION 'Invalid URN % was accepted', test_urn;
        EXCEPTION WHEN check_violation THEN
            NULL;
        END;
    END LOOP;
END
$$;

-- Identifier regression tests: all temporary entities/identifiers roll back.
DO $$
DECLARE
    first_owner uuid;
    second_owner uuid;
    identifier_id uuid;
    scheme integer;
    other_scheme integer;
BEGIN
    BEGIN
        SELECT organisation_identifier_type_id INTO STRICT scheme
        FROM establishment.organisation_identifier_type WHERE name = 'Companies House number';
        SELECT organisation_identifier_type_id INTO STRICT other_scheme
        FROM establishment.organisation_identifier_type WHERE name = 'UKPRN';
        INSERT INTO establishment.legal_entity (name) VALUES ('M1 test first owner') RETURNING legal_entity_id INTO first_owner;
        INSERT INTO establishment.legal_entity (name) VALUES ('M1 test second owner') RETURNING legal_entity_id INTO second_owner;
        INSERT INTO establishment.organisation_identifier (legal_entity_id, organisation_identifier_type_id, value)
        VALUES (first_owner, scheme, 'M1_TEST_ORIGINAL') RETURNING organisation_identifier_id INTO identifier_id;

        BEGIN
            INSERT INTO establishment.organisation_identifier (legal_entity_id, organisation_identifier_type_id, value)
            VALUES (first_owner, scheme, 'M1_TEST_SECOND');
            RAISE EXCEPTION 'M1 allowed two current identifiers for one owner and scheme';
        EXCEPTION WHEN unique_violation THEN NULL; END;

        BEGIN
            INSERT INTO establishment.organisation_identifier (legal_entity_id, organisation_identifier_type_id, value)
            VALUES (second_owner, scheme, 'M1_TEST_ORIGINAL');
            RAISE EXCEPTION 'M1 allowed duplicate current identifier ownership';
        EXCEPTION WHEN unique_violation THEN NULL; END;

        UPDATE establishment.organisation_identifier SET is_current = false WHERE organisation_identifier_id = identifier_id;
        INSERT INTO establishment.organisation_identifier (legal_entity_id, organisation_identifier_type_id, value)
        VALUES (first_owner, scheme, 'M1_TEST_REPLACEMENT');
        -- The same text in a different scheme is permitted.
        INSERT INTO establishment.organisation_identifier (legal_entity_id, organisation_identifier_type_id, value)
        VALUES (second_owner, other_scheme, 'M1_TEST_ORIGINAL');

        BEGIN
            INSERT INTO establishment.organisation_identifier (legal_entity_id, organisation_identifier_type_id, value)
            VALUES (second_owner, scheme, 'M1_TEST_ORIGINAL');
            RAISE EXCEPTION 'M1 allowed another owner to reuse a historical identifier';
        EXCEPTION WHEN unique_violation THEN NULL; END;
        BEGIN
            UPDATE establishment.organisation_identifier SET legal_entity_id = second_owner WHERE organisation_identifier_id = identifier_id;
            RAISE EXCEPTION 'M1 allowed ownership reassignment';
        EXCEPTION WHEN check_violation THEN NULL; END;
        BEGIN
            UPDATE establishment.organisation_identifier SET value = 'M1_TEST_REWRITE' WHERE organisation_identifier_id = identifier_id;
            RAISE EXCEPTION 'M1 allowed identifier value rewriting';
        EXCEPTION WHEN check_violation THEN NULL; END;
        BEGIN
            UPDATE establishment.organisation_identifier SET organisation_identifier_type_id = other_scheme WHERE organisation_identifier_id = identifier_id;
            RAISE EXCEPTION 'M1 allowed identifier scheme rewriting';
        EXCEPTION WHEN check_violation THEN NULL; END;
        BEGIN
            DELETE FROM establishment.organisation_identifier WHERE organisation_identifier_id = identifier_id;
            RAISE EXCEPTION 'M1 allowed deletion of ownership history';
        EXCEPTION WHEN check_violation THEN NULL; END;
        RAISE EXCEPTION USING ERRCODE = 'ZX001', MESSAGE = 'Rollback identifier tests';
    EXCEPTION WHEN SQLSTATE 'ZX001' THEN NULL;
    END;
END
$$;

SELECT table_name,
       ((xpath('/table/row/c/text()', query_to_xml(
           format('SELECT count(*) AS c FROM establishment.%I', table_name),
           true, false, '')))[1]::text)::bigint AS row_count
FROM information_schema.tables
WHERE table_schema = 'establishment'
  AND table_type = 'BASE TABLE'
  AND table_name NOT IN (
      'academy_trust_classification',
      'academy_trust_type',
      'establishment_party_role',
      'establishment_party_role_type',
      'establishment_responsibility',
      'group_identifier',
      'legal_entity',
      'organisation_group',
      'organisation_group_member',
      'organisation_identifier',
      'organisation_identifier_type',
      'person',
      'establishment_responsibility_type',
      'specialist_provision',
      'resourced_provision',
      'sen_unit_provision'
  )
ORDER BY table_name;
