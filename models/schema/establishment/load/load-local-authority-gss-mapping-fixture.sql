BEGIN;

CREATE TEMP TABLE source_local_authority_gss_mapping_fixture (
    local_authority_code text,
    gss_code text
) ON COMMIT DROP;

\copy source_local_authority_gss_mapping_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

UPDATE establishment.local_authority AS la
SET gss_local_authority_code_id = gss.id
FROM source_local_authority_gss_mapping_fixture AS s
JOIN establishment.gss_local_authority_code AS gss
  ON gss.code = NULLIF(BTRIM(s.gss_code), '')
WHERE la.code = NULLIF(BTRIM(s.local_authority_code), '')::integer
;

COMMIT;
