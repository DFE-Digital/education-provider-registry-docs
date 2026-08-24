-- PostgreSQL target load for the minimal local Governance appointment fixture.
-- The PowerShell runner substitutes __FIXTURE_PATH__ with a local path before
-- invoking psql. The source extract is pipe-delimited CSV with a header row.
-- This first loader accepts no person, contact, term or appointing-body data.

BEGIN;

CREATE TEMP TABLE source_governance_appointment_fixture (
    source_governance_appointment_id numeric(19, 0),
    establishment_urn integer,
    role_type_code text
) ON COMMIT DROP;

\copy source_governance_appointment_fixture FROM '__FIXTURE_PATH__' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')

DO $$
BEGIN
    IF to_regclass('governance.governance_appointment') IS NULL THEN
        RAISE EXCEPTION 'Target table governance.governance_appointment does not exist.';
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
        FROM source_governance_appointment_fixture
        WHERE role_type_code IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Fixture contains role_type_code values, but role mapping is not enabled for this first slice.';
    END IF;
END $$;

INSERT INTO governance.governance_appointment (
    establishment_urn,
    source_governance_appointment_id,
    role_type_code
)
SELECT
    establishment_urn,
    source_governance_appointment_id,
    role_type_code
FROM source_governance_appointment_fixture
ON CONFLICT (source_governance_appointment_id) DO UPDATE SET
    establishment_urn = EXCLUDED.establishment_urn,
    role_type_code = EXCLUDED.role_type_code;

SELECT
    COUNT(*) AS accepted_governance_appointment_count,
    COUNT(role_type_code) AS accepted_role_type_count
FROM source_governance_appointment_fixture;

COMMIT;
