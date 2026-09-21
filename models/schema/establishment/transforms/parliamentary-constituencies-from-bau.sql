IF OBJECT_ID(N'dbo.ParliamentaryConstituency', N'U') IS NULL
    THROW 51000, 'Required local source table dbo.ParliamentaryConstituency is missing. Copy it into the configured local BAU database before running the geographic reference-data migration.', 1;

SELECT
    code,
    name
FROM dbo.ParliamentaryConstituency
ORDER BY code;
