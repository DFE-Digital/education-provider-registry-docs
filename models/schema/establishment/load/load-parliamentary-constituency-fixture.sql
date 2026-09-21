BEGIN;

CREATE TEMP TABLE source_parliamentary_constituency_fixture (
    code text,
    name text
) ON COMMIT DROP;

\copy source_parliamentary_constituency_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM source_parliamentary_constituency_fixture
        WHERE NULLIF(BTRIM(code), '') IS NOT NULL
          AND NULLIF(BTRIM(name), '') IS NULL
    ) THEN
        RAISE EXCEPTION 'Parliamentary Constituency fixture contains a code without a name';
    END IF;
END;
$$;

INSERT INTO establishment.parliamentary_constituency (code, name)
SELECT BTRIM(code), BTRIM(name)
FROM source_parliamentary_constituency_fixture
WHERE NULLIF(BTRIM(code), '') IS NOT NULL
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name;

COMMIT;
