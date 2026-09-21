IF OBJECT_ID(N'dbo.MSOA', N'U') IS NULL
    THROW 51000, 'Required local source table dbo.MSOA is missing. Copy it into the configured local BAU database before running the geographic reference-data migration.', 1;

SELECT code, name
FROM dbo.MSOA
ORDER BY code;
