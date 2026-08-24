-- PostgreSQL target load for the local Governance appointment-and-term fixture.
-- The PowerShell runner substitutes __FIXTURE_PATH__ with a local path before
-- invoking psql. The source extract is pipe-delimited CSV with a header row.
-- This loader accepts no person, contact or appointing-body data.

BEGIN;

CREATE TEMP TABLE source_governance_appointment_fixture (
    governance_appointment_id uuid NOT NULL DEFAULT gen_random_uuid(),
    source_governance_appointment_id numeric(19, 0),
    establishment_urn integer,
    governance_role_type_id smallint,
    office_holder_role_type_id smallint,
    term_start_date date,
    term_end_date date
) ON COMMIT DROP;

\copy source_governance_appointment_fixture (source_governance_appointment_id, establishment_urn, governance_role_type_id, office_holder_role_type_id, term_start_date, term_end_date) FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

DO $$
BEGIN
    IF to_regclass('governance.governance_role_type') IS NULL
       OR to_regclass('governance.governance_appointment') IS NULL
       OR to_regclass('governance.term_of_office') IS NULL
       OR to_regclass('governance.office_holder_assignment') IS NULL THEN
        RAISE EXCEPTION 'Target role, appointment, term and role-assignment tables must exist.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM source_governance_appointment_fixture
        WHERE source_governance_appointment_id IS NULL
           OR source_governance_appointment_id <= 0
           OR establishment_urn IS NULL
           OR establishment_urn NOT BETWEEN 100000 AND 999999
    ) THEN
        RAISE EXCEPTION 'Fixture contains a missing or invalid appointment identifier or establishment URN.';
    END IF;

    IF EXISTS (
        SELECT source_governance_appointment_id
        FROM source_governance_appointment_fixture
        GROUP BY source_governance_appointment_id
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Fixture contains duplicate source governance appointment identifiers.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM source_governance_appointment_fixture AS fixture
        WHERE fixture.governance_role_type_id IS NULL
           OR fixture.governance_role_type_id NOT IN (1, 2, 3, 4, 5, 6, 7)
    ) THEN
        RAISE EXCEPTION 'Fixture contains a missing or unmapped BAU appointment role.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM source_governance_appointment_fixture AS fixture
        WHERE fixture.office_holder_role_type_id IS NOT NULL
          AND fixture.office_holder_role_type_id <> 8
    ) THEN
        RAISE EXCEPTION 'Fixture contains an unmapped BAU office-holder role.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM source_governance_appointment_fixture
        WHERE term_start_date IS NOT NULL
          AND term_end_date IS NOT NULL
          AND term_end_date < term_start_date
    ) THEN
        RAISE EXCEPTION 'Fixture contains a term end date before its appointment date.';
    END IF;
END $$;

INSERT INTO governance.governance_appointment (
    governance_appointment_id,
    establishment_urn,
    governance_role_type_id
)
SELECT
    governance_appointment_id,
    establishment_urn,
    governance_role_type_id
FROM source_governance_appointment_fixture;

INSERT INTO governance.term_of_office (
    governance_appointment_id,
    start_date,
    end_date
)
SELECT
    fixture.governance_appointment_id,
    fixture.term_start_date,
    fixture.term_end_date
FROM source_governance_appointment_fixture AS fixture
WHERE fixture.term_start_date IS NOT NULL
   OR fixture.term_end_date IS NOT NULL
;

INSERT INTO governance.office_holder_assignment (
    governance_appointment_id,
    governance_role_type_id,
    start_date,
    end_date
)
SELECT
    governance_appointment_id,
    office_holder_role_type_id,
    term_start_date,
    term_end_date
FROM source_governance_appointment_fixture
WHERE office_holder_role_type_id IS NOT NULL;

SELECT
    COUNT(*) AS accepted_governance_appointment_count,
    COUNT(governance_role_type_id) AS accepted_role_type_count,
    COUNT(*) FILTER (WHERE term_start_date IS NOT NULL OR term_end_date IS NOT NULL)
        AS accepted_term_of_office_count,
    COUNT(office_holder_role_type_id) AS accepted_office_holder_assignment_count
FROM source_governance_appointment_fixture;

COMMIT;
