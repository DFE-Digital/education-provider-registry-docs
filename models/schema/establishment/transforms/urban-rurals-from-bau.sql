IF OBJECT_ID(N'dbo.UrbanRural', N'U') IS NULL
    THROW 51000, 'Required local source table dbo.UrbanRural is missing. Copy it into the configured local BAU database before running the geographic reference-data migration.', 1;

SELECT code, name
FROM dbo.UrbanRural
WHERE LOWER(LTRIM(RTRIM(name))) NOT IN ('unknown','does not apply','not known') AND LOWER(LTRIM(RTRIM(name))) NOT LIKE 'not applicable%'
ORDER BY code;
