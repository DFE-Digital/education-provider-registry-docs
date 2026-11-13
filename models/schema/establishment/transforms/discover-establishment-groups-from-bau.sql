-- Read-only discovery for supplied URNs. Group type determines which loader
-- handles a link; identity resolution remains the responsibility of that loader.
CREATE TABLE #URN_SCOPE (urn numeric(19, 0) PRIMARY KEY);
IF $(ALL_SOURCE) = 1
    INSERT INTO #URN_SCOPE (urn) SELECT URN FROM dbo.Establishment WHERE status_code IN ('1','2','3');
ELSE
    INSERT INTO #URN_SCOPE (urn) SELECT urn FROM (VALUES $(URN_VALUES)) AS source_urns(urn);
DECLARE @INCLUDE_ARCHIVED bit = $(INCLUDE_ARCHIVED);

IF EXISTS (
    SELECT 1 FROM #URN_SCOPE s LEFT JOIN dbo.Establishment e ON e.URN=s.urn AND e.status_code IN ('1','2','3')
    WHERE e.URN IS NULL
)
    THROW 50001, 'A supplied URN is absent or outside the imported status selection (1,2,3).', 1;

IF EXISTS (
    SELECT 1 FROM dbo.GroupLink gl JOIN #URN_SCOPE s ON s.urn=gl.urn
    LEFT JOIN dbo.EstablishmentGroup eg ON eg.id=gl.group_id
    WHERE (gl.archived=0 OR gl.archived IS NULL OR @INCLUDE_ARCHIVED=1) AND eg.id IS NULL
)
    THROW 50001, 'A supplied URN has a link to a missing source group; review required.', 1;

-- A partial local federation fixture may have one selected member, but the
-- curated source fixture must still have at least two current distinct members.
-- A full-source bulk load retains the source's actual membership, including one.
IF $(ALL_SOURCE) = 0 AND EXISTS (
    SELECT 1 FROM dbo.GroupLink gl JOIN #URN_SCOPE s ON s.urn=gl.urn
    JOIN dbo.EstablishmentGroup eg ON eg.id=gl.group_id
    WHERE eg.type_code='01' AND (gl.archived=0 OR gl.archived IS NULL)
      AND (SELECT count(DISTINCT member.urn) FROM dbo.GroupLink member
           WHERE member.group_id=eg.id AND (member.archived=0 OR member.archived IS NULL)) < 2
)
    THROW 50001, 'Source federation has fewer than two current members; review required.', 1;

SELECT CONVERT(integer, gl.urn) AS establishment_urn,
       CONVERT(integer, gl.group_id) AS source_group_id,
       eg.type_code AS group_type_code,
       CONVERT(integer, COALESCE(gl.archived, 0)) AS source_archived,
       CONVERT(varchar(10), eg.closedDate, 23) AS source_group_closed_date
FROM dbo.GroupLink gl
JOIN #URN_SCOPE s ON s.urn=gl.urn
JOIN dbo.EstablishmentGroup eg ON eg.id=gl.group_id
WHERE gl.archived=0 OR gl.archived IS NULL
   OR (@INCLUDE_ARCHIVED=1 AND eg.type_code NOT IN ('01','08'))
ORDER BY gl.urn, gl.group_id, gl.id;
