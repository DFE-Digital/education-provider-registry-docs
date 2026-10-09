DO $$
DECLARE group_id uuid;
BEGIN
 SELECT i.organisation_group_id INTO STRICT group_id
 FROM establishment.group_identifier i JOIN establishment.group_identifier_type t USING(group_identifier_type_id)
 JOIN establishment.group_identifier_issuer issuer USING(group_identifier_issuer_id)
 WHERE t.name='Group UID' AND issuer.name='GIAS' AND i.value='86008'
 AND i.is_current AND i.establishment_party_role_id IS NULL;
 IF NOT EXISTS (SELECT 1 FROM establishment.organisation_group g
 JOIN establishment.organisation_group_type gt USING(organisation_group_type_id)
 JOIN establishment.local_authority la USING(local_authority_id)
 WHERE g.organisation_group_id=group_id AND g.name='Hazelbury' AND gt.name='Children''s-centre group'
 AND la.code=308 AND g.open_date=DATE '2015-09-01' AND g.close_date IS NULL)
 THEN RAISE EXCEPTION 'T19R group identity, authority or formation date incorrect'; END IF;
 IF (SELECT count(*) FROM establishment.organisation_group_member WHERE organisation_group_id=group_id)<>7
 OR (SELECT count(*) FROM establishment.organisation_group_member m
 JOIN establishment.establishment e USING(establishment_id)
 JOIN establishment.establishment_geography geo USING(establishment_id)
 JOIN establishment.local_authority la USING(local_authority_id)
 JOIN establishment.establishment_lifecycle life USING(establishment_id)
 JOIN establishment.establishment_type et USING(establishment_type_id)
 JOIN (VALUES
 (20048,'Carterhatch Bell Lane Children''s Centre',DATE '2008-03-31'),
 (20575,'Carterhatch Autumn Close Children''s Centre',DATE '2007-09-16'),
 (21240,'Bowes and Garfield Children''s Centre',DATE '2006-09-27'),
 (21423,'Hazelbury Children''s Centre',DATE '2006-09-27'),
 (21425,'Hazelwood Children''s Centre',DATE '2009-09-30'),
 (21547,'Honilands Children''s Centre',DATE '2008-01-23'),
 (22423,'Prince of Wales Childrens Centre',DATE '2008-01-23')) x(urn,name,opened)
 ON e.urn=x.urn AND e.name=x.name AND life.open_date=x.opened
 WHERE m.organisation_group_id=group_id AND la.code=308 AND et.name='Children''s centre'
 AND e.ukprn IS NULL AND e.establishment_number IS NULL AND life.close_date IS NULL
 AND m.joined_date=DATE '2016-02-01' AND m.left_date IS NULL
 AND EXISTS (SELECT 1 FROM establishment.organisation_group_member_lead_period p WHERE p.organisation_group_member_id=m.organisation_group_member_id AND p.is_current) = (e.urn=21423))<>7
 THEN RAISE EXCEPTION 'T19R requires seven exact centres with original lifecycle dates, later membership and explicit lead flags'; END IF;
 IF (SELECT count(*) FROM establishment.organisation_group_member_lead_period WHERE organisation_group_id=group_id)<>1
 OR NOT EXISTS (SELECT 1 FROM establishment.organisation_group_member_lead_period p
 JOIN establishment.organisation_group_member m USING(organisation_group_member_id)
 JOIN establishment.establishment e USING(establishment_id)
 WHERE p.organisation_group_id=group_id AND e.urn=21423 AND p.is_current
 AND p.start_date IS NULL AND p.end_date IS NULL)
 THEN RAISE EXCEPTION 'T19R requires one current Hazelbury lead assertion with unknown business boundaries'; END IF;
 IF (SELECT count(*) FROM establishment.group_identifier WHERE organisation_group_id=group_id)<>1
 OR EXISTS (SELECT 1 FROM establishment.establishment_responsibility r JOIN establishment.establishment e USING(establishment_id)
 WHERE e.urn IN(20048,20575,21240,21423,21425,21547,22423))
 THEN RAISE EXCEPTION 'T19R must not invent Group ID or operating responsibilities'; END IF;
 IF (SELECT count(DISTINCT e.urn) FROM migration.organisation_group_member_evidence evidence
 JOIN establishment.organisation_group_member m USING(organisation_group_member_id)
 JOIN establishment.establishment e USING(establishment_id)
 JOIN migration.source_record s USING(source_record_id)
 JOIN (VALUES(20048,'23702'),(20575,'23703'),(21240,'23698'),(21423,'23697'),(21425,'23699'),(21547,'23700'),(22423,'23701')) x(urn,link)
 ON e.urn=x.urn AND s.source_key=x.link
 WHERE m.organisation_group_id=group_id AND s.source_group_id='86008' AND s.source_urn=e.urn
 AND evidence.review_status='accepted' AND evidence.left_date_basis IS NULL
 AND evidence.notes LIKE '%archived=0%'
 AND evidence.notes LIKE CASE WHEN e.urn=21423 THEN '%ccLinkType=LEAD%' ELSE '%ccLinkType=STANDARD%' END
 AND evidence.notes NOT LIKE '%not the complete source group%')<>7
 THEN RAISE EXCEPTION 'T19R requires complete-scope evidence retaining each explicit lead code'; END IF;
END $$;
SELECT 'T19R Hazelbury checks passed' AS result;
