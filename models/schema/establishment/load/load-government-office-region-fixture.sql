-- PostgreSQL loader for the complete Government Office Region fixture.

BEGIN;

CREATE TEMP TABLE source_government_office_region_fixture (
    code text,
    name text
) ON COMMIT DROP;

\copy source_government_office_region_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

-- The source code is an integration value and may contain letters (for
-- example A, B, H, W and Z). Do not coerce it to an integer. Fail before the
-- upsert if a non-sentinel establishment code has no usable label.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM source_government_office_region_fixture
        WHERE NULLIF(BTRIM(code), '') IS NOT NULL
          AND BTRIM(code) <> '0'
          AND NULLIF(BTRIM(name), '') IS NULL
    ) THEN
        RAISE EXCEPTION 'Government Office Region fixture contains a code without a name';
    END IF;
END;
$$;

INSERT INTO establishment.government_office_region (code, name)
SELECT NULLIF(BTRIM(code), ''), NULLIF(BTRIM(name), '')
FROM source_government_office_region_fixture
WHERE NULLIF(BTRIM(code), '') IS NOT NULL
  AND BTRIM(code) <> '0'
  AND NULLIF(BTRIM(name), '') IS NOT NULL
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name;

COMMIT;
