-- Extract the complete GSS local-authority-code reference set from local BAU.
SELECT
    NULLIF(LTRIM(RTRIM(code)), '') AS code
FROM dbo.GSSLACode
WHERE NULLIF(LTRIM(RTRIM(code)), '') IS NOT NULL
ORDER BY LTRIM(RTRIM(code));
