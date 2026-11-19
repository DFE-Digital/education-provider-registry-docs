/*
    Transform current, establishment-scoped BAU governance records into the
    first target GovernanceAppointment projection.

    Target engine: SQL Server

    This is intentionally the smallest Governance transform. It reads only
    dbo.StaffRecord and dbo.StaffRole and returns no person, contact, address,
    appointing body or encrypted data. It projects appointment and step-down
    dates as the current source term boundary. The mapping below translates
    the BAU StaffRole IDs defined by eLookupGovernorRole into target-owned
    Governance role types. StaffRole.id and StaffRole.code are distinct fields;
    IDs must not be inferred from the numeric-looking codes. NA (ID 14) has no
    appointment-role mapping and is rejected by the loader if encountered.
    Chair source rows produce an appointment role plus a Chair role
    assignment; BAU source codes are not retained in the target schema.

    Supply URN with sqlcmd-style substitution, for example: -v URN=136102
*/

DECLARE @URN numeric(19, 0) = $(URN);

IF @URN NOT BETWEEN 1 AND 999999
    THROW 51000, 'URN must be between 1 and 999999.', 1;

WITH role_mapping AS (
    SELECT *
    FROM (VALUES
        (1, 1, 8),
        (2, 1, NULL),
        (3, 2, 8),
        (4, 2, NULL),
        (5, 3, NULL),
        (6, 5, NULL),
        (7, 6, NULL),
        (8, 4, 8),
        (9, 4, NULL),
        (10, 4, 8),
        (11, 4, 8),
        (12, 4, NULL),
        (13, 4, NULL),
        (15, 7, NULL),
        (16, 7, NULL),
        (17, 7, NULL),
        (18, 7, NULL),
        (19, 7, NULL),
        (20, 7, NULL),
        (21, 3, NULL),
        (22, 3, NULL),
        (23, 7, NULL),
        (24, 7, NULL)
    ) AS mapping(source_staff_role_id, governance_role_type_id, office_holder_role_type_id)
)
SELECT
    sr.uid AS source_governance_appointment_id,
    CONVERT(integer, sr.establishment_URN) AS establishment_urn,
    mapping.governance_role_type_id,
    mapping.office_holder_role_type_id,
    CAST(sr.appointmentDate AS date) AS term_start_date,
    CAST(sr.stepdownDate AS date) AS term_end_date
FROM dbo.StaffRecord AS sr
INNER JOIN dbo.StaffRole AS source_role
    ON source_role.code = sr.staffRole_code
LEFT JOIN role_mapping AS mapping
    ON mapping.source_staff_role_id = source_role.id
WHERE (@URN IS NULL OR sr.establishment_URN = @URN)
  AND EXISTS (SELECT 1 FROM dbo.Establishment e WHERE e.URN=sr.establishment_URN AND e.status_code IN ('1','2','3'))
  AND sr.status = 1
  AND ISNULL(sr.deleted, 0) = 0
  AND ISNULL(sr.forcedArchived, 0) = 0
  AND (sr.stepdownDate IS NULL OR CAST(sr.stepdownDate AS date) >= CAST(GETDATE() AS date))
ORDER BY sr.uid;
