-- Current federations and children's-centre groups; no responsibility projection.
DECLARE @GROUP_ID numeric(19, 0) = $(GROUP_ID);
IF NOT EXISTS (SELECT 1 FROM dbo.EstablishmentGroup WHERE id = @GROUP_ID AND type_code IN ('01','08') AND closedDate IS NULL)
    THROW 50001, 'Selected group must be an open federation or childrens-centre group.', 1;
IF EXISTS (
    SELECT 1 FROM dbo.GroupLink gl
    JOIN dbo.EstablishmentGroup eg ON eg.id=gl.group_id
    LEFT JOIN dbo.Establishment e ON e.URN = gl.urn
    WHERE gl.group_id = @GROUP_ID AND (gl.archived = 0 OR gl.archived IS NULL)
      AND (e.URN IS NULL OR e.status_code IS NULL OR e.status_code <> '1'
        OR (eg.type_code='08' AND (e.type_code IS NULL OR e.type_code<>'47'))
        OR (eg.type_code='01' AND e.type_code NOT IN (
          SELECT code FROM dbo.EstablishmentType WHERE name IN (
              'Community school', 'Voluntary aided school', 'Voluntary controlled school',
              'Foundation school', 'Community special school', 'Foundation special school', 'Maintained nursery school'
          ))))
)
    THROW 50001, 'Group contains a missing, non-open or unsupported member.', 1;

IF EXISTS (SELECT 1 FROM dbo.EstablishmentGroup WHERE id=@GROUP_ID AND type_code='08'
           AND (localAuthority_code IS NULL OR localAuthority_code='999'))
    THROW 50001, 'Childrens-centre group requires a recorded local authority.', 1;
IF EXISTS (SELECT 1 FROM dbo.GroupLink gl JOIN dbo.EstablishmentGroup eg ON eg.id=gl.group_id
           WHERE eg.id=@GROUP_ID AND eg.type_code='08' AND (gl.archived=0 OR gl.archived IS NULL)
             AND (gl.ccLinkType IS NULL OR gl.ccLinkType NOT IN ('LEAD','STANDARD')))
    THROW 50001, 'Missing or unrecognised childrens-centre lead code requires review.', 1;
IF (SELECT count(*) FROM dbo.GroupLink WHERE group_id=@GROUP_ID AND ccLinkType='LEAD'
    AND (archived=0 OR archived IS NULL)) > 1
    THROW 50001, 'Childrens-centre group has multiple lead members.', 1;

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
       CASE WHEN eg.type_code='08' THEN gl.ccLinkType ELSE gl.linkType END AS source_link_type,
       CASE WHEN eg.type_code='08' THEN CONVERT(bit, CASE gl.ccLinkType WHEN 'LEAD' THEN 1 WHEN 'STANDARD' THEN 0 END) END AS is_lead_member
FROM dbo.EstablishmentGroup eg
JOIN dbo.GroupLink gl ON gl.group_id = eg.id
WHERE eg.id = @GROUP_ID AND (gl.archived = 0 OR gl.archived IS NULL)
ORDER BY gl.urn;
