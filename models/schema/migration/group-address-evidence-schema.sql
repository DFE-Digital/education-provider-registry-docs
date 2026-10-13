-- Blank source blocks remain evidence, not fabricated address associations.
CREATE TABLE IF NOT EXISTS migration.group_address_evidence (
    group_address_evidence_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    source_record_id uuid NOT NULL UNIQUE REFERENCES migration.source_record(source_record_id),
    legal_entity_id uuid NOT NULL REFERENCES establishment.legal_entity(legal_entity_id),
    legal_entity_address_id uuid REFERENCES establishment.legal_entity_address(legal_entity_address_id),
    source_address_block text NOT NULL CHECK(source_address_block IN ('primary','contact')),
    raw_source_values jsonb NOT NULL,
    mapping_decision text NOT NULL,
    notes text NOT NULL
);

-- Organisation groups are distinct address owners from legal entities.
CREATE TABLE IF NOT EXISTS migration.organisation_group_address_evidence (
    organisation_group_address_evidence_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    source_record_id uuid NOT NULL UNIQUE REFERENCES migration.source_record(source_record_id),
    organisation_group_id uuid NOT NULL REFERENCES establishment.organisation_group(organisation_group_id),
    organisation_group_address_id uuid REFERENCES establishment.organisation_group_address(organisation_group_address_id),
    source_address_block text NOT NULL CHECK(source_address_block IN ('primary','contact')),
    raw_source_values jsonb NOT NULL,
    mapping_decision text NOT NULL,
    notes text NOT NULL
);

-- Person-source blocks are retained even though person addresses are not in
-- the current business model. A populated block requires a separate decision.
CREATE TABLE IF NOT EXISTS migration.person_address_evidence (
    person_address_evidence_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    source_record_id uuid NOT NULL UNIQUE REFERENCES migration.source_record(source_record_id),
    person_id uuid NOT NULL REFERENCES establishment.person(person_id),
    source_address_block text NOT NULL CHECK(source_address_block IN ('primary','contact')),
    raw_source_values jsonb NOT NULL,
    mapping_decision text NOT NULL CHECK(mapping_decision='blank-source-block'),
    notes text NOT NULL
);
