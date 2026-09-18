-- Map the legacy DfE local-authority code to its Government Office Region.
SELECT
    NULLIF(LTRIM(RTRIM(localAuthority_code)), '') AS local_authority_code,
    NULLIF(LTRIM(RTRIM(region_code)), '') AS region_code
FROM dbo.LaGorMapping
WHERE NULLIF(LTRIM(RTRIM(localAuthority_code)), '') IS NOT NULL
ORDER BY localAuthority_code;
