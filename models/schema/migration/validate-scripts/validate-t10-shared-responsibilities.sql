DO $$
DECLARE party uuid; independent uuid; academy uuid; proprietor uuid;
BEGIN
 SELECT i.legal_entity_id INTO STRICT party FROM establishment.organisation_identifier i
 JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
 WHERE t.name='Companies House number' AND i.value='06995649' AND i.is_current;
 SELECT e.establishment_id INTO STRICT independent FROM establishment.establishment e
 JOIN establishment.establishment_lifecycle l USING(establishment_id)
 JOIN establishment.establishment_status s USING(establishment_status_id)
 JOIN establishment.establishment_geography geo USING(establishment_id)
 JOIN establishment.local_authority la USING(local_authority_id)
 WHERE e.urn=148341 AND e.name='Outwood Alternative Provision Eston' AND e.ukprn=10092329
   AND e.establishment_number=6003 AND e.establishment_type_id=17 AND e.education_phase_id IS NULL
   AND s.name='Open' AND l.open_date=DATE '2021-02-18' AND l.close_date IS NULL AND la.code=807;
 SELECT e.establishment_id INTO STRICT academy FROM establishment.establishment e
 JOIN establishment.establishment_lifecycle l USING(establishment_id)
 JOIN establishment.establishment_status s USING(establishment_status_id)
 JOIN establishment.establishment_geography geo USING(establishment_id)
 JOIN establishment.local_authority la USING(local_authority_id)
 WHERE e.urn=135961 AND e.name='Outwood Grange Academy' AND e.ukprn=10028145 AND e.establishment_number=6905
   AND e.establishment_type_id=4 AND s.name='Open' AND l.open_date=DATE '2009-09-01' AND l.close_date IS NULL AND la.code=384;
 IF (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=party)<>2
   OR (SELECT count(*) FROM establishment.organisation_identifier WHERE legal_entity_id=party)<>2
   OR NOT EXISTS(SELECT 1 FROM establishment.organisation_identifier i JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
     WHERE i.legal_entity_id=party AND t.name='UKPRN' AND i.value='10058273' AND i.is_current)
   OR NOT EXISTS(SELECT 1 FROM establishment.legal_entity le JOIN establishment.legal_entity_type t USING(legal_entity_type_id)
     WHERE le.legal_entity_id=party AND le.name='OUTWOOD GRANGE ACADEMIES TRUST'
       AND le.incorporation_date=DATE '2009-08-19' AND le.dissolution_date IS NULL AND le.charity_status_id IS NULL
       AND t.name='Charitable company limited by guarantee')
   OR (SELECT count(*) FROM establishment.group_identifier i JOIN establishment.establishment_party_role r USING(establishment_party_role_id)
     WHERE r.legal_entity_id=party)<>4
   OR (SELECT count(*) FROM establishment.group_identifier i JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
     JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
     JOIN establishment.establishment_party_role r USING(establishment_party_role_id)
     JOIN establishment.establishment_party_role_type rt USING(establishment_party_role_type_id)
     JOIN (VALUES('4119','Group UID','Academy trust'),('TR01585','Group ID','Academy trust'),
       ('4118','Group UID','School sponsor'),('SP00396','Group ID','School sponsor')) v(value,type,role)
       ON i.value=v.value AND t.name=v.type AND rt.name=v.role
     WHERE r.legal_entity_id=party AND r.start_date IS NULL AND r.end_date IS NULL AND r.person_id IS NULL
       AND i.is_current AND issuer.name='GIAS')<>4
 THEN RAISE EXCEPTION 'T10 shared company, two roles or role identifier ownership incorrect'; END IF;
 IF (SELECT count(*) FROM establishment.academy_trust_classification WHERE legal_entity_id=party)<>1
   OR NOT EXISTS(SELECT 1 FROM establishment.academy_trust_classification c JOIN establishment.academy_trust_type t USING(academy_trust_type_id)
     WHERE c.legal_entity_id=party AND t.name='Multi-academy trust' AND c.is_current AND c.start_date IS NULL AND c.end_date IS NULL)
   OR (SELECT count(*) FROM establishment.establishment_responsibility WHERE establishment_id IN(independent,academy))<>3
   OR (SELECT count(*) FROM establishment.establishment_responsibility r JOIN establishment.establishment_responsibility_type rt USING(responsibility_type_id)
     LEFT JOIN establishment.academy_trust_type tt USING(academy_trust_type_id)
     WHERE r.legal_entity_id=party AND r.person_id IS NULL AND r.is_current AND r.end_date IS NULL
       AND ((r.establishment_id=academy AND r.start_date=DATE '2009-09-01'
         AND ((rt.name='Run by academy trust' AND tt.name='Multi-academy trust') OR (rt.name='Sponsored by' AND r.academy_trust_type_id IS NULL)))
       OR (r.establishment_id=independent AND rt.name='Proprietor' AND r.start_date IS NULL AND r.academy_trust_type_id IS NULL)))<>3
   OR EXISTS(SELECT 1 FROM establishment.organisation_group_member WHERE establishment_id IN(independent,academy))
 THEN RAISE EXCEPTION 'T10 three distinct shared-party responsibilities or MAT classification incorrect'; END IF;
 SELECT r.establishment_responsibility_id INTO STRICT proprietor FROM establishment.establishment_responsibility r
 JOIN establishment.establishment_responsibility_type t USING(responsibility_type_id)
 WHERE r.establishment_id=independent AND t.name='Proprietor';
 IF NOT EXISTS(SELECT 1 FROM migration.establishment_responsibility_evidence re
   JOIN migration.source_record sr USING(source_record_id) JOIN migration.source_snapshot ss USING(source_snapshot_id)
   JOIN migration.identity_resolution ir USING(source_record_id)
   WHERE re.establishment_responsibility_id=proprietor AND re.first_observed_date=DATE '2026-06-16'
     AND re.end_date_basis IS NULL AND ss.source_system='GIAS public extract' AND ss.snapshot_date=DATE '2026-06-16'
     AND ir.target_entity_type='legal_entity' AND ir.target_entity_id=party AND ir.confidence='assumed'
     AND ir.decision_status='accepted' AND re.notes LIKE 'T10 approved PropsName=Outwood Grange Academies Trust;%')
   OR NOT EXISTS(SELECT 1 FROM migration.establishment_responsibility_evidence re
     JOIN migration.source_record sr USING(source_record_id) JOIN migration.source_snapshot ss USING(source_snapshot_id)
     WHERE re.establishment_responsibility_id=proprietor AND ss.source_system='GIAS BAU'
       AND re.notes LIKE 'T10 rejected local values retained as context only:%'
       AND re.notes LIKE '%2018-11-10%' AND re.notes LIKE '%"status_code": "8"%'
       AND re.notes LIKE '%"local_authority_code": "865"%' AND re.notes LIKE '%"proprietortype_code": "03"%')
   OR NOT EXISTS(SELECT 1 FROM migration.identity_resolution ir JOIN migration.source_record sr USING(source_record_id)
     WHERE sr.source_urn=148341 AND ir.target_entity_type='establishment' AND ir.target_entity_id=independent
       AND ir.resolution_method='accepted-controlled-establishment' AND ir.decision_status='accepted'
       AND ir.rationale LIKE '%T10 user-approved controlled establishment%')
   OR (SELECT count(DISTINCT sr.source_group_id) FROM migration.source_record sr
     JOIN migration.identity_resolution ir USING(source_record_id)
     WHERE sr.source_urn=135961 AND sr.source_group_id IN('4118','4119') AND ir.target_entity_id=party
       AND ir.confidence='assumed' AND ir.rationale LIKE 'T10 accepted shared-party assumption:%')<>2
 THEN RAISE EXCEPTION 'T10 accepted extract, rejected local context or approved identity/lifecycle decision missing'; END IF;
END $$;
SELECT 'T10 shared-responsibility checks passed' AS result;
