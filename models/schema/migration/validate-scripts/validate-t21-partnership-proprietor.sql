DO $$
DECLARE party_id uuid := '73d09caa-5883-4fdb-b6b4-c4c45d56a221';
BEGIN
 IF NOT EXISTS (SELECT 1 FROM establishment.establishment e
 JOIN establishment.establishment_lifecycle life USING(establishment_id)
 JOIN establishment.establishment_geography geo USING(establishment_id)
 JOIN establishment.local_authority la USING(local_authority_id)
 WHERE e.urn=124870 AND e.name='Summerhill School' AND e.ukprn=10017679
 AND e.establishment_number=6016 AND e.establishment_type_id=17 AND la.code=935
 AND life.open_date=DATE '1921-03-13' AND life.close_date IS NULL)
 THEN RAISE EXCEPTION 'T21 school identity and lifecycle incorrect'; END IF;
 IF (SELECT count(*) FROM establishment.legal_entity WHERE name='Mr & Mrs Readhead (Partnership)')<>1
 OR NOT EXISTS (SELECT 1 FROM establishment.legal_entity le
 JOIN establishment.legal_entity_type t USING(legal_entity_type_id)
 WHERE le.legal_entity_id=party_id AND le.name='Mr & Mrs Readhead (Partnership)'
 AND t.name='Traditional partnership' AND le.charity_status_id IS NULL
 AND le.incorporation_date IS NULL AND le.dissolution_date IS NULL)
 THEN RAISE EXCEPTION 'T21 requires one controlled partnership, not invented registered facts'; END IF;
 IF (SELECT count(*) FROM establishment.establishment_responsibility WHERE legal_entity_id=party_id)<>1
 OR NOT EXISTS (SELECT 1 FROM establishment.establishment_responsibility r
 JOIN establishment.establishment e USING(establishment_id)
 JOIN establishment.establishment_responsibility_type rt USING(responsibility_type_id)
 WHERE r.legal_entity_id=party_id AND e.urn=124870 AND rt.name='Proprietor'
 AND r.is_current AND r.start_date IS NULL AND r.end_date IS NULL
 AND r.person_id IS NULL AND r.academy_trust_type_id IS NULL)
 THEN RAISE EXCEPTION 'T21 requires one current undated body proprietor responsibility'; END IF;
 IF EXISTS (SELECT 1 FROM establishment.organisation_identifier WHERE legal_entity_id=party_id)
 OR EXISTS (SELECT 1 FROM establishment.establishment_party_role WHERE legal_entity_id=party_id)
 OR EXISTS (SELECT 1 FROM establishment.organisation_group_member m JOIN establishment.establishment e USING(establishment_id) WHERE e.urn=124870)
 THEN RAISE EXCEPTION 'T21 must not invent registered identifiers, proprietor role or group membership'; END IF;
 IF NOT EXISTS (SELECT 1 FROM migration.identity_resolution ir
 JOIN migration.source_record sr USING(source_record_id)
 JOIN migration.source_snapshot ss USING(source_snapshot_id)
 WHERE ir.target_entity_id=party_id AND ir.decision_status='accepted'
 AND ir.resolution_method='controlled-reviewed-proprietor' AND sr.source_urn=124870
 AND ss.source_system='GIAS public extract' AND ss.snapshot_date=DATE '2026-06-16'
 AND ir.rationale LIKE 'T21 accepted controlled partnership assumption:%')
 OR NOT EXISTS (SELECT 1 FROM migration.establishment_responsibility_evidence ev
 JOIN establishment.establishment_responsibility r USING(establishment_responsibility_id)
 JOIN migration.source_record sr USING(source_record_id)
 JOIN migration.source_snapshot ss USING(source_snapshot_id)
 WHERE r.legal_entity_id=party_id AND ss.source_system='GIAS BAU' AND sr.source_urn=124870
 AND ev.notes LIKE '%proprietorType_code=02%' AND ev.notes LIKE '%additional_proprietor_rows=1%')
 OR NOT EXISTS (SELECT 1 FROM migration.establishment_responsibility_evidence ev
 JOIN establishment.establishment_responsibility r USING(establishment_responsibility_id)
 WHERE r.legal_entity_id=party_id AND ev.first_observed_date=DATE '2026-06-16'
 AND ev.notes LIKE '%Traditional partnership is an explicit controlled-fixture assumption%')
 THEN RAISE EXCEPTION 'T21 requires distinct public identity assumption and obfuscated local context evidence'; END IF;
END $$;
SELECT 'T21 partnership proprietor checks passed' AS result;
