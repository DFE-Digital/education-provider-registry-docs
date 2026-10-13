-- T15R: a closed UTC/SAT, despite the non-archived source link.
DO $$
DECLARE
    school uuid;
    party uuid;
    party_role uuid;
    classification uuid;
    responsibility uuid;
BEGIN
    SELECT e.establishment_id INTO STRICT school
    FROM establishment.establishment e
    JOIN establishment.establishment_type t USING (establishment_type_id)
    JOIN establishment.establishment_lifecycle l USING (establishment_id)
    JOIN establishment.establishment_geography geo USING (establishment_id)
    JOIN establishment.local_authority la USING (local_authority_id)
    WHERE e.urn=136933 AND e.name='Black Country UTC' AND e.ukprn IS NULL
      AND e.establishment_number=4000 AND t.name='University technical college'
      AND l.open_date=DATE '2011-09-01' AND l.close_date=DATE '2015-08-31' AND la.code=335;

    SELECT role.legal_entity_id,role.establishment_party_role_id INTO STRICT party,party_role
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    JOIN establishment.establishment_party_role role USING (establishment_party_role_id)
    JOIN establishment.establishment_party_role_type rt USING (establishment_party_role_type_id)
    WHERE t.name='Group UID' AND i.value='2347' AND issuer.name='GIAS' AND NOT i.is_current
      AND i.organisation_group_id IS NULL AND rt.name='Academy trust'
      AND role.person_id IS NULL AND role.start_date IS NULL AND role.end_date=DATE '2015-08-31';
    IF NOT EXISTS (SELECT 1 FROM establishment.legal_entity le
                   JOIN establishment.legal_entity_type t USING (legal_entity_type_id)
                   WHERE le.legal_entity_id=party AND le.name='BLACK COUNTRY UTC'
                     AND le.incorporation_date=DATE '2011-03-08' AND le.dissolution_date IS NULL
                     AND t.name='Charitable company limited by guarantee' AND le.charity_status_id IS NULL)
       OR (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=party)<>1
       OR (SELECT count(*) FROM establishment.organisation_identifier WHERE legal_entity_id=party)<>1
       OR NOT EXISTS (
           SELECT 1 FROM establishment.organisation_identifier i
           JOIN establishment.organisation_identifier_type t USING (organisation_identifier_type_id)
           WHERE i.legal_entity_id=party AND t.name='Companies House number' AND i.value='07556132' AND i.is_current)
       OR (SELECT count(*) FROM establishment.group_identifier WHERE establishment_party_role_id=party_role)<>2
       OR NOT EXISTS (
           SELECT 1 FROM establishment.group_identifier i
           JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
           JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
           WHERE i.establishment_party_role_id=party_role AND t.name='Group ID' AND i.value='TR00230'
             AND issuer.name='GIAS' AND NOT i.is_current AND i.organisation_group_id IS NULL)
    THEN RAISE EXCEPTION 'T15R party identity, unknown dissolution or historical identifiers are incorrect'; END IF;

    SELECT c.academy_trust_classification_id INTO STRICT classification
    FROM establishment.academy_trust_classification c
    JOIN establishment.academy_trust_type t USING (academy_trust_type_id)
    WHERE c.legal_entity_id=party AND t.name='Single-academy trust' AND c.start_date IS NULL
      AND c.end_date=DATE '2015-08-31' AND NOT c.is_current;
    SELECT r.establishment_responsibility_id INTO STRICT responsibility
    FROM establishment.establishment_responsibility r
    JOIN establishment.establishment_responsibility_type t USING (responsibility_type_id)
    JOIN establishment.academy_trust_type tt USING (academy_trust_type_id)
    WHERE r.establishment_id=school AND r.legal_entity_id=party AND r.person_id IS NULL
      AND t.name='Run by academy trust' AND tt.name='Single-academy trust'
      AND r.start_date=DATE '2011-09-01' AND r.end_date=DATE '2015-08-31' AND NOT r.is_current;
    IF (SELECT count(*) FROM establishment.academy_trust_classification WHERE legal_entity_id=party)<>1
       OR (SELECT count(*) FROM establishment.establishment_responsibility WHERE establishment_id=school)<>1
       OR (SELECT count(*) FROM establishment.establishment_responsibility WHERE legal_entity_id=party)<>1
       OR EXISTS (SELECT 1 FROM establishment.organisation_group_member WHERE establishment_id=school)
    THEN RAISE EXCEPTION 'T15R imported an unselected role, classification, responsibility or membership'; END IF;

    IF NOT EXISTS (
        SELECT 1 FROM migration.source_record sr
        JOIN migration.source_snapshot snapshot USING (source_snapshot_id)
        JOIN migration.migration_run run USING (migration_run_id)
        JOIN migration.identity_resolution ir USING (source_record_id)
        JOIN migration.establishment_party_role_evidence pe USING (source_record_id)
        JOIN migration.academy_trust_classification_evidence ce USING (source_record_id)
        JOIN migration.establishment_responsibility_evidence re USING (source_record_id)
        WHERE sr.source_group_id='2347' AND sr.source_urn=136933 AND sr.source_key='2347:136933'
          AND ir.target_entity_type='legal_entity' AND ir.target_entity_id=party
          AND ir.confidence='high' AND ir.decision_status='accepted'
          AND ir.resolution_method IN ('companies-house-number','existing-source-group-uid')
          AND ir.rationale LIKE 'T15R accepted closed-SAT lifecycle mapping:%'
          AND pe.establishment_party_role_id=party_role AND pe.end_date_basis='evidenced'
          AND pe.notes LIKE '%Source GroupLink 5319: archived=0; effectiveDate=2011-09-01.%'
          AND ce.academy_trust_classification_id=classification AND ce.assertion_rule='MR005'
          AND ce.notes LIKE 'T15R accepted closed-SAT lifecycle mapping:%'
          AND re.establishment_responsibility_id=responsibility AND re.end_date_basis='inferred'
          AND re.inference_rule='Responsibility end date inferred from the source establishment closure date.'
          AND re.notes LIKE '%Company dissolution remains unknown;%'
          AND run.status='completed' AND snapshot.source_system='GIAS BAU'
    ) THEN RAISE EXCEPTION 'T15R source link, accepted lifecycle mapping or inferred-end evidence is missing'; END IF;
END $$;
SELECT 'T15R closed-SAT checks passed' AS result;
