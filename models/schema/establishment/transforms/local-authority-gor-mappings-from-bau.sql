-- Map the legacy DfE local-authority code to its Government Office Region.
SELECT
    NULLIF(LTRIM(RTRIM(localAuthority_code)), '') AS local_authority_code,
    NULLIF(LTRIM(RTRIM(region_code)), '') AS region_code
FROM dbo.LaGorMapping
WHERE NULLIF(LTRIM(RTRIM(localAuthority_code)), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(region_code)), '') IS NOT NULL
  AND LTRIM(RTRIM(region_code)) NOT IN ('0','N','Z')
ORDER BY localAuthority_code;
