SELECT
    code,
    name,
    ISNULL(archived, 0) AS archived
FROM dbo.DistrictAdministrative
WHERE LOWER(LTRIM(RTRIM(name))) NOT IN ('unknown','does not apply','not known') AND LOWER(LTRIM(RTRIM(name))) NOT LIKE 'not applicable%'
ORDER BY code;
