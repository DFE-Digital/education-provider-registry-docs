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

CREATE TABLE governance.governance_role_type (
    governance_role_type_id smallint PRIMARY KEY,
    name text NOT NULL UNIQUE CHECK (btrim(name) <> '')
);

COMMENT ON TABLE governance.governance_role_type IS
    'Target-owned controlled governance role types, seeded from the Governance vocabulary and taxonomy. BAU StaffRole codes are mapped transiently during migration and are not retained here.';

COMMENT ON COLUMN governance.governance_role_type.governance_role_type_id IS
    'Stable target-owned integer identifier, explicitly seeded in this schema script.';

INSERT INTO governance.governance_role_type (governance_role_type_id, name) VALUES
    (1, 'Governor'),
    (2, 'Academy trustee'),
    (3, 'Academy trust member'),
    (4, 'Local governor'),
    (5, 'Accounting officer'),
    (6, 'Chief financial officer'),
    (7, 'Governance professional'),
    (8, 'Chair');

CREATE TABLE governance.governance_appointment (
    governance_appointment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_urn integer NOT NULL CHECK (establishment_urn BETWEEN 100000 AND 999999),
    governance_role_type_id smallint NOT NULL
        REFERENCES governance.governance_role_type (governance_role_type_id)
);

COMMENT ON TABLE governance.governance_appointment IS
    'First, intentionally minimal Governance slice. It records an establishment-scoped appointment and its target-owned appointment role type. Participants, governance bodies, appointment basis and appointing bodies are not yet modelled. Source-system identifiers are held only in the transient migration fixture.';

COMMENT ON COLUMN governance.governance_appointment.governance_appointment_id IS
    'Target-generated UUID identifier for this governance appointment record.';

COMMENT ON COLUMN governance.governance_appointment.establishment_urn IS
    'URN of the establishment in scope. This first slice supports establishment-scoped appointments only.';

COMMENT ON COLUMN governance.governance_appointment.governance_role_type_id IS
    'Target-owned appointment role type. It must reference governance.governance_role_type.';

CREATE TABLE governance.term_of_office (
    term_of_office_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    governance_appointment_id uuid NOT NULL UNIQUE
        REFERENCES governance.governance_appointment (governance_appointment_id),
    start_date date,
    end_date date,
    CONSTRAINT term_of_office_end_not_before_start CHECK (
        end_date IS NULL OR start_date IS NULL OR end_date >= start_date
    )
);

COMMENT ON TABLE governance.term_of_office IS
    'Optional source term dates for one governance appointment. A term is created only when BAU StaffRecord supplies an appointment or step-down date.';

COMMENT ON COLUMN governance.term_of_office.term_of_office_id IS
    'Target-generated UUID identifier for this term-of-office record.';

COMMENT ON COLUMN governance.term_of_office.governance_appointment_id IS
    'The appointment to which this term belongs. The unique constraint permits at most one current source term per appointment.';

COMMENT ON COLUMN governance.term_of_office.start_date IS
    'GIAS BAU StaffRecord.appointmentDate, where supplied.';

COMMENT ON COLUMN governance.term_of_office.end_date IS
    'GIAS BAU StaffRecord.stepdownDate, where supplied.';

CREATE TABLE governance.office_holder_assignment (
    office_holder_assignment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    governance_appointment_id uuid NOT NULL
        REFERENCES governance.governance_appointment (governance_appointment_id),
    governance_role_type_id smallint NOT NULL
        REFERENCES governance.governance_role_type (governance_role_type_id),
    start_date date,
    end_date date,
    CONSTRAINT office_holder_assignment_end_not_before_start CHECK (
        end_date IS NULL OR start_date IS NULL OR end_date >= start_date
    )
);

COMMENT ON TABLE governance.office_holder_assignment IS
    'Office-holder responsibility layered on a governance appointment. The initial migration creates Chair assignments from BAU chair role rows.';

COMMENT ON COLUMN governance.office_holder_assignment.governance_role_type_id IS
    'Target-owned office-holder role type, initially Chair.';
