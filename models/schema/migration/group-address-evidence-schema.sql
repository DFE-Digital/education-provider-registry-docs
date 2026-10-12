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
