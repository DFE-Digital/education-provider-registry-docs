-- T14R: one school, separate sponsor and MAT, with independently owned identifiers.
DO $$
DECLARE
    school uuid;
    sponsor uuid;
    trust uuid;
    sponsor_role uuid;
    trust_role uuid;
BEGIN
    SELECT e.establishment_id INTO STRICT school
    FROM establishment.establishment e
    JOIN establishment.establishment_type t USING (establishment_type_id)
    JOIN establishment.establishment_lifecycle l USING (establishment_id)
    WHERE e.urn=139844 AND e.name='Bury CofE Primary School' AND e.ukprn=10042228
      AND t.name='Mainstream academy' AND l.open_date=DATE '2013-07-01' AND l.close_date IS NULL;

    SELECT r.legal_entity_id,r.establishment_party_role_id INTO STRICT sponsor,sponsor_role
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    JOIN establishment.establishment_party_role r USING (establishment_party_role_id)
    JOIN establishment.establishment_party_role_type rt USING (establishment_party_role_type_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='2904' AND i.is_current
      AND rt.name='School sponsor' AND r.person_id IS NULL AND r.start_date IS NULL AND r.end_date IS NULL;
    SELECT r.legal_entity_id,r.establishment_party_role_id INTO STRICT trust,trust_role
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    JOIN establishment.establishment_party_role r USING (establishment_party_role_id)
    JOIN establishment.establishment_party_role_type rt USING (establishment_party_role_type_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='2905' AND i.is_current
      AND rt.name='Academy trust' AND r.person_id IS NULL AND r.start_date IS NULL AND r.end_date IS NULL;
    IF sponsor=trust OR NOT EXISTS (SELECT 1 FROM establishment.legal_entity
        WHERE legal_entity_id=sponsor AND name='Diocese of Ely' AND legal_entity_type_id IS NULL
          AND charity_status_id IS NULL AND incorporation_date IS NULL AND dissolution_date IS NULL)
       OR NOT EXISTS (SELECT 1 FROM establishment.legal_entity le
        JOIN establishment.legal_entity_type t USING (legal_entity_type_id)
        WHERE le.legal_entity_id=trust AND le.name='GRACE SCHOOLS'
          AND t.name='Charitable company limited by guarantee'
          AND le.incorporation_date=DATE '2013-03-27' AND le.dissolution_date IS NULL AND le.charity_status_id IS NULL)
       OR EXISTS (SELECT 1 FROM establishment.organisation_identifier WHERE legal_entity_id=sponsor)
       OR (SELECT count(*) FROM establishment.organisation_identifier WHERE legal_entity_id=trust)<>2
       OR (SELECT count(*) FROM establishment.organisation_identifier i
           JOIN establishment.organisation_identifier_type t USING (organisation_identifier_type_id)
           WHERE i.legal_entity_id=trust AND i.is_current
             AND ((t.name='Companies House number' AND i.value='08464996')
               OR (t.name='UKPRN' AND i.value='10060395')))<>2
    THEN RAISE EXCEPTION 'T14R sponsor/trust identity or registered identifier ownership is incorrect'; END IF;

    IF (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=sponsor)<>1
       OR (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=trust)<>1
       OR EXISTS (SELECT 1 FROM establishment.academy_trust_classification WHERE legal_entity_id=sponsor)
       OR (SELECT count(*) FROM establishment.academy_trust_classification WHERE legal_entity_id=trust)<>1
       OR NOT EXISTS (SELECT 1 FROM establishment.academy_trust_classification c
           JOIN establishment.academy_trust_type t USING (academy_trust_type_id)
           WHERE c.legal_entity_id=trust AND t.name='Multi-academy trust' AND c.is_current
             AND c.start_date IS NULL AND c.end_date IS NULL)
       OR (SELECT count(*) FROM establishment.group_identifier WHERE establishment_party_role_id IN (sponsor_role,trust_role))<>4
       OR NOT EXISTS (SELECT 1 FROM establishment.group_identifier i
           JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
           WHERE i.establishment_party_role_id=sponsor_role AND t.name='Group ID' AND i.value='SP00160' AND i.is_current)
       OR NOT EXISTS (SELECT 1 FROM establishment.group_identifier i
           JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
           WHERE i.establishment_party_role_id=trust_role AND t.name='Group ID' AND i.value='TR00661' AND i.is_current)
    THEN RAISE EXCEPTION 'T14R roles, group identifiers or classification are incorrect'; END IF;

    IF (SELECT count(*) FROM establishment.establishment_responsibility WHERE establishment_id=school)<>2
       OR NOT EXISTS (SELECT 1 FROM establishment.establishment_responsibility r
           JOIN establishment.establishment_responsibility_type t USING (responsibility_type_id)
           WHERE r.establishment_id=school AND r.legal_entity_id=sponsor AND t.name='Sponsored by'
             AND r.start_date=DATE '2013-07-01' AND r.end_date IS NULL AND r.is_current
             AND r.person_id IS NULL AND r.academy_trust_type_id IS NULL)
       OR NOT EXISTS (SELECT 1 FROM establishment.establishment_responsibility r
           JOIN establishment.establishment_responsibility_type t USING (responsibility_type_id)
           JOIN establishment.academy_trust_type at USING (academy_trust_type_id)
           WHERE r.establishment_id=school AND r.legal_entity_id=trust AND t.name='Run by academy trust'
             AND at.name='Multi-academy trust' AND r.start_date=DATE '2013-07-01'
             AND r.end_date IS NULL AND r.is_current AND r.person_id IS NULL)
       OR EXISTS (SELECT 1 FROM establishment.organisation_group_member WHERE establishment_id=school)
    THEN RAISE EXCEPTION 'T14R establishment responsibilities are incorrect'; END IF;

    IF (SELECT count(DISTINCT sr.source_group_id)
        FROM migration.identity_resolution ir
        JOIN migration.source_record sr USING (source_record_id)
        JOIN migration.source_snapshot ss USING (source_snapshot_id)
        JOIN migration.migration_run run USING (migration_run_id)
        JOIN migration.establishment_party_role_evidence pe USING (source_record_id)
        JOIN migration.establishment_responsibility_evidence re USING (source_record_id)
        WHERE sr.source_urn=139844 AND ir.target_entity_type='legal_entity'
          AND ir.decision_status='accepted' AND run.status='completed'
          AND ir.rationale LIKE 'T14R accepted separate-party mapping:%'
          AND ((sr.source_group_id='2904' AND ir.target_entity_id=sponsor AND ir.confidence='provisional'
                AND ir.resolution_method IN ('new-separate-source-party','existing-source-group-uid')
                AND pe.establishment_party_role_id=sponsor_role
                AND re.notes LIKE '%Source GroupLink 3115: archived=0;%'
                AND re.notes LIKE '%1900-01-01T00:00:01 rejected as placeholder;%')
            OR (sr.source_group_id='2905' AND ir.target_entity_id=trust AND ir.confidence='high'
                AND pe.establishment_party_role_id=trust_role
                AND re.notes LIKE '%Source GroupLink 6303: archived=0;%')))<>2
    THEN RAISE EXCEPTION 'T14R source-link evidence, provisional sponsor allocation or placeholder rejection is missing'; END IF;
END $$;
SELECT 'T14R external-sponsor checks passed' AS result;
