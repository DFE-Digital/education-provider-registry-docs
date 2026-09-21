BEGIN;

CREATE TEMP TABLE source_administrative_ward_fixture (
    code text,
    name text
) ON COMMIT DROP;

\copy source_administrative_ward_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM source_administrative_ward_fixture
        WHERE NULLIF(BTRIM(code), '') IS NOT NULL
          AND NULLIF(BTRIM(name), '') IS NULL
    ) THEN
        RAISE EXCEPTION 'Administrative Ward fixture contains a code without a name';
    END IF;
END;
$$;

INSERT INTO establishment.administrative_ward (code, name)
SELECT BTRIM(code), BTRIM(name)
FROM source_administrative_ward_fixture
WHERE NULLIF(BTRIM(code), '') IS NOT NULL
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name;

COMMIT;
