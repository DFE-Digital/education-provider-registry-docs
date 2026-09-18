BEGIN;

CREATE TEMP TABLE source_local_authority_gor_mapping_fixture (
    local_authority_code text,
    region_code text
) ON COMMIT DROP;

\copy source_local_authority_gor_mapping_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

INSERT INTO establishment.local_authority_government_office_region (
    local_authority_id,
    government_office_region_id
)
SELECT la.local_authority_id,
       gor.government_office_region_id
FROM source_local_authority_gor_mapping_fixture AS s
JOIN establishment.local_authority AS la
  ON la.code = NULLIF(BTRIM(s.local_authority_code), '')::integer
JOIN establishment.government_office_region AS gor
  ON gor.code = NULLIF(BTRIM(s.region_code), '')
ON CONFLICT (local_authority_id) DO UPDATE SET
    government_office_region_id = EXCLUDED.government_office_region_id;

COMMIT;
