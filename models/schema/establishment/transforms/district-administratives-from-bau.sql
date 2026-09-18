SELECT
    code,
    name,
    ISNULL(archived, 0) AS archived
FROM dbo.DistrictAdministrative
ORDER BY code;
