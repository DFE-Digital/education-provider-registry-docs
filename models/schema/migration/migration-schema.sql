-- Migration-only evidence and provenance.
-- This schema is for database administrators and migration tooling. It is not
-- part of the live service model.

DROP SCHEMA IF EXISTS migration CASCADE;
CREATE SCHEMA migration;

CREATE TABLE migration.migration_run (
    migration_run_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    run_type text NOT NULL,
    source_system text NOT NULL,
    source_database text,
    source_snapshot_date date,
    started_at timestamptz NOT NULL DEFAULT now(),
    completed_at timestamptz,
    status text NOT NULL DEFAULT 'running',
    transform_version text,
    notes text
);

CREATE TABLE migration.source_snapshot (
    source_snapshot_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    migration_run_id uuid NOT NULL REFERENCES migration.migration_run (migration_run_id),
    source_system text NOT NULL,
    source_database text,
    snapshot_date date,
    extract_name text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE migration.source_record (
    source_record_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    source_snapshot_id uuid NOT NULL REFERENCES migration.source_snapshot (source_snapshot_id),
    source_table text NOT NULL,
    source_key text NOT NULL,
    source_group_id text,
    source_urn integer,
    source_row_hash text,
    UNIQUE (source_snapshot_id, source_table, source_key)
);

CREATE TABLE migration.establishment_party_role_evidence (
    evidence_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_party_role_id uuid NOT NULL REFERENCES establishment.establishment_party_role (establishment_party_role_id),
    source_record_id uuid REFERENCES migration.source_record (source_record_id),
    first_observed_date date,
    end_date_basis text CHECK (end_date_basis IS NULL OR end_date_basis IN ('evidenced', 'inferred')),
    inference_rule text,
    review_status text NOT NULL DEFAULT 'accepted',
    notes text
);

CREATE TABLE migration.establishment_responsibility_evidence (
    evidence_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_responsibility_id uuid NOT NULL REFERENCES establishment.establishment_responsibility (establishment_responsibility_id),
    source_record_id uuid REFERENCES migration.source_record (source_record_id),
    first_observed_date date,
    end_date_basis text CHECK (end_date_basis IS NULL OR end_date_basis IN ('evidenced', 'inferred')),
    inference_rule text,
    review_status text NOT NULL DEFAULT 'accepted',
    notes text
);

CREATE TABLE migration.academy_trust_classification_evidence (
    evidence_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    academy_trust_classification_id uuid NOT NULL
        REFERENCES establishment.academy_trust_classification (academy_trust_classification_id),
    source_record_id uuid REFERENCES migration.source_record (source_record_id),
    assertion_rule text NOT NULL,
    review_status text NOT NULL DEFAULT 'accepted',
    notes text,
    UNIQUE (academy_trust_classification_id, source_record_id, assertion_rule)
);

CREATE TABLE migration.organisation_group_member_evidence (
    evidence_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    organisation_group_member_id uuid NOT NULL REFERENCES establishment.organisation_group_member (organisation_group_member_id),
    source_record_id uuid REFERENCES migration.source_record (source_record_id),
    first_observed_date date,
    left_date_basis text CHECK (left_date_basis IS NULL OR left_date_basis IN ('evidenced', 'inferred')),
    inference_rule text,
    review_status text NOT NULL DEFAULT 'accepted',
    notes text
);

CREATE TABLE migration.identity_resolution (
    identity_resolution_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    source_record_id uuid NOT NULL REFERENCES migration.source_record (source_record_id),
    target_entity_type text NOT NULL,
    target_entity_id uuid NOT NULL,
    resolution_method text NOT NULL,
    confidence text,
    decision_status text NOT NULL DEFAULT 'accepted',
    decided_at timestamptz,
    decided_by text,
    rationale text
);

CREATE INDEX ix_party_role_evidence_role
    ON migration.establishment_party_role_evidence (establishment_party_role_id);
CREATE INDEX ix_responsibility_evidence_responsibility
    ON migration.establishment_responsibility_evidence (establishment_responsibility_id);
CREATE INDEX ix_classification_evidence_classification
    ON migration.academy_trust_classification_evidence (academy_trust_classification_id);
CREATE INDEX ix_group_member_evidence_member
    ON migration.organisation_group_member_evidence (organisation_group_member_id);
CREATE INDEX ix_identity_resolution_source
    ON migration.identity_resolution (source_record_id);
