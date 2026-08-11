-- PostgreSQL DDL for models/logical/basic-establishment-data-logical-model.md
-- Target: database establishment_local, schema establishment
--
-- Disposable local baseline: this script intentionally drops and recreates the
-- establishment schema. Do not run it against shared, Test, staging or
-- production databases.

DROP SCHEMA IF EXISTS establishment CASCADE;
CREATE SCHEMA IF NOT EXISTS establishment;

CREATE TABLE establishment.establishment_type (
    establishment_type_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.education_phase (
    education_phase_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.gender_of_entry_type (
    gender_of_entry_type_id integer PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.establishment (
    establishment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    urn numeric NOT NULL UNIQUE CHECK (urn BETWEEN 100000 AND 999999),
    ukprn numeric CHECK (ukprn BETWEEN 10000000 AND 99999999),
    local_authority_code text,
    establishment_number integer CHECK (establishment_number BETWEEN 1 AND 9999),
    name text NOT NULL,
    establishment_type_id integer NOT NULL REFERENCES establishment.establishment_type (establishment_type_id),
    education_phase_id integer REFERENCES establishment.education_phase (education_phase_id)
);

CREATE TABLE establishment.education_admissions_and_provision (
    education_admissions_and_provision_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL UNIQUE REFERENCES establishment.establishment (establishment_id)
);

CREATE TABLE establishment.gender_of_entry (
    gender_of_entry_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    education_admissions_and_provision_id uuid NOT NULL UNIQUE
        REFERENCES establishment.education_admissions_and_provision (education_admissions_and_provision_id),
    gender_of_entry_type_id integer NOT NULL
        REFERENCES establishment.gender_of_entry_type (gender_of_entry_type_id)
);

CREATE TABLE establishment.statutory_age_range (
    statutory_age_range_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    education_admissions_and_provision_id uuid NOT NULL UNIQUE
        REFERENCES establishment.education_admissions_and_provision (education_admissions_and_provision_id),
    lower_statutory_age integer NOT NULL CHECK (lower_statutory_age BETWEEN 0 AND 19),
    upper_statutory_age integer NOT NULL CHECK (upper_statutory_age BETWEEN 0 AND 25),
    CHECK (upper_statutory_age >= lower_statutory_age)
);
