-- Bounded correction of the earlier T22 one-entity assumption.
-- Called inside the runner's rollback/commit transaction after reader preflight.
-- Preserve existing UUIDs and registered identifier ownership. No rows deleted.
DO $$
DECLARE
    current_party uuid;
    historical_party uuid;
    current_party_role uuid;
    historical_role uuid;
    mapped_count integer;
BEGIN
    SELECT count(*) INTO mapped_count FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
    WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value IN('16279','17115','17397');
    IF mapped_count=0 THEN RETURN; END IF;
    IF mapped_count<>3 THEN RAISE EXCEPTION 'T22 correction requires all three existing mappings or a fresh target'; END IF;
    SELECT r.legal_entity_id,r.establishment_party_role_id INTO STRICT current_party,current_party_role
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.establishment_party_role r USING (establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value='17397';
    SELECT r.legal_entity_id INTO STRICT historical_party
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
    JOIN establishment.establishment_party_role r USING (establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value='16279';
    IF historical_party<>current_party THEN RETURN; END IF;
    IF (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=current_party)<>1
      OR (SELECT count(*) FROM establishment.group_identifier WHERE establishment_party_role_id=current_party_role)<>6
      OR (SELECT count(*) FROM establishment.group_identifier i
        JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
        WHERE i.establishment_party_role_id=current_party_role
          AND ((t.name='Group UID' AND i.value IN('16279','17115','17397'))
            OR (t.name='Group ID' AND i.value IN('TR03305.old','TR03305.old2','TR03305'))))<>6
      OR (SELECT count(*) FROM establishment.establishment_responsibility WHERE legal_entity_id=current_party)<>3
      OR (SELECT count(*) FROM establishment.establishment_responsibility r
        JOIN establishment.establishment e USING (establishment_id)
        WHERE r.legal_entity_id=current_party AND e.urn=142869
          AND r.start_date IN(DATE '2016-09-01',DATE '2018-10-09',DATE '2019-07-09')
          AND r.end_date IS NULL)<>3
      OR (SELECT count(*) FROM establishment.academy_trust_classification WHERE legal_entity_id=current_party)<>3
      OR (SELECT count(*) FROM establishment.organisation_identifier WHERE legal_entity_id=current_party)<>2
      OR NOT EXISTS (SELECT 1 FROM establishment.organisation_identifier i
        JOIN establishment.organisation_identifier_type t USING (organisation_identifier_type_id)
        WHERE i.legal_entity_id=current_party AND t.name='Companies House number' AND i.value='08782697' AND i.is_current)
      OR NOT EXISTS (SELECT 1 FROM migration.identity_resolution ir
        JOIN migration.source_record sr USING(source_record_id)
        WHERE sr.source_urn=142869 AND sr.source_group_id='16279'
          AND ir.target_entity_id=current_party
          AND ir.rationale LIKE 'T22 reviewed bounded identity mapping:%')
    THEN RAISE EXCEPTION 'T22 correction scope differs from the prior one-entity migration; manual review required'; END IF;

    INSERT INTO establishment.legal_entity(name)
      VALUES ('THE NORTHAMPTON FREE SCHOOL TRUST') RETURNING legal_entity_id INTO historical_party;
    INSERT INTO establishment.establishment_party_role(legal_entity_id,establishment_party_role_type_id)
      SELECT historical_party,establishment_party_role_type_id
      FROM establishment.establishment_party_role WHERE establishment_party_role_id=current_party_role
      RETURNING establishment_party_role_id INTO historical_role;

    UPDATE establishment.group_identifier i SET establishment_party_role_id=historical_role
      FROM establishment.group_identifier_type t
      WHERE i.group_identifier_type_id=t.group_identifier_type_id AND i.establishment_party_role_id=current_party_role
        AND ((t.name='Group UID' AND i.value IN('16279','17115'))
          OR (t.name='Group ID' AND i.value IN('TR03305.old','TR03305.old2')));
    UPDATE establishment.establishment_responsibility SET legal_entity_id=historical_party
      WHERE legal_entity_id=current_party AND start_date IN(DATE '2016-09-01',DATE '2018-10-09');
    UPDATE establishment.academy_trust_classification c SET legal_entity_id=historical_party
      FROM establishment.academy_trust_type t
      WHERE c.academy_trust_type_id=t.academy_trust_type_id AND c.legal_entity_id=current_party
        AND ((t.name='Single-academy trust' AND c.start_date IS NULL)
          OR (t.name='Multi-academy trust' AND c.start_date=DATE '2018-10-09'));
    UPDATE establishment.academy_trust_classification SET start_date=NULL
      WHERE legal_entity_id=current_party AND start_date=DATE '2019-07-09' AND is_current;

    -- Keep the previous decision and its evidence as an audit trail, not an
    -- accepted assertion. The revised loaders append new accepted evidence.
    UPDATE migration.identity_resolution ir SET decision_status='superseded',
      rationale=ir.rationale || ' Superseded on 2026-10-09 by the user assertion: historical pair is one entity; current SAT is separate.'
      FROM migration.source_record sr WHERE ir.source_record_id=sr.source_record_id
        AND sr.source_urn=142869 AND sr.source_group_id IN('16279','17115','17397')
        AND ir.rationale LIKE 'T22 reviewed bounded identity mapping:%';
    UPDATE migration.establishment_party_role_evidence pe SET review_status='superseded'
      FROM migration.source_record sr WHERE pe.source_record_id=sr.source_record_id
        AND sr.source_urn=142869 AND sr.source_group_id IN('16279','17115','17397')
        AND pe.notes LIKE 'T22 reviewed bounded identity mapping:%';
    UPDATE migration.academy_trust_classification_evidence ce SET review_status='superseded'
      FROM migration.source_record sr WHERE ce.source_record_id=sr.source_record_id
        AND sr.source_urn=142869 AND sr.source_group_id IN('16279','17115','17397')
        AND ce.notes LIKE 'T22 reviewed bounded identity mapping:%';
    UPDATE migration.establishment_responsibility_evidence re SET review_status='superseded'
      FROM migration.source_record sr WHERE re.source_record_id=sr.source_record_id
        AND sr.source_urn=142869 AND sr.source_group_id IN('16279','17115','17397')
        AND re.notes LIKE 'T22 reviewed bounded identity mapping:%';
END $$;
