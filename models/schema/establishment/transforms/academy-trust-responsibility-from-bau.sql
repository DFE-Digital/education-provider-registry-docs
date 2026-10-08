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

-- T11R is an accepted test-case assumption, not automatic name matching.
-- Fail closed if the inspected source assertions change.
IF @URN=134311 AND @GROUP_ID IN (4075,4076)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM dbo.EstablishmentGroup s
        JOIN dbo.EstablishmentGroup t ON t.id=4076
        JOIN dbo.GroupLink sl ON sl.group_id=s.id AND sl.urn=@URN
        JOIN dbo.GroupLink tl ON tl.group_id=t.id AND tl.urn=@URN
        JOIN dbo.Establishment e ON e.URN=@URN
        WHERE s.id=4075 AND s.name='Oasis Community Learning' AND s.type_code='05'
          AND s.groupId='SP00392' AND s.companiesHouseNumber IS NULL AND s.UKPRN IS NULL
          AND CONVERT(date,s.openDate)='1900-01-01' AND s.closedDate IS NULL
          AND t.name='OASIS COMMUNITY LEARNING' AND t.type_code='06'
          AND t.groupId='TR01553' AND t.companiesHouseNumber='05398529' AND t.UKPRN=10058190
          AND t.openDate='2005-03-18' AND t.closedDate IS NULL
          AND sl.id=4024 AND tl.id=8088 AND sl.archived=0 AND tl.archived=0
          AND sl.effectiveDate='2007-09-01' AND tl.effectiveDate=sl.effectiveDate
          AND e.EstablishmentName='Oasis Academy Enfield' AND e.type_code='28'
          AND e.status_code='1' AND e.OpenDate='2007-09-01' AND e.CloseDate IS NULL
          AND e.UKPRN=10021087 AND (SELECT count(*) FROM dbo.GroupLink WHERE urn=@URN)=2
    ) OR EXISTS (
        SELECT urn FROM dbo.GroupLink WHERE group_id=4075 AND (archived=0 OR archived IS NULL)
        EXCEPT SELECT urn FROM dbo.GroupLink WHERE group_id=4076 AND (archived=0 OR archived IS NULL)
    ) OR EXISTS (
        SELECT urn FROM dbo.GroupLink WHERE group_id=4076 AND (archived=0 OR archived IS NULL)
        EXCEPT SELECT urn FROM dbo.GroupLink WHERE group_id=4075 AND (archived=0 OR archived IS NULL)
    ) OR (SELECT count(DISTINCT urn) FROM dbo.GroupLink WHERE group_id=4075 AND (archived=0 OR archived IS NULL))<>47
        THROW 50001, 'T11R Oasis source evidence changed; review the accepted identity assumption before loading.', 1;
END;

-- Reviewed person mapping for T7; missing company identifiers alone are not
-- a rule for treating a sponsor as a person.
IF @URN=135936 AND @GROUP_ID IN (2613,3147) AND NOT EXISTS (
    SELECT 1 FROM dbo.EstablishmentGroup sponsor
    JOIN dbo.EstablishmentGroup trust ON trust.id=3147
    JOIN dbo.GroupLink sl ON sl.group_id=sponsor.id AND sl.urn=@URN
    JOIN dbo.GroupLink tl ON tl.group_id=trust.id AND tl.urn=@URN
    JOIN dbo.Establishment e ON e.URN=@URN
    WHERE sponsor.id=2613 AND sponsor.name='Charles Dunstone' AND sponsor.type_code='05'
      AND sponsor.groupId='SP00099' AND sponsor.companiesHouseNumber IS NULL AND sponsor.UKPRN IS NULL
      AND sponsor.closedDate IS NULL AND CONVERT(date,sponsor.openDate)='1900-01-01'
      AND trust.type_code='06' AND trust.groupId='TR00830' AND trust.companiesHouseNumber='06960253'
      AND trust.UKPRN=10058269 AND trust.closedDate IS NULL AND trust.openDate='2009-07-13'
      AND sl.id=3648 AND tl.id=5539 AND sl.archived=0 AND tl.archived=0
      AND sl.effectiveDate='2009-09-01' AND tl.effectiveDate=sl.effectiveDate
      AND e.status_code='1' AND e.CloseDate IS NULL
      AND (SELECT count(*) FROM dbo.GroupLink WHERE urn=@URN)=2
)
    THROW 50001, 'T7 person-sponsor or operator evidence is missing or changed; review before loading.', 1;

