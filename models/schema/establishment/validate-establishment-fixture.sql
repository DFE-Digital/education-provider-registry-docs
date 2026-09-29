-- Shared validation for the established core-Establishment fixture.
-- The establishment-party-role tables have their own bounded T20 fixture
-- and validation.
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
              'legal_entity',
              'organisation_identifier',
              'organisation_identifier_type',
              'person',
              'responsibility_type'
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
      'legal_entity',
      'organisation_identifier',
      'organisation_identifier_type',
      'person',
      'responsibility_type'
  )
ORDER BY table_name;
