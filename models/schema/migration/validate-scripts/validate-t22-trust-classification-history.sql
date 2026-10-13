DO $$
DECLARE
    school uuid;
    party uuid;
    party_role uuid;
    historical uuid;
    historical_role uuid;
BEGIN
    SELECT e.establishment_id INTO STRICT school
    FROM establishment.establishment e
    JOIN establishment.establishment_lifecycle l USING (establishment_id)
    JOIN establishment.establishment_type t USING (establishment_type_id)
    JOIN establishment.establishment_geography geo USING (establishment_id)
    JOIN establishment.local_authority la USING (local_authority_id)
    WHERE e.urn=142869 AND e.name='Wootton Park School' AND e.ukprn=10056995
      AND e.establishment_number=4020 AND t.name='Free schools' AND la.code=928
      AND l.open_date=DATE '2016-09-01' AND l.close_date IS NULL;
    SELECT i.legal_entity_id INTO STRICT party
    FROM establishment.organisation_identifier i
    JOIN establishment.organisation_identifier_type t USING (organisation_identifier_type_id)
    WHERE t.name='Companies House number' AND i.value='08782697' AND i.is_current;
    SELECT role.establishment_party_role_id INTO STRICT party_role
    FROM establishment.establishment_party_role role
    JOIN establishment.establishment_party_role_type t USING (establishment_party_role_type_id)
    WHERE role.legal_entity_id=party AND t.name='Academy trust'
      AND role.person_id IS NULL AND role.start_date IS NULL AND role.end_date IS NULL;
    SELECT role.legal_entity_id,role.establishment_party_role_id INTO STRICT historical,historical_role
    FROM establishment.group_identifier i
    JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
    JOIN establishment.establishment_party_role role USING(establishment_party_role_id)
    WHERE t.name='Group UID' AND i.value='16279';
    IF historical=party OR historical_role=party_role
      OR NOT EXISTS (SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id=historical
        AND name='THE NORTHAMPTON FREE SCHOOL TRUST' AND incorporation_date IS NULL
        AND dissolution_date IS NULL AND legal_entity_type_id IS NULL AND charity_status_id IS NULL)
      OR EXISTS (SELECT 1 FROM establishment.organisation_identifier WHERE legal_entity_id=historical)
      OR (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=historical)<>1
      OR NOT EXISTS (SELECT 1 FROM establishment.establishment_party_role r
        JOIN establishment.establishment_party_role_type t USING(establishment_party_role_type_id)
        WHERE r.establishment_party_role_id=historical_role AND t.name='Academy trust'
          AND r.start_date IS NULL AND r.end_date IS NULL AND r.person_id IS NULL)
    THEN RAISE EXCEPTION 'T22 historical pair must be one separate provisional entity without borrowed identifiers'; END IF;
    IF NOT EXISTS (SELECT 1 FROM establishment.legal_entity le
      JOIN establishment.legal_entity_type t USING (legal_entity_type_id)
      WHERE le.legal_entity_id=party AND le.name='WOOTTON PARK ACADEMY TRUST'
        AND le.incorporation_date=DATE '2013-11-20' AND le.dissolution_date IS NULL
        AND le.charity_status_id IS NULL AND t.name='Charitable company limited by guarantee')
      OR (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=party)<>1
      OR (SELECT count(*) FROM establishment.organisation_identifier WHERE legal_entity_id=party)<>2
      OR NOT EXISTS (SELECT 1 FROM establishment.organisation_identifier i
        JOIN establishment.organisation_identifier_type t USING (organisation_identifier_type_id)
        WHERE i.legal_entity_id=party AND t.name='UKPRN' AND i.value='10064301' AND i.is_current)
    THEN RAISE EXCEPTION 'T22 legal identity or continuing role incorrect'; END IF;

    IF (SELECT count(*) FROM establishment.academy_trust_classification WHERE legal_entity_id=party)<>1
      OR (SELECT count(*) FROM establishment.academy_trust_classification WHERE legal_entity_id=historical)<>2
      OR (SELECT count(*) FROM establishment.academy_trust_classification c
        JOIN establishment.academy_trust_type t USING (academy_trust_type_id)
        JOIN (VALUES
          (historical,'Single-academy trust',NULL::date,DATE '2018-10-09',false),
          (historical,'Multi-academy trust',DATE '2018-10-09',DATE '2019-07-09',false),
          (party,'Single-academy trust',NULL::date,NULL::date,true)
        ) v(owner,type,started,ended,current) ON t.name=v.type
        WHERE c.legal_entity_id=v.owner AND c.start_date IS NOT DISTINCT FROM v.started
          AND c.end_date IS NOT DISTINCT FROM v.ended AND c.is_current=v.current)<>3
    THEN RAISE EXCEPTION 'T22 two-entity classification ownership or unknown current SAT start incorrect'; END IF;

    IF (SELECT count(*) FROM establishment.establishment_responsibility WHERE establishment_id=school)<>3
      OR (SELECT count(*) FROM establishment.establishment_responsibility r
        JOIN establishment.establishment_responsibility_type rt USING (responsibility_type_id)
        JOIN establishment.academy_trust_type tt USING (academy_trust_type_id)
        JOIN (VALUES (historical,'Single-academy trust',DATE '2016-09-01',false),
          (historical,'Multi-academy trust',DATE '2018-10-09',false),
          (party,'Single-academy trust',DATE '2019-07-09',true)) v(owner,type,started,current) ON tt.name=v.type
        WHERE r.establishment_id=school AND r.legal_entity_id=v.owner AND r.person_id IS NULL
          AND rt.name='Run by academy trust' AND r.start_date=v.started
          AND r.end_date IS NULL AND r.is_current=v.current)<>3
      OR EXISTS (SELECT 1 FROM establishment.organisation_group_member WHERE establishment_id=school)
    THEN RAISE EXCEPTION 'T22 responsibility history or scope incorrect'; END IF;

    IF (SELECT count(*) FROM establishment.group_identifier WHERE establishment_party_role_id=party_role)<>2
      OR (SELECT count(*) FROM establishment.group_identifier WHERE establishment_party_role_id=historical_role)<>4
      OR (SELECT count(*) FROM establishment.group_identifier i
        JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
        JOIN establishment.group_identifier_issuer issuer USING (group_identifier_issuer_id)
        JOIN (VALUES (historical_role,'Group UID','16279',false),(historical_role,'Group UID','17115',false),(party_role,'Group UID','17397',true),
          (historical_role,'Group ID','TR03305.old',false),(historical_role,'Group ID','TR03305.old2',false),(party_role,'Group ID','TR03305',true)
        ) v(owner,type,value,current) ON t.name=v.type AND i.value=v.value
        WHERE i.establishment_party_role_id=v.owner AND i.organisation_group_id IS NULL
          AND issuer.name='GIAS' AND i.is_current=v.current)<>6
    THEN RAISE EXCEPTION 'T22 exact historical and current identifiers incorrect'; END IF;

    IF (SELECT count(DISTINCT sr.source_group_id)
      FROM migration.source_record sr
      JOIN migration.identity_resolution ir USING (source_record_id)
      JOIN migration.academy_trust_classification_evidence ce USING (source_record_id)
      JOIN migration.establishment_responsibility_evidence re USING (source_record_id)
      JOIN migration.establishment_party_role_evidence pe USING (source_record_id)
      WHERE sr.source_urn=142869 AND sr.source_group_id IN ('16279','17115','17397')
        AND ir.target_entity_id=CASE WHEN sr.source_group_id='17397' THEN party ELSE historical END AND ir.target_entity_type='legal_entity'
        AND ir.resolution_method='accepted-two-entity-test-case-assertion'
        AND ir.confidence='assumed' AND ir.decision_status='accepted'
        AND ir.rationale LIKE 'T22 accepted two-entity assertion:%'
        AND ce.notes LIKE '%this is not a return to SAT within that entity%'
        AND ce.review_status='accepted' AND pe.review_status='accepted' AND re.review_status='accepted'
        AND re.end_date_basis IS NULL AND pe.establishment_party_role_id=CASE WHEN sr.source_group_id='17397' THEN party_role ELSE historical_role END)<>3
    THEN RAISE EXCEPTION 'T22 reviewed identity and explicit/inferred transition evidence missing'; END IF;
END $$;
SELECT 'T22 trust-classification-history checks passed' AS result;
