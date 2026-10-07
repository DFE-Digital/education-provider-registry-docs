-- T6: one current foundation-support link, without invented legal identity.
DO $$
DECLARE
    entity_id uuid;
    role_id uuid;
    responsibility_id uuid;
BEGIN
    SELECT role.legal_entity_id, role.establishment_party_role_id
    INTO STRICT entity_id, role_id
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    JOIN establishment.establishment_party_role role USING (establishment_party_role_id)
    JOIN establishment.establishment_party_role_type role_type USING (establishment_party_role_type_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='1337' AND i.is_current
      AND i.organisation_group_id IS NULL AND role_type.name='Foundation trust';

    IF NOT EXISTS (SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id=entity_id
                   AND name='The North Tyneside Learning Trust' AND legal_entity_type_id IS NULL
                   AND charity_status_id IS NULL AND incorporation_date IS NULL AND dissolution_date IS NULL)
       OR NOT EXISTS (SELECT 1 FROM establishment.establishment_party_role WHERE establishment_party_role_id=role_id
                      AND start_date IS NULL AND end_date IS NULL AND person_id IS NULL)
       OR (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=entity_id)<>1
       OR (SELECT count(*) FROM establishment.group_identifier WHERE establishment_party_role_id=role_id)<>1
       OR EXISTS (SELECT 1 FROM establishment.organisation_identifier WHERE legal_entity_id=entity_id)
       OR EXISTS (SELECT 1 FROM establishment.academy_trust_classification WHERE legal_entity_id=entity_id) THEN
        RAISE EXCEPTION 'T6 must retain one foundation role without invented dates, legal type or external identifiers';
    END IF;

    SELECT r.establishment_responsibility_id INTO STRICT responsibility_id
    FROM establishment.establishment_responsibility r
    JOIN establishment.establishment e USING (establishment_id)
    JOIN establishment.establishment_responsibility_type rt USING (responsibility_type_id)
    JOIN establishment.establishment_type et USING (establishment_type_id)
    JOIN establishment.establishment_lifecycle lifecycle USING (establishment_id)
    WHERE e.urn=132141 AND e.name='Hadrian Park Primary School' AND et.name='Foundation school'
      AND lifecycle.open_date=DATE '2001-09-01' AND lifecycle.close_date IS NULL
      AND r.legal_entity_id=entity_id AND rt.name='Supported by foundation trust'
      AND r.start_date=DATE '2011-09-01' AND r.end_date IS NULL AND r.is_current
      AND r.academy_trust_type_id IS NULL AND r.person_id IS NULL;

    IF (SELECT count(*) FROM establishment.establishment_responsibility WHERE legal_entity_id=entity_id)<>1
       OR (SELECT count(*) FROM establishment.establishment_responsibility r
           JOIN establishment.establishment e USING (establishment_id) WHERE e.urn=132141)<>1
       OR EXISTS (SELECT 1 FROM establishment.organisation_group_member m
                  JOIN establishment.establishment e USING (establishment_id) WHERE e.urn=132141)
       OR EXISTS (SELECT 1 FROM establishment.group_identifier i
                  JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
                  WHERE t.name='Group UID' AND i.value='1596') THEN
        RAISE EXCEPTION 'T6 must not import other trust links, group membership or same-name UID 1596';
    END IF;

    IF (SELECT count(*)
        FROM migration.establishment_responsibility_evidence re
        JOIN migration.source_record source USING (source_record_id)
        JOIN migration.source_snapshot snapshot USING (source_snapshot_id)
        JOIN migration.migration_run run USING (migration_run_id)
        JOIN migration.establishment_party_role_evidence pe USING (source_record_id)
        JOIN migration.identity_resolution identity USING (source_record_id)
        WHERE re.establishment_responsibility_id=responsibility_id AND pe.establishment_party_role_id=role_id
          AND source.source_group_id='1337' AND source.source_urn=132141 AND source.source_key='1337:132141'
          AND run.run_type='establishment-rebuild'
          AND re.end_date_basis IS NULL AND pe.end_date_basis IS NULL
          AND pe.first_observed_date=snapshot.snapshot_date
          AND re.notes LIKE '%Source GroupLink 1029: archived=0;%'
          AND pe.notes LIKE '%source group openDate=2010-09-03;%'
          AND identity.target_entity_type='legal_entity' AND identity.target_entity_id=entity_id
          AND identity.resolution_method='new-separate-source-party'
          AND identity.confidence='provisional' AND identity.decision_status='accepted')<>1 THEN
        RAISE EXCEPTION 'T6 requires shared source-link, observation and provisional-identity evidence under the rebuild run';
    END IF;
END $$;
