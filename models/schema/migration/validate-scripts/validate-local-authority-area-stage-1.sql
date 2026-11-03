-- Stage 1: validate the local-authority-area rename on PostgreSQL.
-- Run this whole file against your migrated target (for example establishment_local).
-- Uses standard PostgreSQL SQL, so it works in psql or a SQL editor.
-- Read-only: it changes no schema or business data.
-- Counts below describe the approved 42-establishment migration fixture.
-- For a different selection, edit the expected counts; NULL skips a count check.

BEGIN ISOLATION LEVEL REPEATABLE READ READ ONLY;

DO $$
DECLARE
    expected_establishments integer := 42;
    expected_areas integer := 206;
    expected_contacts integer := 10;
    expected_region_mappings integer := 204;
    actual bigint;
    item record;
BEGIN
    expected_areas:=expected_areas+(SELECT count(DISTINCT l.entity_id)
        FROM migration.council_reorganisation_lineage l JOIN migration.council_reorganisation e USING(event_id)
        WHERE e.status='applied' AND l.entity_kind='local_authority_area' AND l.action='created');
    FOR item IN
        SELECT * FROM (VALUES
            ('local_authority_area'),
            ('local_authority_area_contact'),
            ('local_authority_area_government_office_region')
        ) AS required(table_name)
    LOOP
        IF to_regclass('establishment.' || item.table_name) IS NULL THEN
            RAISE EXCEPTION 'Stage 1: required table establishment.% is missing', item.table_name;
        END IF;
    END LOOP;

    IF to_regclass('establishment.local_authority') IS NOT NULL
       OR to_regclass('establishment.local_authority_contact') IS NOT NULL
       OR to_regclass('establishment.local_authority_government_office_region') IS NOT NULL THEN
        RAISE EXCEPTION 'Stage 1: a superseded local-authority table still exists';
    END IF;

    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'establishment'
          AND column_name IN ('local_authority_id', 'local_authority_contact_id')
    ) THEN
        RAISE EXCEPTION 'Stage 1: a superseded LA identifier column still exists';
    END IF;

    FOR item IN
        SELECT * FROM (VALUES
            ('establishment', expected_establishments),
            ('local_authority_area', expected_areas),
            ('local_authority_area_contact', expected_contacts),
            ('local_authority_area_government_office_region', expected_region_mappings)
        ) AS counts(table_name, expected)
    LOOP
        EXECUTE format('SELECT count(*) FROM establishment.%I', item.table_name) INTO actual;
        IF item.expected IS NOT NULL AND actual <> item.expected THEN
            RAISE EXCEPTION 'Stage 1: % has % rows; expected %', item.table_name, actual, item.expected;
        END IF;
        RAISE NOTICE 'Stage 1: % = % rows', item.table_name, actual;
    END LOOP;

    -- Every reference must still have a validated FK to the renamed area table.
    FOR item IN
        SELECT * FROM (VALUES
            ('establishment_geography'),
            ('organisation_group'),
            ('local_authority_area_contact'),
            ('local_authority_area_government_office_region')
        ) AS references_to_area(table_name)
    LOOP
        IF NOT EXISTS (
            SELECT 1
            FROM pg_constraint AS c
            JOIN pg_attribute AS a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
            WHERE c.contype = 'f' AND c.convalidated
              AND c.conrelid = to_regclass('establishment.' || item.table_name)
              AND c.confrelid = 'establishment.local_authority_area'::regclass
              AND a.attname = 'local_authority_area_id'
        ) THEN
            RAISE EXCEPTION 'Stage 1: %.local_authority_area_id lacks its validated area FK', item.table_name;
        END IF;
    END LOOP;

    IF EXISTS (
        SELECT 1 FROM establishment.establishment AS e
        LEFT JOIN establishment.establishment_geography AS g USING (establishment_id)
        LEFT JOIN establishment.local_authority_area AS a USING (local_authority_area_id)
        WHERE g.establishment_id IS NULL OR a.local_authority_area_id IS NULL
    ) THEN
        RAISE EXCEPTION 'Stage 1: a selected establishment has lost its geographic area';
    END IF;

    IF EXISTS (
        SELECT code FROM establishment.local_authority_area GROUP BY code HAVING count(*) > 1
    ) OR EXISTS (
        SELECT 1 FROM establishment.local_authority_area AS a
        LEFT JOIN establishment.local_authority_jurisdiction AS j USING (local_authority_jurisdiction_id)
        WHERE j.local_authority_jurisdiction_id IS NULL
    ) THEN
        RAISE EXCEPTION 'Stage 1: duplicate area codes or missing jurisdiction references';
    END IF;

    IF EXISTS (
        SELECT 1 FROM establishment.organisation_group
        WHERE (organisation_group_type_id IN (2, 3) AND local_authority_area_id IS NULL)
           OR (organisation_group_type_id = 1 AND local_authority_area_id IS NOT NULL)
    ) THEN
        RAISE EXCEPTION 'Stage 1: children''s-centre area or federation rules are broken';
    END IF;

    RAISE NOTICE 'PASS: Stage 1 LA-area structure, counts and relationships validated';
END
$$;

-- The area distribution includes English, Welsh and historical Pre LGR entries.
SELECT j.name AS jurisdiction, count(*) AS area_count
FROM establishment.local_authority_area AS a
JOIN establishment.local_authority_jurisdiction AS j USING (local_authority_jurisdiction_id)
GROUP BY j.name ORDER BY j.name;

-- Inspect the actual school -> area shape and retained LAESTAB.
-- This association does not assert maintenance by a council.
SELECT e.urn, e.name AS establishment_name, t.name AS establishment_type,
       a.code AS local_authority_code, a.name AS local_authority_area,
       a.code::text || '/' || lpad(e.establishment_number::text, 4, '0') AS laestab
FROM establishment.establishment AS e
JOIN establishment.establishment_type AS t USING (establishment_type_id)
JOIN establishment.establishment_geography AS g USING (establishment_id)
JOIN establishment.local_authority_area AS a USING (local_authority_area_id)
ORDER BY e.urn;

SELECT g.name AS organisation_group, t.name AS group_type,
       a.code AS local_authority_code, a.name AS local_authority_area
FROM establishment.organisation_group AS g
JOIN establishment.organisation_group_type AS t USING (organisation_group_type_id)
LEFT JOIN establishment.local_authority_area AS a USING (local_authority_area_id)
ORDER BY g.name;

SELECT 'PASS: Stage 1 LA-area structure, counts and relationships validated' AS validation_result;

COMMIT;
