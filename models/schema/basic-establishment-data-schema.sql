-- PostgreSQL DDL for models/logical/basic-establishment-data-logical-model.md
-- Target: database establishment_local, schema establishment

CREATE SCHEMA IF NOT EXISTS establishment;

CREATE TABLE establishment.establishment_type (
    establishment_type_code text PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.education_phase (
    education_phase_code text PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE establishment.establishment (
    establishment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    urn numeric NOT NULL UNIQUE CHECK (urn BETWEEN 100000 AND 999999),
    dfe_number text,
    ukprn numeric CHECK (ukprn BETWEEN 10000000 AND 99999999),
    name text NOT NULL,
    establishment_type_code text NOT NULL REFERENCES establishment.establishment_type (establishment_type_code),
    education_phase_code text REFERENCES establishment.education_phase (education_phase_code)
);

CREATE TABLE establishment.education_admissions_and_provision (
    education_admissions_and_provision_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL UNIQUE REFERENCES establishment.establishment (establishment_id)
);

CREATE TABLE establishment.statutory_age_range (
    statutory_age_range_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    education_admissions_and_provision_id uuid NOT NULL UNIQUE
        REFERENCES establishment.education_admissions_and_provision (education_admissions_and_provision_id),
    lower_statutory_age integer NOT NULL CHECK (lower_statutory_age BETWEEN 0 AND 19),
    upper_statutory_age integer NOT NULL CHECK (upper_statutory_age BETWEEN 0 AND 25),
    CHECK (upper_statutory_age >= lower_statutory_age)
);
