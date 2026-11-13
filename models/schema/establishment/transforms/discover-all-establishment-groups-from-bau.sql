-- Bulk discovery streams eligible links directly, without fixture preflight
-- queries, a separate URN staging table, or an unnecessary result sort.
SELECT CONVERT(integer, gl.urn) AS establishment_urn,
       CONVERT(integer, gl.group_id) AS source_group_id,
       eg.type_code AS group_type_code,
       CONVERT(integer, COALESCE(gl.archived, 0)) AS source_archived,
       CONVERT(varchar(10), eg.closedDate, 23) AS source_group_closed_date
FROM dbo.GroupLink gl
JOIN dbo.Establishment e ON e.URN=gl.urn
JOIN dbo.EstablishmentGroup eg ON eg.id=gl.group_id
WHERE e.status_code IN ('1','2','3')
  AND (gl.archived=0 OR gl.archived IS NULL
       OR ($(INCLUDE_ARCHIVED)=1 AND eg.type_code NOT IN ('01','08')))
OPTION (RECOMPILE);
