-- T13: an accepted separate-party decision takes precedence over matching names.
DO $$
DECLARE
    proprietor uuid := '27546d94-e327-49fd-aecb-26c8c043a597';
    trust uuid;
    party_role uuid;
    school uuid;
BEGIN
    SELECT r.legal_entity_id,r.establishment_party_role_id INTO STRICT trust,party_role
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    JOIN establishment.establishment_party_role r USING (establishment_party_role_id)
    JOIN establishment.establishment_party_role_type rt USING (establishment_party_role_type_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='3641' AND i.is_current
      AND rt.name='Academy trust' AND r.person_id IS NULL AND r.start_date IS NULL AND r.end_date IS NULL;
    IF trust=proprietor OR (SELECT count(*) FROM establishment.legal_entity
        WHERE upper(btrim(name))='THE KING''S SCHOOL')<>2
       OR NOT EXISTS (SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id=proprietor
         AND name='The King''s School' AND legal_entity_type_id IS NULL AND charity_status_id IS NULL
         AND incorporation_date IS NULL AND dissolution_date IS NULL)
       OR NOT EXISTS (SELECT 1 FROM establishment.legal_entity le
         JOIN establishment.legal_entity_type t USING (legal_entity_type_id)
         WHERE le.legal_entity_id=trust AND le.name='THE KING''S SCHOOL'
           AND t.name='Charitable company limited by guarantee' AND le.incorporation_date=DATE '2011-07-15'
           AND le.dissolution_date IS NULL AND le.charity_status_id IS NULL)
    THEN RAISE EXCEPTION 'T13 must retain two distinct same-name parties with correct unknown fields'; END IF;
    IF EXISTS (SELECT 1 FROM establishment.organisation_identifier WHERE legal_entity_id=proprietor)
       OR (SELECT count(*) FROM establishment.organisation_identifier WHERE legal_entity_id=trust)<>2
       OR (SELECT count(*) FROM establishment.organisation_identifier i
          JOIN establishment.organisation_identifier_type t USING (organisation_identifier_type_id)
          WHERE i.legal_entity_id=trust AND i.is_current
            AND ((t.name='Companies House number' AND i.value='07706900')
              OR (t.name='UKPRN' AND i.value='10059149')))<>2
       OR EXISTS (SELECT 1 FROM establishment.establishment_party_role WHERE legal_entity_id=proprietor)
       OR EXISTS (SELECT 1 FROM establishment.academy_trust_classification WHERE legal_entity_id=proprietor)
       OR (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=trust)<>1
       OR (SELECT count(*) FROM establishment.group_identifier WHERE establishment_party_role_id=party_role)<>2
       OR NOT EXISTS (SELECT 1 FROM establishment.group_identifier i
          JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
          WHERE i.establishment_party_role_id=party_role AND t.name='Group ID' AND i.value='TR01236' AND i.is_current)
       OR (SELECT count(*) FROM establishment.academy_trust_classification WHERE legal_entity_id=trust)<>1
       OR NOT EXISTS (SELECT 1 FROM establishment.academy_trust_classification c
          JOIN establishment.academy_trust_type t USING (academy_trust_type_id)
          WHERE c.legal_entity_id=trust AND t.name='Single-academy trust' AND c.is_current
            AND c.start_date IS NULL AND c.end_date IS NULL)
    THEN RAISE EXCEPTION 'T13 identifier, role or classification ownership is incorrect'; END IF;

    SELECT e.establishment_id INTO STRICT school FROM establishment.establishment e
    JOIN establishment.establishment_type t USING (establishment_type_id)
    JOIN establishment.establishment_lifecycle l USING (establishment_id)
    WHERE e.urn=115780 AND e.name='The King''s School, Gloucester' AND e.ukprn=10003659
      AND t.name='Other independent school' AND l.open_date=DATE '1930-01-01' AND l.close_date IS NULL;
    IF (SELECT count(*) FROM establishment.establishment_responsibility WHERE establishment_id=school)<>1
       OR NOT EXISTS (SELECT 1 FROM establishment.establishment_responsibility r
          JOIN establishment.establishment_responsibility_type t USING (responsibility_type_id)
          WHERE r.establishment_id=school AND r.legal_entity_id=proprietor AND t.name='Proprietor'
            AND r.is_current AND r.start_date IS NULL AND r.end_date IS NULL
            AND r.person_id IS NULL AND r.academy_trust_type_id IS NULL)
    THEN RAISE EXCEPTION 'T13 Gloucester proprietor responsibility is incorrect'; END IF;
    SELECT e.establishment_id INTO STRICT school FROM establishment.establishment e
    JOIN establishment.establishment_type t USING (establishment_type_id)
    JOIN establishment.establishment_lifecycle l USING (establishment_id)
    WHERE e.urn=137166 AND e.name='The King''s School Grantham' AND e.ukprn=10034779
      AND t.name='Mainstream academy' AND l.open_date=DATE '2011-08-01' AND l.close_date IS NULL;
    IF (SELECT count(*) FROM establishment.establishment_responsibility WHERE establishment_id=school)<>1
       OR NOT EXISTS (SELECT 1 FROM establishment.establishment_responsibility r
          JOIN establishment.establishment_responsibility_type t USING (responsibility_type_id)
          JOIN establishment.academy_trust_type at USING (academy_trust_type_id)
          WHERE r.establishment_id=school AND r.legal_entity_id=trust AND t.name='Run by academy trust'
            AND at.name='Single-academy trust' AND r.is_current AND r.start_date=DATE '2011-08-01'
            AND r.end_date IS NULL AND r.person_id IS NULL)
       OR (SELECT count(*) FROM establishment.establishment_responsibility
           WHERE legal_entity_id IN (trust,proprietor))<>2
       OR EXISTS (SELECT 1 FROM establishment.organisation_group_member m
           JOIN establishment.establishment e USING (establishment_id) WHERE e.urn IN (115780,137166))
    THEN RAISE EXCEPTION 'T13 Grantham responsibility or selected scope is incorrect'; END IF;
    IF NOT EXISTS (SELECT 1 FROM migration.identity_resolution ir
        JOIN migration.source_record sr USING (source_record_id)
        JOIN migration.source_snapshot ss USING (source_snapshot_id)
        WHERE ir.target_entity_id=proprietor AND ir.target_entity_type='legal_entity'
          AND ir.confidence='accepted-fixture-assumption' AND ir.decision_status='accepted'
          AND ir.resolution_method='controlled-reviewed-proprietor'
          AND ir.rationale LIKE 'T13 accepted separate-party assumption:%'
          AND sr.source_urn=115780 AND ss.source_system='GIAS public extract'
          AND ss.snapshot_date=DATE '2026-06-16')
       OR NOT EXISTS (SELECT 1 FROM migration.identity_resolution ir
        JOIN migration.source_record sr USING (source_record_id)
        JOIN migration.establishment_responsibility_evidence ev USING (source_record_id)
        WHERE ir.target_entity_id=trust AND sr.source_group_id='3641' AND sr.source_urn=137166
          AND ir.rationale LIKE 'T13 accepted separate-party assumption:%'
          AND ev.notes LIKE '%Source GroupLink 9005: archived=0;%')
    THEN RAISE EXCEPTION 'T13 separate-party decisions or source evidence are missing'; END IF;
END $$;
SELECT 'T13 distinct-party checks passed' AS result;
