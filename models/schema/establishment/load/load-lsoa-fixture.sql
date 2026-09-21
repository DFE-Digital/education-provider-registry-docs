BEGIN;
CREATE TEMP TABLE source_lsoa_fixture (code text, name text) ON COMMIT DROP;
\copy source_lsoa_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM source_lsoa_fixture WHERE NULLIF(BTRIM(code), '') IS NOT NULL AND NULLIF(BTRIM(name), '') IS NULL) THEN
        RAISE EXCEPTION 'LSOA fixture contains a code without a name';
    END IF;
END;
$$;
INSERT INTO establishment.lsoa (code, name)
SELECT BTRIM(code), BTRIM(name) FROM source_lsoa_fixture
WHERE NULLIF(BTRIM(code), '') IS NOT NULL
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name;
COMMIT;
