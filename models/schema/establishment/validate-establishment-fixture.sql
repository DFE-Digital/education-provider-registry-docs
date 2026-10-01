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
              'responsibility_type',
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
      'responsibility_type',
      'specialist_provision',
      'resourced_provision',
      'sen_unit_provision'
  )
ORDER BY table_name;
