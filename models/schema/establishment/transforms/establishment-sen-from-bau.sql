-- SQL Server. Preserve every source bucket for validation and exclusions.
-- A real establishment with no links returns one null-link row; a missing
-- establishment returns no rows and must not clear a target association set.
DECLARE @URN numeric(19, 0) = $(URN);

WITH links AS (
    SELECT 1 AS source_bucket, URN, senCode FROM dbo.EstablishmentToSen1 WHERE URN = @URN
    UNION ALL
    SELECT 2, URN, senCode FROM dbo.EstablishmentToSen2 WHERE URN = @URN
    UNION ALL
    SELECT 3, URN, senCode FROM dbo.EstablishmentToSen3 WHERE URN = @URN
    UNION ALL
    SELECT 4, URN, senCode FROM dbo.EstablishmentToSen4 WHERE URN = @URN
)
SELECT e.URN AS urn, l.source_bucket, l.senCode AS sen_code,
       s.name AS source_sen_name, CAST(s.archived AS integer) AS source_archived
FROM dbo.Establishment AS e
LEFT JOIN links AS l ON l.URN = e.URN
LEFT JOIN dbo.Sen AS s ON s.code = l.senCode
WHERE e.URN = @URN
ORDER BY l.source_bucket, l.senCode;
