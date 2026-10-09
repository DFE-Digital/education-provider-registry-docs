-- Reviewed complete Hazelbury group, including independently dated membership.
IF NOT EXISTS (SELECT 1 FROM dbo.EstablishmentGroup WHERE id=86008 AND name='Hazelbury'
 AND type_code='08' AND localAuthority_code='308' AND CONVERT(date,openDate)='2015-09-01'
 AND closedDate IS NULL AND groupId IS NULL AND companiesHouseNumber IS NULL AND UKPRN IS NULL)
 THROW 50001, 'T19R group source assertions changed.', 1;
DECLARE @expected table(urn int,link_id int,name varchar(100),opened date,lead_code varchar(8));
INSERT INTO @expected VALUES
 (20048,23702,'Carterhatch Bell Lane Children''s Centre','2008-03-31','STANDARD'),
 (20575,23703,'Carterhatch Autumn Close Children''s Centre','2007-09-16','STANDARD'),
 (21240,23698,'Bowes and Garfield Children''s Centre','2006-09-27','STANDARD'),
 (21423,23697,'Hazelbury Children''s Centre','2006-09-27','LEAD'),
 (21425,23699,'Hazelwood Children''s Centre','2009-09-30','STANDARD'),
 (21547,23700,'Honilands Children''s Centre','2008-01-23','STANDARD'),
 (22423,23701,'Prince of Wales Childrens Centre','2008-01-23','STANDARD');
IF (SELECT count(*) FROM dbo.GroupLink WHERE group_id=86008)<>7
 OR (SELECT count(*) FROM dbo.GroupLink WHERE urn IN(SELECT urn FROM @expected))<>7
 OR EXISTS (SELECT 1 FROM dbo.GroupRelationsLink WHERE linked_group=86008 OR linking_group=86008)
 OR EXISTS (SELECT 1 FROM @expected x WHERE NOT EXISTS (
 SELECT 1 FROM dbo.GroupLink gl JOIN dbo.Establishment e ON e.URN=gl.urn
 WHERE gl.group_id=86008 AND gl.id=x.link_id AND gl.urn=x.urn AND gl.archived=0
 AND gl.ccLinkType=x.lead_code AND CONVERT(date,gl.effectiveDate)='2016-02-01'
 AND e.EstablishmentName=x.name AND e.LA_code='308' AND e.type_code='47' AND e.status_code='1'
 AND CONVERT(date,e.OpenDate)=x.opened AND e.CloseDate IS NULL AND e.UKPRN IS NULL
 AND e.EstablishmentNumber IS NULL AND e.educationPhase_code='0'))
 THROW 50001, 'T19R member or relationship assertions changed; review before import.', 1;
SELECT urn FROM @expected ORDER BY urn;
