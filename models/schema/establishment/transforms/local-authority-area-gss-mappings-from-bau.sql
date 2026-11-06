-- Map the legacy DfE local-authority code to the GSS local-authority code.
SELECT
    NULLIF(LTRIM(RTRIM(localAuthority_code)), '') AS local_authority_code,
    NULLIF(LTRIM(RTRIM(gssLaCode_code)), '') AS gss_code
FROM dbo.LaGssMapping
WHERE NULLIF(LTRIM(RTRIM(localAuthority_code)), '') IS NOT NULL
ORDER BY localAuthority_code;
