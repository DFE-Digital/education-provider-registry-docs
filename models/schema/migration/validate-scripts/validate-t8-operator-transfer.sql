DO $$
DECLARE
    school uuid;
    party uuid;
    party_role uuid;
    expected record;
BEGIN
    SELECT e.establishment_id INTO STRICT school
    FROM establishment.establishment e
    JOIN establishment.establishment_lifecycle l USING(establishment_id)
    JOIN establishment.establishment_type t USING(establishment_type_id)
    JOIN establishment.establishment_geography geo USING(establishment_id)
    JOIN establishment.local_authority la USING(local_authority_id)
    WHERE e.urn=136494 AND e.name='Teign School' AND e.ukprn=10033036 AND e.establishment_number=5402
      AND t.name='Mainstream academy' AND la.code=878 AND l.open_date=DATE '2011-03-01' AND l.close_date IS NULL;
    IF (SELECT count(*) FROM establishment.establishment_responsibility WHERE establishment_id=school)<>2
      OR (SELECT count(DISTINCT legal_entity_id) FROM establishment.establishment_responsibility WHERE establishment_id=school)<>2
      OR EXISTS(SELECT 1 FROM establishment.organisation_group_member WHERE establishment_id=school)
    THEN RAISE EXCEPTION 'T8 must have exactly two separate operating parties and no imported sponsorship or membership'; END IF;
    FOR expected IN SELECT * FROM (VALUES
      ('4920','TR02256','TEMPLER ACADEMY SCHOOLS TRUST','07518252','10058494',DATE '2011-02-04',DATE '2011-03-01',false),
      ('3643','TR01237','EDUCATION SOUTH WEST','07451553','10058417',DATE '2010-11-25',DATE '2017-01-01',true)
    ) v(uid,gid,name,company,ukprn,incorporated,started,current)
    LOOP
      SELECT i.legal_entity_id INTO STRICT party FROM establishment.organisation_identifier i
      JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
      WHERE t.name='Companies House number' AND i.value=expected.company AND i.is_current;
      SELECT r.establishment_party_role_id INTO STRICT party_role FROM establishment.establishment_party_role r
      JOIN establishment.establishment_party_role_type t USING(establishment_party_role_type_id)
      WHERE r.legal_entity_id=party AND t.name='Academy trust' AND r.person_id IS NULL
        AND r.start_date IS NULL AND r.end_date IS NULL;
      IF NOT EXISTS(SELECT 1 FROM establishment.legal_entity le JOIN establishment.legal_entity_type t USING(legal_entity_type_id)
        WHERE le.legal_entity_id=party AND le.name=expected.name AND le.incorporation_date=expected.incorporated
          AND le.dissolution_date IS NULL AND le.charity_status_id IS NULL AND t.name='Charitable company limited by guarantee')
        OR (SELECT count(*) FROM establishment.organisation_identifier WHERE legal_entity_id=party)<>2
        OR NOT EXISTS(SELECT 1 FROM establishment.organisation_identifier i JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
          WHERE i.legal_entity_id=party AND t.name='UKPRN' AND i.value=expected.ukprn AND i.is_current)
        OR (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=party)<>1
        OR (SELECT count(*) FROM establishment.group_identifier WHERE establishment_party_role_id=party_role)<>2
        OR (SELECT count(*) FROM establishment.group_identifier i JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
          JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
          WHERE i.establishment_party_role_id=party_role AND issuer.name='GIAS' AND i.is_current AND
            ((t.name='Group UID' AND i.value=expected.uid) OR (t.name='Group ID' AND i.value=expected.gid)))<>2
      THEN RAISE EXCEPTION 'T8 party identity or source-current identifiers incorrect for %',expected.uid; END IF;
      IF (SELECT count(*) FROM establishment.academy_trust_classification WHERE legal_entity_id=party)<>1
        OR NOT EXISTS(SELECT 1 FROM establishment.academy_trust_classification c JOIN establishment.academy_trust_type t USING(academy_trust_type_id)
          WHERE c.legal_entity_id=party AND t.name='Multi-academy trust' AND c.is_current AND c.start_date IS NULL AND c.end_date IS NULL)
        OR NOT EXISTS(SELECT 1 FROM establishment.establishment_responsibility r
          JOIN establishment.establishment_responsibility_type rt USING(responsibility_type_id)
          JOIN establishment.academy_trust_type tt USING(academy_trust_type_id)
          WHERE r.establishment_id=school AND r.legal_entity_id=party AND rt.name='Run by academy trust'
            AND tt.name='Multi-academy trust' AND r.start_date=expected.started AND r.end_date IS NULL AND r.is_current=expected.current)
      THEN RAISE EXCEPTION 'T8 archived relationship incorrectly retires the MAT, or responsibility dates incorrect'; END IF;
      IF NOT EXISTS(SELECT 1 FROM migration.source_record sr
        JOIN migration.identity_resolution ir USING(source_record_id)
        JOIN migration.establishment_party_role_evidence pe USING(source_record_id)
        JOIN migration.academy_trust_classification_evidence ce USING(source_record_id)
        JOIN migration.establishment_responsibility_evidence re USING(source_record_id)
        WHERE sr.source_urn=136494 AND sr.source_group_id=expected.uid
          AND ir.target_entity_id=party AND ir.decision_status='accepted'
          AND pe.establishment_party_role_id=party_role AND ce.assertion_rule='MR001'
          AND re.end_date_basis IS NULL AND re.notes LIKE 'T8 separate MAT operators:%'
          AND re.notes LIKE '%7097 (archived=1, effectiveDate=2011-03-01)%'
          AND re.notes LIKE '%26320 (archived=0, effectiveDate=2017-01-01)%')
      THEN RAISE EXCEPTION 'T8 source flags, source-current MAT or unknown-end evidence missing'; END IF;
    END LOOP;
END $$;
SELECT 'T8 operator-transfer checks passed' AS result;
