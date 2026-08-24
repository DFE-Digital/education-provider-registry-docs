/*
    Transform current, establishment-scoped BAU governance records into the
    first target GovernanceAppointment projection.

    Target engine: SQL Server

    This is intentionally the smallest Governance transform. It reads only
    dbo.StaffRecord and returns no person, contact, address, term, appointing
    body or encrypted data. Role mapping is deferred until source role codes
    have been reviewed against the Governance taxonomy.

    Supply URN with sqlcmd-style substitution, for example: -v URN=106431
*/

DECLARE @URN numeric(19, 0) = $(URN);

IF @URN NOT BETWEEN 100000 AND 999999
    THROW 51000, 'URN must be a six-digit establishment identifier.', 1;

SELECT
    sr.uid AS source_governance_appointment_id,
    CONVERT(integer, sr.establishment_URN) AS establishment_urn,
    CAST(NULL AS nvarchar(32)) AS role_type_code
FROM dbo.StaffRecord AS sr
WHERE sr.establishment_URN = @URN
  AND sr.status = 1
  AND ISNULL(sr.deleted, 0) = 0
  AND ISNULL(sr.forcedArchived, 0) = 0
  AND (sr.stepdownDate IS NULL OR CAST(sr.stepdownDate AS date) >= CAST(GETDATE() AS date))
ORDER BY sr.uid;
