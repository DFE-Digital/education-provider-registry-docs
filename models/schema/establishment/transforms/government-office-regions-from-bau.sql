-- Extract the complete Government Office Region reference set from local BAU.

SELECT NULLIF(LTRIM(RTRIM(gor.code)), '') AS code,
       gor.name
FROM dbo.GovernmentOfficeRegion AS gor
WHERE NULLIF(LTRIM(RTRIM(gor.code)), '') IS NOT NULL
  AND LTRIM(RTRIM(gor.code)) <> '0'
ORDER BY LTRIM(RTRIM(gor.code));
