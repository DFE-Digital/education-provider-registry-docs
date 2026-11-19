# Seed Governance from local BAU

Run from the `education-provider-registry-docs` repository root after creating
`epr_governance` on port 5434:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-governance-from-local-bau.ps1" -SqlServer "localhost" -PostgresHost "127.0.0.1" -PostgresPort 5434 -PostgresDatabase "epr_governance"
```

Add this connection to `%APPDATA%\postgresql\pgpass.conf`, replacing the password
with the one chosen when initialising the Governance instance:

```text
127.0.0.1:5434:epr_governance:postgres:<your-governance-instance-password>
```

SQL Server defaults to `gias_bau_test_local`, login `reader`. The password comes
from `EPR_BAU_SQL_PASSWORD` or a prompt. Use `-UseWindowsAuthentication` for
Windows authentication. PostgreSQL also accepts `PGPASSWORD` or
`-PostgresPassword`. Neither password is stored in the repository.

The command reuses the existing Governance transform and fixture loader:

- Establishment-scoped BAU StaffRecord rows must be active, not deleted or
  forced-archived, and have no past step-down date. Their BAU establishment must
  have status 1, 2 or 3. Selection does not depend on which establishments the
  separate Establishment seed successfully loaded.
- BAU roles map to the eight target role types. Chair rows create an appointment
  and an additional office-holder assignment. Source dates create optional terms.
- Person, contact and appointing-body data are not extracted.
- An optional `-Urn 136102` restricts selection to one establishment. Omitting
  it extracts all eligible rows. An empty extract fails before resetting tables.
- Invalid identifiers, duplicate source identifiers, unmapped roles or invalid
  date ranges reject the entire load. Rows are not silently skipped.

The extract finishes before the target is changed. Schema reset, reference-role
seed and fixture loading then commit together. A load failure restores the prior
schema and data. Successful reruns replace the Governance schema and generate new
UUIDs; this is a disposable development rebuild, not an incremental migration.
PostgreSQL checks foreign keys and the runner verifies all four table counts
before committing. The Establishment database is not modified.

Use `-KeepFixture` to retain extracted CSV and generated SQL for diagnosis.

```sql
SELECT count(*) FROM governance.governance_role_type; -- 8
SELECT count(*) FROM governance.governance_appointment;
SELECT count(*) FROM governance.term_of_office;
SELECT count(*) FROM governance.office_holder_assignment;
```
