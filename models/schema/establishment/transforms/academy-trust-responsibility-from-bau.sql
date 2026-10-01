/*
    Project one establishment-party role and establishment responsibility
    from the local BAU copy. This is a source projection;
    it neither creates migration lineage nor loads PostgreSQL.

    Supply URN and GROUP_ID with the local migration runner.

    T1 review evidence resolves local sponsor group 4949 ("The Co-operative
    Group", without a company number) to MAT group 2777 for the same trust.
*/
DECLARE @URN numeric(19, 0) = $(URN);
DECLARE @GROUP_ID numeric(19, 0) = $(GROUP_ID);
DECLARE @INCLUDE_ARCHIVED bit = $(INCLUDE_ARCHIVED);

SELECT
    COALESCE(NULLIF(LTRIM(RTRIM(resolved_mat.name)), ''), NULLIF(LTRIM(RTRIM(eg.name)), '')) AS legal_entity_name,
    COALESCE(NULLIF(LTRIM(RTRIM(resolved_mat.companiesHouseNumber)), ''), NULLIF(LTRIM(RTRIM(eg.companiesHouseNumber)), '')) AS companies_house_number,
    COALESCE(CONVERT(varchar(20), resolved_mat.UKPRN), CONVERT(varchar(20), eg.UKPRN)) AS ukprn,
    CASE
        WHEN COALESCE(resolved_mat.type_code, eg.type_code) IN ('06', '10') THEN CONVERT(varchar(10), COALESCE(resolved_mat.openDate, eg.openDate), 23)
    END AS legal_entity_incorporation_date,
    CONVERT(varchar(20), eg.id) AS group_uid,
    NULLIF(LTRIM(RTRIM(eg.groupId)), '') AS group_id,
    CASE eg.type_code
        WHEN '02' THEN 'Foundation trust'
        WHEN '06' THEN 'Academy trust'
        WHEN '10' THEN 'Academy trust'
        WHEN '11' THEN 'Academy trust'
        WHEN '05' THEN 'School sponsor'
    END AS establishment_party_role_type,
    CASE eg.type_code
        WHEN '06' THEN 'Multi-academy trust'
        WHEN '10' THEN 'Single-academy trust'
        WHEN '11' THEN 'Secure single-academy trust'
    END AS academy_trust_type,
    CASE eg.type_code
        WHEN '02' THEN 'Supported by foundation trust'
        WHEN '05' THEN 'Sponsored by'
        ELSE 'Run by academy trust'
    END AS responsibility_type,
    NULL AS role_start_date,
    NULL AS role_end_date,
    NULL AS role_end_date_basis,
    NULL AS classification_start_date,
    NULL AS classification_end_date,
    CONVERT(bit, CASE WHEN gl.archived = 1 THEN 0 ELSE 1 END) AS is_current,
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
OUTER APPLY (
    SELECT TOP (1) candidate.*
    FROM dbo.EstablishmentGroup AS candidate
    JOIN dbo.GroupLink AS candidate_link
      ON candidate_link.group_id = candidate.id
     AND candidate_link.urn = gl.urn
     AND (candidate_link.archived = 0 OR candidate_link.archived IS NULL)
    WHERE (eg.type_code = '05' OR (eg.id = 2779 AND candidate.id = 2777))
      AND candidate.type_code IN ('06', '10', '11')
      AND (
          UPPER(LTRIM(RTRIM(candidate.name))) = UPPER(LTRIM(RTRIM(eg.name)))
          OR (eg.id IN (4949, 2779) AND candidate.id = 2777)
      )
      AND NULLIF(LTRIM(RTRIM(candidate.companiesHouseNumber)), '') IS NOT NULL
    ORDER BY CASE WHEN candidate_link.effectiveDate = gl.effectiveDate THEN 0 ELSE 1 END, candidate.id
) AS resolved_mat
WHERE eg.id = @GROUP_ID
  AND gl.urn = @URN
  AND eg.type_code IN ('02', '05', '06', '10', '11')
  AND (@INCLUDE_ARCHIVED = 1 OR gl.archived = 0 OR gl.archived IS NULL)
  AND gl.effectiveDate IS NOT NULL
  AND gl.effectiveDate NOT IN ('1900-01-01', '1902-01-01');
