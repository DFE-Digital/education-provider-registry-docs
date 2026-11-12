-- SQL Server: inspect the complete dictionary before applying this cut's filter.
SELECT code, name, CAST(archived AS integer) AS archived
FROM dbo.Sen
ORDER BY code;
