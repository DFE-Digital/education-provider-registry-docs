-- T12: the bounded foundation-support slice, with provisional legal identity.
DO $$
DECLARE
    party uuid;
    party_role uuid;
    school uuid;
    responsibility uuid;
BEGIN
    SELECT e.establishment_id INTO STRICT school
    FROM establishment.establishment e
    JOIN establishment.establishment_type t USING (establishment_type_id)
    JOIN establishment.establishment_lifecycle lifecycle USING (establishment_id)
    WHERE e.urn=109393 AND e.name='New Fosseway School' AND e.ukprn=10016445
      AND t.name='Foundation special school'
      AND lifecycle.open_date IS NULL AND lifecycle.close_date IS NULL;

    SELECT role.legal_entity_id, role.establishment_party_role_id INTO STRICT party, party_role
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    JOIN establishment.establishment_party_role role USING (establishment_party_role_id)
    JOIN establishment.establishment_party_role_type rt USING (establishment_party_role_type_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='1193' AND i.is_current
      AND i.organisation_group_id IS NULL AND rt.name='Foundation trust';

    IF NOT EXISTS (SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id=party
                   AND name='Trust in Learning' AND legal_entity_type_id IS NULL AND charity_status_id IS NULL
                   AND incorporation_date IS NULL AND dissolution_date IS NULL)
       OR NOT EXISTS (SELECT 1 FROM establishment.establishment_party_role
                      WHERE establishment_party_role_id=party_role AND start_date IS NULL
                        AND end_date IS NULL AND person_id IS NULL)
       OR (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=party)<>1
       OR (SELECT count(*) FROM establishment.group_identifier WHERE establishment_party_role_id=party_role)<>1
       OR EXISTS (SELECT 1 FROM establishment.organisation_identifier WHERE legal_entity_id=party)
       OR EXISTS (SELECT 1 FROM establishment.academy_trust_classification WHERE legal_entity_id=party)
    THEN RAISE EXCEPTION 'T12 foundation trust must retain provisional identity and unknown business dates'; END IF;

    SELECT r.establishment_responsibility_id INTO STRICT responsibility
    FROM establishment.establishment_responsibility r
    JOIN establishment.establishment_responsibility_type t USING (responsibility_type_id)
    WHERE r.establishment_id=school AND r.legal_entity_id=party
      AND t.name='Supported by foundation trust' AND r.start_date=DATE '2010-09-01'
      AND r.end_date IS NULL AND r.is_current AND r.person_id IS NULL AND r.academy_trust_type_id IS NULL;
    IF (SELECT count(*) FROM establishment.establishment_responsibility WHERE establishment_id=school)<>1
       OR (SELECT count(*) FROM establishment.establishment_responsibility WHERE legal_entity_id=party)<>1
       OR EXISTS (SELECT 1 FROM establishment.organisation_group_member WHERE establishment_id=school)
       OR EXISTS (
          SELECT 1 FROM establishment.group_identifier i
          JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
          JOIN establishment.establishment_party_role role USING (establishment_party_role_id)
          WHERE t.name='Group UID' AND i.value IN ('5121','5122') AND role.legal_entity_id=party
       ) THEN RAISE EXCEPTION 'T12 imported an unselected relationship or merged comparison parties'; END IF;

    IF NOT EXISTS (
        SELECT 1 FROM migration.identity_resolution ir
        JOIN migration.source_record sr USING (source_record_id)
        JOIN migration.source_snapshot snapshot USING (source_snapshot_id)
        JOIN migration.migration_run run USING (migration_run_id)
        JOIN migration.establishment_party_role_evidence pe USING (source_record_id)
        JOIN migration.establishment_responsibility_evidence re USING (source_record_id)
        WHERE sr.source_group_id='1193' AND sr.source_urn=109393
          AND ir.target_entity_type='legal_entity' AND ir.target_entity_id=party
          AND ir.confidence='provisional' AND ir.decision_status='accepted'
          AND ir.resolution_method IN ('new-separate-source-party','existing-source-group-uid')
          AND ir.rationale LIKE 'T12 bounded provisional foundation-trust allocation:%'
          AND pe.establishment_party_role_id=party_role AND pe.first_observed_date=snapshot.snapshot_date
          AND pe.notes LIKE '%source group openDate=2008-09-01;%'
          AND re.establishment_responsibility_id=responsibility
          AND re.notes LIKE '%Source GroupLink 595: archived=0;%'
          AND run.status='completed'
    ) THEN RAISE EXCEPTION 'T12 provisional identity and source-link evidence are missing'; END IF;
END $$;
SELECT 'T12 foundation-trust checks passed' AS result;
