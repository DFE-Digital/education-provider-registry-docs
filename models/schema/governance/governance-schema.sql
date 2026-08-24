-- PostgreSQL DDL for models/logical/governance/current-governance-appointments-logical-model.md
-- Target: local database governance_local, schema governance
--
-- Disposable local baseline: this script intentionally drops and recreates the
-- governance schema. Do not run it against shared, Test, staging or production
-- databases.

DO $$
BEGIN
    IF current_database() <> 'governance_local' THEN
        RAISE EXCEPTION 'This script may run only in governance_local. Current database: %', current_database();
    END IF;
END $$;

DROP SCHEMA IF EXISTS governance CASCADE;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA governance;

CREATE TABLE governance.governance_appointment (
    governance_appointment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_urn integer NOT NULL CHECK (establishment_urn BETWEEN 100000 AND 999999),
    source_governance_appointment_id numeric(19, 0) NOT NULL
        UNIQUE CHECK (source_governance_appointment_id > 0),
    role_type_code text CHECK (role_type_code IS NULL OR btrim(role_type_code) <> '')
);

COMMENT ON TABLE governance.governance_appointment IS
    'First, intentionally minimal Governance slice. It records an establishment-scoped source appointment identifier and an optional reviewed role type. Participants, governance bodies, terms, appointment basis and appointing bodies are not yet modelled.';

COMMENT ON COLUMN governance.governance_appointment.governance_appointment_id IS
    'Target-generated UUID identifier for this governance appointment record.';

COMMENT ON COLUMN governance.governance_appointment.establishment_urn IS
    'URN of the establishment in scope. This first slice supports establishment-scoped appointments only.';

COMMENT ON COLUMN governance.governance_appointment.source_governance_appointment_id IS
    'GIAS BAU StaffRecord.uid, also exposed as the governance GID. The unique source migration key.';

COMMENT ON COLUMN governance.governance_appointment.role_type_code IS
    'Optional reviewed role type code. It is not yet enforced against Governance reference data.';
