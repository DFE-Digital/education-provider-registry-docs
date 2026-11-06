-- SQL Server: capture actual source observations, not a PostgreSQL load date.
-- This local read does not establish the publication date of the restored BAU data.
SELECT CAST(e.URN AS integer) AS urn,CAST(e.LA_code AS integer) AS area_code,
       t.name AS source_type_name,CAST(e.status_code AS integer) AS source_status_code,
       e.OpenDate AS open_date,e.CloseDate AS close_date,
       CAST(SYSUTCDATETIME() AS date) AS observed_date
FROM dbo.Establishment e
LEFT JOIN dbo.EstablishmentType t ON t.code=e.type_code
WHERE e.URN IN ($(URNS))
ORDER BY e.URN;
