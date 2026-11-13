-- SQL Server. Bulk, current-only organisation-group projection for the
-- disposable development seed. Validation is deferred to the PostgreSQL
-- fixture loader so one bad group can be skipped without re-querying BAU.
SELECT CONVERT(varchar(20), eg.id) AS group_uid,
       NULLIF(LTRIM(RTRIM(eg.groupId)), '') AS group_id,
       LTRIM(RTRIM(eg.name)) AS group_name,
       CASE eg.type_code WHEN '01' THEN 'Federation' WHEN '08' THEN 'Children''s-centre group' END AS group_type,
       CASE WHEN eg.type_code='08' THEN CONVERT(integer, eg.localAuthority_code) END AS local_authority_code,
       CONVERT(varchar(10), eg.openDate, 23) AS group_open_date,
       CONVERT(varchar(10), eg.closedDate, 23) AS group_close_date,
       CONVERT(integer, gl.urn) AS establishment_urn,
       CONVERT(varchar(10), gl.effectiveDate, 23) AS joined_date,
       CONVERT(varchar(20), gl.id) AS source_link_id,
       CONVERT(integer, COALESCE(gl.archived, 0)) AS source_archived,
       CASE WHEN eg.type_code='08' THEN gl.ccLinkType ELSE gl.linkType END AS source_link_type
FROM dbo.EstablishmentGroup eg
JOIN dbo.GroupLink gl ON gl.group_id=eg.id
JOIN dbo.Establishment e ON e.URN=gl.urn
WHERE eg.type_code IN ('01','08')
  AND eg.closedDate IS NULL
  AND e.status_code IN ('1','2','3')
  AND (gl.archived=0 OR gl.archived IS NULL)
  AND gl.effectiveDate IS NOT NULL;
