-- Fail closed on the reviewed complete federation slice.
IF NOT EXISTS (SELECT 1 FROM dbo.EstablishmentGroup WHERE id=1761
 AND name='The Federation of St Elphege''s RC School' AND type_code='01'
 AND CONVERT(date,openDate)='2006-01-01' AND closedDate IS NULL
 AND localAuthority_code='999' AND groupId IS NULL AND companiesHouseNumber IS NULL AND UKPRN IS NULL)
 THROW 50001, 'T18 federation source assertions changed.', 1;
DECLARE @expected table(urn int,link_id int,joined date,la varchar(3),name varchar(100),ukprn bigint,number int);
INSERT INTO @expected VALUES
 (101800,2517,'2014-09-15','306','Regina Coeli Catholic Primary School',10071655,3408),
 (102996,1811,'2006-01-01','319','St Elphege''s RC Junior School',10079489,3503),
 (102997,1812,'2006-01-01','319','St Elphege''s RC Infants'' School',10078365,3504);
IF (SELECT count(*) FROM dbo.GroupLink WHERE group_id=1761)<>3
 OR (SELECT count(*) FROM dbo.GroupLink WHERE urn IN(101800,102996,102997))<>3
 OR EXISTS (SELECT 1 FROM dbo.GroupRelationsLink WHERE linked_group=1761 OR linking_group=1761)
 OR EXISTS (SELECT 1 FROM @expected x WHERE NOT EXISTS (
 SELECT 1 FROM dbo.GroupLink gl JOIN dbo.Establishment e ON e.URN=gl.urn
 WHERE gl.group_id=1761 AND gl.id=x.link_id AND gl.urn=x.urn AND gl.archived=0
 AND gl.linkType='HARD' AND CONVERT(date,gl.effectiveDate)=x.joined
 AND e.EstablishmentName=x.name AND e.LA_code=x.la AND e.type_code='02' AND e.status_code='1'
 AND e.OpenDate IS NULL AND e.CloseDate IS NULL AND e.UKPRN=x.ukprn
 AND e.EstablishmentNumber=x.number AND e.educationPhase_code='2'))
 THROW 50001, 'T18 member or relationship source assertions changed; review before import.', 1;
SELECT urn FROM @expected ORDER BY urn;
