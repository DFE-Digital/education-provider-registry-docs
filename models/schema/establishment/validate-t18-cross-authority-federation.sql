DO $$
DECLARE federation_id uuid;
BEGIN
 SELECT i.organisation_group_id INTO STRICT federation_id
 FROM establishment.group_identifier i
 JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
 JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
 WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='1761'
 AND i.is_current AND i.establishment_party_role_id IS NULL;
 IF NOT EXISTS (SELECT 1 FROM establishment.organisation_group g
 JOIN establishment.organisation_group_type gt USING(organisation_group_type_id)
 WHERE g.organisation_group_id=federation_id AND gt.name='Federation'
 AND g.name='The Federation of St Elphege''s RC School' AND g.local_authority_id IS NULL
 AND g.open_date=DATE '2006-01-01' AND g.close_date IS NULL)
 THEN RAISE EXCEPTION 'T18 federation identity, dates or absent authority incorrect'; END IF;
 IF (SELECT count(*) FROM establishment.organisation_group_member WHERE organisation_group_id=federation_id)<>3
 OR (SELECT count(*) FROM establishment.organisation_group_member m
 JOIN establishment.establishment e USING(establishment_id)
 JOIN establishment.establishment_geography geo USING(establishment_id)
 JOIN establishment.local_authority la USING(local_authority_id)
 JOIN establishment.establishment_lifecycle life USING(establishment_id)
 JOIN establishment.establishment_type et USING(establishment_type_id)
 WHERE m.organisation_group_id=federation_id AND m.left_date IS NULL
 AND life.open_date IS NULL AND life.close_date IS NULL AND et.name='Voluntary aided school'
 AND ((e.urn=101800 AND e.name='Regina Coeli Catholic Primary School' AND e.ukprn=10071655 AND la.code=306 AND m.joined_date=DATE '2014-09-15')
 OR (e.urn=102996 AND e.name='St Elphege''s RC Junior School' AND e.ukprn=10079489 AND la.code=319 AND m.joined_date=DATE '2006-01-01')
 OR (e.urn=102997 AND e.name='St Elphege''s RC Infants'' School' AND e.ukprn=10078365 AND la.code=319 AND m.joined_date=DATE '2006-01-01')))<>3
 THEN RAISE EXCEPTION 'T18 requires three independently dated members retaining their own authorities and identifiers'; END IF;
 IF (SELECT count(*) FROM establishment.group_identifier WHERE organisation_group_id=federation_id)<>1
 OR EXISTS (SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id) WHERE e.urn IN(101800,102996,102997))
 OR EXISTS (SELECT 1 FROM establishment.organisation_group_member_lead_period p WHERE p.organisation_group_id=federation_id)
 THEN RAISE EXCEPTION 'T18 must not invent Group ID, responsibilities or lead periods'; END IF;
 IF (SELECT count(DISTINCT e.urn) FROM migration.organisation_group_member_evidence evidence
 JOIN establishment.organisation_group_member m USING(organisation_group_member_id)
 JOIN establishment.establishment e USING(establishment_id)
 JOIN migration.source_record s USING(source_record_id)
 WHERE m.organisation_group_id=federation_id AND s.source_group_id='1761' AND s.source_urn=e.urn
 AND ((e.urn=101800 AND s.source_key='2517') OR(e.urn=102996 AND s.source_key='1811') OR(e.urn=102997 AND s.source_key='1812'))
 AND evidence.review_status='accepted' AND evidence.left_date_basis IS NULL
 AND evidence.notes LIKE '%archived=0%' AND evidence.notes LIKE '%linkType=HARD%'
 AND evidence.notes NOT LIKE '%not the complete source group%')<>3
 THEN RAISE EXCEPTION 'T18 requires complete-scope active link evidence, with unknown leaving dates'; END IF;
END $$;
SELECT 'T18 cross-authority federation checks passed' AS result;
