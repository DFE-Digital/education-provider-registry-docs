-- SQL Server. Development-only, lossy projection of current operating links.
-- This intentionally contains no reviewed identity, name-match or lifecycle rules.
SELECT
    NULLIF(LTRIM(RTRIM(eg.name)), '') AS legal_entity_name,
    NULLIF(LTRIM(RTRIM(eg.companiesHouseNumber)), '') AS companies_house_number,
    CONVERT(varchar(20), eg.UKPRN) AS ukprn,
    CASE WHEN eg.type_code IN ('06','10','11') THEN CONVERT(varchar(10), eg.openDate, 23) END AS legal_entity_incorporation_date,
    CONVERT(varchar(20), eg.id) AS group_uid,
    NULLIF(LTRIM(RTRIM(eg.groupId)), '') AS group_id,
    CASE eg.type_code WHEN '02' THEN 'Foundation trust' WHEN '05' THEN 'School sponsor' ELSE 'Academy trust' END AS establishment_party_role_type,
    CASE eg.type_code WHEN '06' THEN 'Multi-academy trust' WHEN '10' THEN 'Single-academy trust' WHEN '11' THEN 'Secure single-academy trust' END AS academy_trust_type,
    CASE eg.type_code WHEN '02' THEN 'Supported by foundation trust' WHEN '05' THEN 'Sponsored by' ELSE 'Run by academy trust' END AS responsibility_type,
    NULL AS role_start_date,
    NULL AS role_end_date,
    NULL AS role_end_date_basis,
    NULL AS classification_start_date,
    NULL AS classification_end_date,
    CONVERT(bit, CASE WHEN gl.archived=1 OR eg.closedDate IS NOT NULL THEN 0 ELSE 1 END) AS is_current,
    CONVERT(integer, gl.urn) AS establishment_urn,
    CONVERT(varchar(10), gl.effectiveDate, 23) AS responsibility_start_date,
    NULL AS responsibility_end_date,
    NULL AS end_date_basis,
    NULL AS consolidation_evidence,
    CONVERT(bit, CASE WHEN gl.archived=1 OR eg.closedDate IS NOT NULL THEN 0 ELSE 1 END) AS responsibility_is_current,
    CONVERT(varchar(20), gl.id) AS source_link_id,
    CONVERT(varchar(10), eg.openDate, 23) AS source_group_open_date,
    CONVERT(integer, COALESCE(gl.archived,0)) AS source_archived,
    'legal_entity' AS party_kind,
    NULL AS party_mapping_evidence
FROM dbo.GroupLink gl
JOIN dbo.EstablishmentGroup eg ON eg.id=gl.group_id
JOIN dbo.Establishment e ON e.URN=gl.urn
WHERE e.status_code IN ('1','2','3')
  AND eg.type_code IN ('02','05','06','10','11')
  AND (gl.archived=0 OR gl.archived IS NULL)
  AND gl.effectiveDate IS NOT NULL
  AND gl.effectiveDate NOT IN ('1900-01-01','1902-01-01')
  AND NULLIF(LTRIM(RTRIM(eg.name)), '') IS NOT NULL
OPTION (RECOMPILE);
