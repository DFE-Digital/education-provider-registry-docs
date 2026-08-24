/*
    Transform current, establishment-scoped BAU governance records into the
    first target GovernanceAppointment projection.

    Target engine: SQL Server

    This is intentionally the smallest Governance transform. It reads only
    dbo.StaffRecord and dbo.StaffRole and returns no person, contact, address,
    appointing body or encrypted data. It projects appointment and step-down
    dates as the current source term boundary. The mapping below translates
    the reviewed BAU StaffRole code set into target-owned Governance role types.
    Chair source rows produce an appointment role plus a Chair role
    assignment; BAU source codes are not retained in the target schema.

    Supply URN with sqlcmd-style substitution, for example: -v URN=106431
*/

DECLARE @URN numeric(19, 0) = $(URN);

IF @URN NOT BETWEEN 100000 AND 999999
    THROW 51000, 'URN must be a six-digit establishment identifier.', 1;

WITH role_mapping AS (
    SELECT *
    FROM (VALUES
        (N'01', 1, 8),
        (N'02', 1, NULL),
        (N'03', 2, 8),
        (N'04', 2, NULL),
        (N'05', 3, NULL),
        (N'06', 5, NULL),
        (N'07', 6, NULL),
        (N'08', 4, 8),
        (N'09', 4, NULL),
        (N'11', 4, 8),
        (N'12', 4, 8),
        (N'13', 4, NULL),
        (N'14', 4, NULL),
        (N'15', 7, NULL),
        (N'16', 7, NULL),
        (N'17', 7, NULL),
        (N'18', 7, NULL),
        (N'19', 7, NULL),
        (N'20', 7, NULL)
    ) AS mapping(source_staff_role_code, governance_role_type_id, office_holder_role_type_id)
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
    ON mapping.source_staff_role_code = sr.staffRole_code
WHERE sr.establishment_URN = @URN
  AND sr.status = 1
  AND ISNULL(sr.deleted, 0) = 0
  AND ISNULL(sr.forcedArchived, 0) = 0
  AND (sr.stepdownDate IS NULL OR CAST(sr.stepdownDate AS date) >= CAST(GETDATE() AS date))
ORDER BY sr.uid;
