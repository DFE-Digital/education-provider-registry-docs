BEGIN;

CREATE TEMP TABLE source_district_administrative_fixture (
    code text,
    name text,
    archived integer
) ON COMMIT DROP;

\copy source_district_administrative_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM source_district_administrative_fixture
        WHERE NULLIF(BTRIM(code), '') IS NOT NULL
          AND NULLIF(BTRIM(name), '') IS NULL
    ) THEN
        RAISE EXCEPTION 'District Administrative fixture contains a code without a name';
    END IF;
END;
$$;

INSERT INTO establishment.district_administrative (code, name, archived)
SELECT BTRIM(code), BTRIM(name), archived <> 0
FROM source_district_administrative_fixture
WHERE NULLIF(BTRIM(code), '') IS NOT NULL
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    archived = EXCLUDED.archived;

COMMIT;
