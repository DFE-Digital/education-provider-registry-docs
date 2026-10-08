-- Case-scoped historical membership. Do not use the current-only group extract.
IF NOT EXISTS (
    SELECT 1 FROM dbo.EstablishmentGroup g
    JOIN dbo.GroupLink gl ON gl.group_id=g.id AND gl.urn=103630
    JOIN dbo.Establishment e ON e.URN=gl.urn
    WHERE g.id=1537 AND g.name='The Federation of Beaufort School and Langley School'
      AND g.type_code='01' AND g.groupId IS NULL AND g.companiesHouseNumber IS NULL AND g.UKPRN IS NULL
      AND CONVERT(date,g.openDate)='2012-04-01' AND CONVERT(date,g.closedDate)='2020-07-01'
      AND gl.id=1245 AND gl.archived=1 AND gl.linkType='HARD' AND CONVERT(date,gl.effectiveDate)='2012-04-01'
      AND e.EstablishmentName='Langley School' AND e.type_code='12' AND e.status_code='2'
      AND e.OpenDate IS NULL AND CONVERT(date,e.CloseDate)='2020-06-16' AND e.UKPRN=10077032
      AND (SELECT count(*) FROM dbo.GroupLink WHERE group_id=1537)=2
      AND EXISTS (SELECT 1 FROM dbo.GroupLink WHERE group_id=1537 AND urn=103627 AND id=1246
                   AND archived=1 AND CONVERT(date,effectiveDate)='2012-04-01')
)
    THROW 50001, 'T17 historical federation assertions changed; review before loading.', 1;
SELECT CONVERT(varchar(20),g.id) AS group_uid,g.name AS group_name,
       CONVERT(varchar(10),g.openDate,23) AS group_open_date,
       CONVERT(varchar(10),g.closedDate,23) AS group_close_date,
       CONVERT(integer,gl.urn) AS establishment_urn,
       CONVERT(varchar(10),gl.effectiveDate,23) AS joined_date,
       CONVERT(varchar(10),e.CloseDate,23) AS left_date,
       CONVERT(varchar(20),gl.id) AS source_link_id,CONVERT(integer,gl.archived) AS source_archived
FROM dbo.EstablishmentGroup g JOIN dbo.GroupLink gl ON gl.group_id=g.id
JOIN dbo.Establishment e ON e.URN=gl.urn
WHERE g.id=1537 AND gl.id=1245 AND gl.urn=103630;
