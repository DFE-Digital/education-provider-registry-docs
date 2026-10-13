-- T9: accepted shared body, not property/business ownership.
DO $$
DECLARE party_id uuid := '5be037f1-12fc-4b40-829c-4135c96fc783';
BEGIN
    IF (SELECT count(*) FROM establishment.legal_entity WHERE name='Acorn Care and Education Ltd') <> 1
       OR NOT EXISTS (SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id=party_id
          AND name='Acorn Care and Education Ltd' AND legal_entity_type_id IS NULL
          AND charity_status_id IS NULL AND incorporation_date IS NULL AND dissolution_date IS NULL) THEN
        RAISE EXCEPTION 'T9 must retain one accepted Acorn body without invented registered facts';
    END IF;
    IF (SELECT count(*) FROM establishment.establishment_responsibility r
        JOIN establishment.establishment e USING (establishment_id)
        JOIN establishment.establishment_responsibility_type rt USING (responsibility_type_id)
        WHERE r.legal_entity_id=party_id AND e.urn IN (112461,119009) AND rt.name='Proprietor'
          AND r.is_current AND r.start_date IS NULL AND r.end_date IS NULL
          AND r.person_id IS NULL AND r.academy_trust_type_id IS NULL) <> 2
       OR (SELECT count(*) FROM establishment.establishment_responsibility WHERE legal_entity_id=party_id) <> 2 THEN
        RAISE EXCEPTION 'T9 must retain two separate current undated proprietor responsibilities';
    END IF;
    IF EXISTS (SELECT 1 FROM establishment.organisation_identifier WHERE legal_entity_id=party_id)
       OR EXISTS (SELECT 1 FROM establishment.establishment_party_role WHERE legal_entity_id=party_id)
       OR EXISTS (SELECT 1 FROM establishment.academy_trust_classification WHERE legal_entity_id=party_id) THEN
        RAISE EXCEPTION 'T9 must not invent proprietor identifiers, roles or trust classifications';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM establishment.establishment WHERE urn=112461
        AND name='Underley Garden School' AND ukprn=10015990 AND establishment_type_id=15)
       OR NOT EXISTS (SELECT 1 FROM establishment.establishment WHERE urn=119009
        AND name='Heath Farm School' AND ukprn=10015772 AND establishment_type_id=15) THEN
        RAISE EXCEPTION 'T9 school identities and UKPRNs must remain separate from Acorn';
    END IF;
    IF (SELECT count(*) FROM migration.identity_resolution ir
        JOIN migration.source_record sr USING (source_record_id)
        JOIN migration.source_snapshot ss USING (source_snapshot_id)
        WHERE ir.target_entity_id=party_id AND ir.target_entity_type='legal_entity'
          AND ir.resolution_method='controlled-reviewed-proprietor' AND ir.decision_status='accepted'
          AND NULLIF(btrim(ir.rationale),'') IS NOT NULL
          AND ss.source_system='GIAS public extract' AND ss.source_database IS NULL
          AND ss.snapshot_date=DATE '2026-06-16' AND sr.source_urn IN (112461,119009)) <> 2 THEN
        RAISE EXCEPTION 'T9 needs two traceable accepted extract identity decisions';
    END IF;
    IF (SELECT count(*) FROM migration.establishment_responsibility_evidence ev
        JOIN establishment.establishment_responsibility r USING (establishment_responsibility_id)
        JOIN migration.source_record sr USING (source_record_id)
        JOIN migration.source_snapshot ss USING (source_snapshot_id)
        WHERE r.legal_entity_id=party_id AND ss.source_system='GIAS public extract'
          AND ev.first_observed_date=DATE '2026-06-16'
          AND ev.end_date_basis IS NULL AND ev.notes LIKE '%PropsName=Acorn Care and Education Ltd%') <> 2
       OR (SELECT count(*) FROM migration.establishment_responsibility_evidence ev
        JOIN establishment.establishment_responsibility r USING (establishment_responsibility_id)
        JOIN migration.source_record sr USING (source_record_id)
        JOIN migration.source_snapshot ss USING (source_snapshot_id)
        WHERE r.legal_entity_id=party_id AND ss.source_system='GIAS BAU'
          AND ev.first_observed_date IS NULL
          AND ev.notes LIKE '%proprietorType_code=01; proprietor_type=Individual Proprietor; additional_proprietor_rows=1%') <> 2 THEN
        RAISE EXCEPTION 'T9 must distinguish accepted extract observation from obfuscated local context';
    END IF;
END $$;
