-- Extract the complete local-authority reference set from the local BAU copy.
-- This requires dbo.LocalAuthority and dbo.LocalAuthorityGroup to be present.

SELECT
    la.code,
    la.name,
    CASE
        WHEN LOWER(LTRIM(RTRIM(lag.name))) = 'english' THEN 'English'
        WHEN LOWER(LTRIM(RTRIM(lag.name))) = 'welsh' THEN 'Welsh'
        ELSE NULL
    END AS jurisdiction_name,
    NULLIF(LTRIM(RTRIM(la.contactEmail)),'') AS contact_email,
    NULLIF(LTRIM(RTRIM(la.contactFirstName)),'') AS contact_first_name,
    NULLIF(LTRIM(RTRIM(la.contactLastName)),'') AS contact_last_name,
    NULLIF(LTRIM(RTRIM(la.contactPhone)),'') AS contact_phone,
    NULLIF(LTRIM(RTRIM(la.contactTitle)),'') AS contact_title
FROM dbo.LocalAuthority AS la
LEFT JOIN dbo.LocalAuthorityGroup AS lag
  ON lag.code = la.group_code
WHERE la.code <> 0
ORDER BY la.code;
