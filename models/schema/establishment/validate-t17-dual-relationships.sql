DO $$
DECLARE school uuid; federation uuid; member uuid; party uuid; role_id uuid; responsibility uuid;
BEGIN
 SELECT e.establishment_id INTO STRICT school FROM establishment.establishment e
 JOIN establishment.establishment_type t USING(establishment_type_id)
 JOIN establishment.establishment_lifecycle l USING(establishment_id)
 WHERE e.urn=103630 AND e.name='Langley School' AND e.ukprn=10077032
  AND t.name='Foundation special school' AND l.open_date IS NULL AND l.close_date=DATE '2020-06-16';
 SELECT g.organisation_group_id INTO STRICT federation FROM establishment.group_identifier i
 JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
 JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
 JOIN establishment.organisation_group g USING(organisation_group_id)
 JOIN establishment.organisation_group_type gt USING(organisation_group_type_id)
 WHERE t.name='Group UID' AND i.value='1537' AND issuer.name='GIAS' AND NOT i.is_current
  AND i.establishment_party_role_id IS NULL AND gt.name='Federation' AND g.local_authority_id IS NULL
  AND g.name='The Federation of Beaufort School and Langley School'
  AND g.open_date=DATE '2012-04-01' AND g.close_date=DATE '2020-07-01';
 SELECT organisation_group_member_id INTO STRICT member FROM establishment.organisation_group_member
 WHERE organisation_group_id=federation AND establishment_id=school AND joined_date=DATE '2012-04-01'
  AND left_date=DATE '2020-06-16' AND is_lead_member IS NULL;
 SELECT r.legal_entity_id,r.establishment_party_role_id INTO STRICT party,role_id
 FROM establishment.group_identifier i JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
 JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
 JOIN establishment.establishment_party_role r USING(establishment_party_role_id)
 JOIN establishment.establishment_party_role_type rt USING(establishment_party_role_type_id)
 WHERE t.name='Group UID' AND i.value='1650' AND issuer.name='GIAS' AND i.is_current
  AND i.organisation_group_id IS NULL AND rt.name='Foundation trust' AND r.person_id IS NULL
  AND r.start_date IS NULL AND r.end_date IS NULL;
 IF NOT EXISTS(SELECT 1 FROM establishment.legal_entity WHERE legal_entity_id=party
   AND name='Four Oaks Learning Trust For Excellence' AND legal_entity_type_id IS NULL
   AND charity_status_id IS NULL AND incorporation_date IS NULL AND dissolution_date IS NULL)
  OR EXISTS(SELECT 1 FROM establishment.organisation_identifier WHERE legal_entity_id=party)
  OR EXISTS(SELECT 1 FROM establishment.academy_trust_classification WHERE legal_entity_id=party)
  OR (SELECT count(*) FROM establishment.group_identifier WHERE establishment_party_role_id=role_id)<>1
  OR (SELECT count(*) FROM establishment.establishment_party_role WHERE legal_entity_id=party)<>1
 THEN RAISE EXCEPTION 'T17 foundation identity or unknown role/company facts are incorrect'; END IF;
 SELECT r.establishment_responsibility_id INTO STRICT responsibility FROM establishment.establishment_responsibility r
 JOIN establishment.establishment_responsibility_type t USING(responsibility_type_id)
 WHERE r.establishment_id=school AND r.legal_entity_id=party AND t.name='Supported by foundation trust'
  AND r.start_date=DATE '2013-05-20' AND r.end_date=DATE '2020-06-16' AND NOT r.is_current
  AND r.academy_trust_type_id IS NULL AND r.person_id IS NULL;
 IF (SELECT count(*) FROM establishment.organisation_group_member WHERE establishment_id=school)<>1
  OR (SELECT count(*) FROM establishment.organisation_group_member WHERE organisation_group_id=federation)<>1
  OR (SELECT count(*) FROM establishment.group_identifier WHERE organisation_group_id=federation)<>1
  OR (SELECT count(*) FROM establishment.establishment_responsibility WHERE establishment_id=school)<>1
  OR (SELECT count(*) FROM establishment.establishment_responsibility WHERE legal_entity_id=party)<>1
 THEN RAISE EXCEPTION 'T17 imported unselected relationships or restated membership as responsibility'; END IF;
 IF NOT EXISTS(
  SELECT 1 FROM migration.organisation_group_member_evidence ev
  JOIN migration.source_record sr USING(source_record_id)
  WHERE ev.organisation_group_member_id=member AND ev.left_date_basis='inferred'
   AND sr.source_group_id='1537' AND sr.source_urn=103630 AND sr.source_key='1245'
   AND ev.notes LIKE '%archived=1;%' AND ev.notes LIKE '%supplied URNs only;%'
 ) OR NOT EXISTS(
  SELECT 1 FROM migration.establishment_responsibility_evidence ev
  JOIN migration.source_record sr USING(source_record_id)
  JOIN migration.identity_resolution ir USING(source_record_id)
  JOIN migration.establishment_party_role_evidence pe USING(source_record_id)
  JOIN migration.source_snapshot snapshot USING(source_snapshot_id)
  WHERE ev.establishment_responsibility_id=responsibility AND ev.end_date_basis='inferred'
   AND sr.source_group_id='1650' AND sr.source_urn=103630
   AND ev.notes LIKE '%Source GroupLink 1572: archived=0; effectiveDate=2013-05-20.%'
   AND ev.notes LIKE '%responsibility is not current despite the source flag.%'
   AND ir.target_entity_id=party AND ir.confidence='provisional' AND ir.decision_status='accepted'
   AND pe.establishment_party_role_id=role_id AND pe.first_observed_date=snapshot.snapshot_date
 ) THEN RAISE EXCEPTION 'T17 source flags, partial membership scope, identity review or inferred-end evidence are missing'; END IF;
END $$;
SELECT 'T17 dual-relationship checks passed' AS result;