-- T6 is a bounded current foundation-support link, not a whole-trust import.
IF @URN = 132141 AND @GROUP_ID = 1337 AND NOT EXISTS (
    SELECT 1 FROM dbo.EstablishmentGroup eg
    JOIN dbo.GroupLink gl ON gl.group_id=eg.id
    JOIN dbo.Establishment e ON e.URN=gl.urn
    WHERE eg.id=1337 AND eg.type_code='02' AND eg.closedDate IS NULL
      AND eg.name='The North Tyneside Learning Trust' AND eg.openDate='2010-09-03'
      AND eg.companiesHouseNumber IS NULL AND eg.UKPRN IS NULL AND eg.groupId IS NULL
      AND gl.id=1029 AND gl.urn=132141 AND gl.archived=0 AND gl.effectiveDate='2011-09-01'
      AND e.status_code='1' AND e.type_code='05' AND e.CloseDate IS NULL
      AND (SELECT count(*) FROM dbo.GroupLink WHERE urn=132141)=1
)
    THROW 50001, 'T6 foundation-support evidence is missing or changed; review before loading.', 1;

-- T12 imports only the selected foundation-support link. Registered identity
-- is provisional; the similar-name comparison records are not merge inputs.
IF @URN=109393 AND @GROUP_ID=1193 AND NOT EXISTS (
    SELECT 1 FROM dbo.EstablishmentGroup eg
    JOIN dbo.GroupLink gl ON gl.group_id=eg.id
    JOIN dbo.Establishment e ON e.URN=gl.urn
    WHERE eg.id=1193 AND eg.name='Trust in Learning' AND eg.type_code='02'
      AND eg.companiesHouseNumber IS NULL AND eg.UKPRN IS NULL AND eg.groupId IS NULL
      AND CONVERT(date,eg.openDate)='2008-09-01' AND eg.closedDate IS NULL
      AND eg.localAuthority_code='999' AND gl.id=595 AND gl.urn=109393
      AND gl.archived=0 AND CONVERT(date,gl.effectiveDate)='2010-09-01'
      AND e.EstablishmentName='New Fosseway School' AND e.type_code='12' AND e.status_code='1'
      AND e.UKPRN=10016445 AND e.OpenDate IS NULL AND e.CloseDate IS NULL
      AND (SELECT count(*) FROM dbo.GroupLink WHERE urn=109393)=1
)
    THROW 50001, 'T12 foundation-trust source assertions changed; identity review required before loading.', 1;

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
    CONVERT(bit, CASE WHEN gl.archived = 1 OR eg.closedDate IS NOT NULL THEN 0 ELSE 1 END) AS responsibility_is_current,
    CONVERT(varchar(20), gl.id) AS source_link_id,
    CONVERT(varchar(10), eg.openDate, 23) AS source_group_open_date,
    CONVERT(integer, gl.archived) AS source_archived,
    CASE WHEN @URN=135936 AND eg.id=2613 THEN 'person' ELSE 'legal_entity' END AS party_kind,
    CASE WHEN @URN=109393 AND eg.id=1193 THEN
        'T12 bounded provisional foundation-trust allocation: Trust in Learning, UID 1193, supports New Fosseway School, URN 109393, through GroupLink 595 from 2010-09-01. BAU supplies no company number, organisation UKPRN or Group ID for UID 1193. Do not merge with similar-name sponsor UID 5121 or MAT UID 5122, AMPLIFY EDUCATION, or copy company 08089704 / UKPRN 10059816. Actual registered identity requires a manual migration decision. Source group openDate 2008-09-01 is not incorporation or role start; school opening date is unknown.'
    WHEN @URN=134311 AND eg.id IN (4075,4076) THEN
        'T11R accepted test-case identity assumption: sponsor UID 4075 / SP00392 and MAT UID 4076 / TR01553 represent one Oasis Community Learning legal entity. Company 05398529 and organisation UKPRN 10058190 are supplied only by MAT 4076; sponsor source company and UKPRN are NULL. Names and the same 47 current academy URNs support the assumption but BAU does not explicitly assert shared identity. Retain two roles and responsibilities. Sponsor source openDate 1900-01-01 is a placeholder, not a business date. Actual migration requires a manual identity decision; this mapping is scoped to URN 134311.'
    WHEN @URN=135936 AND eg.id=2613 THEN
        'T7 reviewed person sponsor: Charles Dunstone. Fulwood Academy identifies Sir Charles as its sponsor and states personal funding: https://www.fulwoodacademy.co.uk/page/?pid=53&title=Welcome+from+the+Sponsor. GroupLink 3648: archived=0; effectiveDate=2009-09-01. Source group openDate=1900-01-01 rejected as placeholder; role start unknown. No Companies House number applies to the person; do not merge with trust UID 3147.'
    END AS party_mapping_evidence
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
           OR (@T3_TRANSITION IS NOT NULL AND eg.id = 2055 AND candidate.id = 20364)
           OR (@URN=134311 AND eg.id=4075 AND candidate.id=4076))
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
