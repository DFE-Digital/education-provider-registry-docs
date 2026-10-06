/*
    Project one establishment-party role and establishment responsibility
    from the local BAU copy. This is a source projection;
    it neither creates migration lineage nor loads PostgreSQL.

    Supply URN and GROUP_ID with the local migration runner.

    T1 sponsor group 4949 ("The Co-operative Group") is a separate party
    from MAT group 2777. Preserve its source name without inventing company
    or UKPRN identifiers.
*/
DECLARE @URN numeric(19, 0) = $(URN);
DECLARE @GROUP_ID numeric(19, 0) = $(GROUP_ID);
DECLARE @INCLUDE_ARCHIVED bit = $(INCLUDE_ARCHIVED);

-- T3 is a reviewed identity consolidation, not a change of operator. Require
-- both identity and explicit transition evidence before projecting either row.
DECLARE @T3_TRANSITION date;
IF @URN = 137603 AND @GROUP_ID IN (2055, 20364)
BEGIN
    SELECT @T3_TRANSITION = CONVERT(date, successor.establishedDate)
    FROM dbo.EstablishmentGroup AS sat
    JOIN dbo.EstablishmentGroup AS mat ON mat.id = 20364
    JOIN dbo.GroupLink AS sat_link ON sat_link.group_id = sat.id AND sat_link.urn = @URN
    JOIN dbo.GroupLink AS mat_link ON mat_link.group_id = mat.id AND mat_link.urn = @URN
    JOIN dbo.GroupRelationsLink AS successor
      ON successor.linking_group = sat.id AND successor.linked_group = mat.id AND successor.type_code = '1M'
    JOIN dbo.GroupRelationsLink AS predecessor
      ON predecessor.linking_group = mat.id AND predecessor.linked_group = sat.id AND predecessor.type_code = '1S'
    WHERE sat.id = 2055 AND sat.type_code = '10' AND mat.type_code = '06'
      AND sat.groupId = 'TR00009' AND mat.groupId = sat.groupId
      AND sat.UKPRN = 10059335 AND mat.UKPRN = sat.UKPRN
      AND sat.openDate = mat.openDate AND mat.companiesHouseNumber = '07795736'
      AND sat.closedDate = successor.establishedDate
      AND predecessor.establishedDate = successor.establishedDate
      AND mat_link.effectiveDate = successor.establishedDate
      AND sat_link.archived = 1 AND mat_link.archived = 0
      AND sat_link.effectiveDate = '2011-11-01'
      AND successor.establishedDate = '2021-03-30' AND mat.closedDate IS NULL;
    IF @T3_TRANSITION IS NULL
        THROW 50001, 'T3 Ridgewood identity or SAT-to-MAT transition evidence is missing or changed.', 1;
END;

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
    CASE
        WHEN eg.type_code = '06'
         AND eg.closedDate IS NOT NULL
         AND eg.closedDate = e.CloseDate
        THEN CONVERT(varchar(10), eg.closedDate, 23)
    END AS role_end_date,
    CASE
        WHEN eg.type_code = '06'
         AND eg.closedDate IS NOT NULL
         AND eg.closedDate = e.CloseDate
        THEN 'evidenced'
    END AS role_end_date_basis,
    CASE WHEN @T3_TRANSITION IS NOT NULL AND eg.type_code = '06'
         THEN CONVERT(varchar(10), @T3_TRANSITION, 23)
    END AS classification_start_date,
    CASE
        WHEN @T3_TRANSITION IS NOT NULL AND eg.type_code = '10'
        THEN CONVERT(varchar(10), @T3_TRANSITION, 23)
        WHEN eg.type_code = '06'
         AND eg.closedDate IS NOT NULL
         AND eg.closedDate = e.CloseDate
        THEN CONVERT(varchar(10), eg.closedDate, 23)
    END AS classification_end_date,
    CONVERT(bit, CASE WHEN gl.archived = 1 OR eg.closedDate IS NOT NULL THEN 0 ELSE 1 END) AS is_current,
    CONVERT(integer, gl.urn) AS establishment_urn,
    CONVERT(varchar(10), gl.effectiveDate, 23) AS responsibility_start_date,
    CASE
        WHEN e.CloseDate IS NOT NULL THEN CONVERT(varchar(10), e.CloseDate, 23)
    END AS responsibility_end_date,
    CASE
        WHEN e.CloseDate IS NOT NULL THEN 'inferred'
    END AS end_date_basis,
    CASE WHEN @T3_TRANSITION IS NOT NULL THEN
        'T3: shared Group ID TR00009, UKPRN 10059335 and incorporation date; Companies House 07795736 supplied by MAT 20364. GroupRelationsLink 547 (2055 -> 20364, 1M) and 548 (20364 -> 2055, 1S) evidence classification transition 2021-03-30. Source GroupLink 4778 supplies the historical SAT responsibility start 2011-11-01; GroupLink 34277 supplies the current MAT responsibility start 2021-03-30. One continuing legal entity and role; separate SAT and MAT responsibilities. SAT responsibility end and initial SAT classification start unknown; classification dates are not copied into responsibility boundaries.'
    END AS consolidation_evidence,
    CONVERT(bit, CASE WHEN gl.archived = 1 OR eg.closedDate IS NOT NULL THEN 0 ELSE 1 END) AS responsibility_is_current
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
    WHERE ((eg.type_code = '05'
            AND NULLIF(LTRIM(RTRIM(eg.companiesHouseNumber)), '') IS NOT NULL
            AND LTRIM(RTRIM(eg.companiesHouseNumber)) = LTRIM(RTRIM(candidate.companiesHouseNumber)))
           OR (@T3_TRANSITION IS NOT NULL AND eg.id = 2055 AND candidate.id = 20364))
      AND candidate.type_code IN ('06', '10', '11')
      AND NULLIF(LTRIM(RTRIM(candidate.companiesHouseNumber)), '') IS NOT NULL
      -- A supplied company number must never be replaced by a different
      -- company's number during identity resolution.
      AND (NULLIF(LTRIM(RTRIM(eg.companiesHouseNumber)), '') IS NULL
           OR LTRIM(RTRIM(eg.companiesHouseNumber)) = LTRIM(RTRIM(candidate.companiesHouseNumber)))
    ORDER BY CASE WHEN candidate_link.effectiveDate = gl.effectiveDate THEN 0 ELSE 1 END, candidate.id
) AS resolved_mat
WHERE eg.id = @GROUP_ID
  AND gl.urn = @URN
  AND eg.type_code IN ('02', '05', '06', '10', '11')
  AND (@INCLUDE_ARCHIVED = 1 OR gl.archived = 0 OR gl.archived IS NULL)
  AND gl.effectiveDate IS NOT NULL
  AND gl.effectiveDate NOT IN ('1900-01-01', '1902-01-01');
