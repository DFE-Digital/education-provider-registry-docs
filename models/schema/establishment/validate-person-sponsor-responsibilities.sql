-- T7: person sponsorship is separate from operation by a company.
DO $$
DECLARE
    sponsor_id uuid;
    sponsor_role_id uuid;
    trust_id uuid;
BEGIN
    SELECT role.person_id, role.establishment_party_role_id INTO STRICT sponsor_id, sponsor_role_id
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    JOIN establishment.establishment_party_role role USING (establishment_party_role_id)
    JOIN establishment.establishment_party_role_type rt USING (establishment_party_role_type_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='2613' AND i.is_current
      AND role.person_id IS NOT NULL AND role.legal_entity_id IS NULL AND rt.name='School sponsor'
      AND role.start_date IS NULL AND role.end_date IS NULL;
    SELECT i.legal_entity_id INTO STRICT trust_id FROM establishment.organisation_identifier i
    JOIN establishment.organisation_identifier_type t USING (organisation_identifier_type_id)
    WHERE t.name='Companies House number' AND i.value='06960253' AND i.is_current;

    IF NOT EXISTS (SELECT 1 FROM establishment.person WHERE person_id=sponsor_id)
       OR EXISTS (SELECT 1 FROM establishment.legal_entity WHERE name='Charles Dunstone')
       OR NOT EXISTS (SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id=trust_id
                      AND name='DUNSTONE EDUCATION TRUST' AND incorporation_date=DATE '2009-07-13')
       OR NOT EXISTS (SELECT 1 FROM establishment.organisation_identifier i
                      JOIN establishment.organisation_identifier_type t USING (organisation_identifier_type_id)
                      WHERE i.legal_entity_id=trust_id AND t.name='UKPRN' AND i.value='10058269' AND i.is_current) THEN
        RAISE EXCEPTION 'T7 person endpoint and independently identified trust must remain separate';
    END IF;
    IF (SELECT count(*) FROM establishment.establishment_responsibility r
        JOIN establishment.establishment e USING (establishment_id) WHERE e.urn=135936)<>2
       OR (SELECT count(*) FROM establishment.establishment_responsibility r
           JOIN establishment.establishment e USING (establishment_id)
           JOIN establishment.establishment_responsibility_type t USING (responsibility_type_id)
           LEFT JOIN establishment.academy_trust_type at ON at.academy_trust_type_id=r.academy_trust_type_id
           WHERE e.urn=135936 AND r.start_date=DATE '2009-09-01' AND r.end_date IS NULL AND r.is_current
             AND ((t.name='Sponsored by' AND r.person_id=sponsor_id AND r.legal_entity_id IS NULL AND at.name IS NULL)
               OR (t.name='Run by academy trust' AND r.legal_entity_id=trust_id AND r.person_id IS NULL
                   AND at.name='Multi-academy trust')))<>2 THEN
        RAISE EXCEPTION 'T7 requires current person sponsorship and separate MAT operation from 2009-09-01';
    END IF;
    IF (SELECT count(*) FROM establishment.group_identifier i
        JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
        WHERE i.establishment_party_role_id=sponsor_role_id AND i.is_current
          AND ((t.name='Group UID' AND i.value='2613') OR (t.name='Group ID' AND i.value='SP00099')))<>2
       OR (SELECT count(*) FROM establishment.group_identifier i
           JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
           JOIN establishment.establishment_party_role role USING (establishment_party_role_id)
           JOIN establishment.establishment_party_role_type rt USING (establishment_party_role_type_id)
           WHERE role.legal_entity_id=trust_id AND rt.name='Academy trust' AND i.is_current
             AND role.start_date IS NULL AND role.end_date IS NULL
             AND ((t.name='Group UID' AND i.value='3147') OR (t.name='Group ID' AND i.value='TR00830')))<>2
       OR (SELECT count(*) FROM establishment.academy_trust_classification c
           JOIN establishment.academy_trust_type t USING (academy_trust_type_id)
           WHERE c.legal_entity_id=trust_id AND t.name='Multi-academy trust'
             AND c.start_date IS NULL AND c.end_date IS NULL AND c.is_current)<>1 THEN
        RAISE EXCEPTION 'T7 role identifiers and independent MAT classification are incorrect';
    END IF;
    IF (SELECT count(*) FROM migration.establishment_responsibility_evidence evidence
        JOIN establishment.establishment_responsibility r USING (establishment_responsibility_id)
        JOIN establishment.establishment e USING (establishment_id)
        JOIN migration.source_record source USING (source_record_id)
        JOIN migration.source_snapshot snapshot USING (source_snapshot_id)
        JOIN migration.migration_run run USING (migration_run_id)
        WHERE e.urn=135936 AND source.source_urn=e.urn AND source.source_group_id IN ('2613','3147')
          AND evidence.end_date_basis IS NULL AND run.run_type='establishment-rebuild')<>2
       OR NOT EXISTS (
           SELECT 1 FROM migration.identity_resolution identity
           JOIN migration.source_record source USING (source_record_id)
           JOIN migration.source_snapshot snapshot USING (source_snapshot_id)
           JOIN migration.establishment_party_role_evidence evidence USING (source_record_id)
           WHERE source.source_group_id='2613' AND source.source_urn=135936
             AND identity.target_entity_type='person' AND identity.target_entity_id=sponsor_id
             AND identity.resolution_method='reviewed-person-sponsor' AND identity.confidence='reviewed'
             AND identity.rationale LIKE '%Charles Dunstone%' AND identity.rationale LIKE '%fulwoodacademy.co.uk%'
             AND evidence.establishment_party_role_id=sponsor_role_id
             AND evidence.first_observed_date=snapshot.snapshot_date
             AND evidence.notes LIKE '%GroupLink 3648: archived=0;%'
             AND evidence.notes LIKE '%1900-01-01 rejected as placeholder%'
       ) THEN RAISE EXCEPTION 'T7 requires separate link evidence and the reviewed person/placeholder decision'; END IF;
END $$;
