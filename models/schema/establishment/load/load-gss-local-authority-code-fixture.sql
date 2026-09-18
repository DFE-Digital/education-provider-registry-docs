BEGIN;

CREATE TEMP TABLE source_gss_local_authority_code_fixture (
    code text
) ON COMMIT DROP;

\copy source_gss_local_authority_code_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

INSERT INTO establishment.gss_local_authority_code (code)
SELECT NULLIF(BTRIM(code), '')
FROM source_gss_local_authority_code_fixture
WHERE NULLIF(BTRIM(code), '') IS NOT NULL
ON CONFLICT (code) DO NOTHING;

COMMIT;
