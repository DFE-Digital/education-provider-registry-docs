/*
    Project one establishment-party role and establishment responsibility
    from the local BAU copy. This is a source projection;
    it neither creates migration lineage nor loads PostgreSQL.

    Supply URN and GROUP_ID with the local migration runner.
*/
DECLARE @URN numeric(19, 0) = $(URN);
DECLARE @GROUP_ID numeric(19, 0) = $(GROUP_ID);

SELECT
    NULLIF(LTRIM(RTRIM(eg.name)), '') AS legal_entity_name,
    NULLIF(LTRIM(RTRIM(eg.companiesHouseNumber)), '') AS companies_house_number,
    CONVERT(varchar(20), eg.UKPRN) AS ukprn,
    CASE
        WHEN eg.type_code IN ('06', '10') THEN CONVERT(varchar(10), eg.openDate, 23)
    END AS legal_entity_incorporation_date,
    CONVERT(varchar(20), eg.id) AS group_uid,
    NULLIF(LTRIM(RTRIM(eg.groupId)), '') AS group_id,
    CASE eg.type_code
        WHEN '02' THEN 'Foundation trust'
        WHEN '06' THEN 'Academy trust'
        WHEN '10' THEN 'Academy trust'
        WHEN '11' THEN 'Academy trust'
    END AS establishment_party_role_type,
    CASE eg.type_code
        WHEN '06' THEN 'Multi-academy trust'
        WHEN '10' THEN 'Single-academy trust'
        WHEN '11' THEN 'Secure single-academy trust'
    END AS academy_trust_type,
    CASE eg.type_code
        WHEN '02' THEN 'Supported by foundation trust'
        ELSE 'Run by academy trust'
    END AS responsibility_type,
    CASE
        WHEN eg.type_code IN ('02', '11') THEN CONVERT(varchar(10), eg.openDate, 23)
    END AS role_start_date,
    CONVERT(varchar(10), eg.closedDate, 23) AS role_end_date,
    CASE
        WHEN eg.closedDate IS NOT NULL THEN 'evidenced'
    END AS role_end_date_basis,
    CASE
        WHEN eg.type_code = '11' THEN CONVERT(varchar(10), eg.openDate, 23)
    END AS classification_start_date,
    CONVERT(varchar(10), eg.closedDate, 23) AS classification_end_date,
    CONVERT(integer, gl.urn) AS establishment_urn,
    CONVERT(varchar(10), gl.effectiveDate, 23) AS responsibility_start_date,
    CASE
        WHEN e.CloseDate IS NOT NULL THEN CONVERT(varchar(10), e.CloseDate, 23)
    END AS responsibility_end_date,
    CASE
        WHEN e.CloseDate IS NOT NULL THEN 'inferred'
    END AS end_date_basis
FROM dbo.EstablishmentGroup AS eg
JOIN dbo.GroupLink AS gl
  ON gl.group_id = eg.id
JOIN dbo.Establishment AS e
  ON e.URN = gl.urn
WHERE eg.id = @GROUP_ID
  AND gl.urn = @URN
  AND eg.type_code IN ('02', '06', '10', '11')
  AND gl.archived = 0
  AND gl.effectiveDate IS NOT NULL
  AND gl.effectiveDate NOT IN ('1900-01-01', '1902-01-01');
