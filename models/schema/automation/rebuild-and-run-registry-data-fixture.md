# Rebuild And Run Registry Data Fixture

## Purpose

This is the single local command for rebuilding and loading the current Establishment and Governance physical-model slices for the controlled establishment fixture set. The selection is shared by both domains in `models/schema/seed/one-organisation.json`.

The current fixture set is:

```text
100018
106431
136102
```

Every URN is loaded into the Establishment target. Governance processing is also attempted for every URN, but only qualifying current source appointments are loaded.

## Prerequisites

- A local SQL Server copy named `gias_bau_test_local`, populated manually from the approved BAU source. Automation never connects to BAU Test directly.
- A read-only SQL Server login named `reader`, with `SELECT` access to the copied tables. The governance slice needs `dbo.StaffRecord`; the Establishment slice needs `dbo.Establishment` and its lookup tables.
- Local PostgreSQL databases named `establishment_local` and `governance_local`. The `postgres` role must be able to rebuild the `establishment` and `governance` schemas and load their data.
- A PostgreSQL password file at `%APPDATA%\postgresql\pgpass.conf`, with entries matching both targets:

```text
127.0.0.1:5432:establishment_local:postgres:<local-password>
127.0.0.1:5432:governance_local:postgres:<local-password>
```

The password file supplies the PostgreSQL credential only. Database permissions are granted separately. Do not commit the file or a password value.

## How To Run The Process

From `education-provider-registry-docs`, run one command:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-and-run-registry-data-fixture.ps1"
```

The script prompts once for the local SQL Server `reader` password. It resolves all files relative to its own location, so no `Set-Location` command is needed.

To retain the temporary CSV files for local troubleshooting:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-and-run-registry-data-fixture.ps1" -KeepFixture
```

## Internal Execution Flow

The developer runs only the command above. The wrapper performs these stages:

```text
models/schema/seed/one-organisation.json
        |
        | reads the controlled establishment URN set
        v
Prompt once for local SQL Server reader password
        |
        +--> Rebuild establishment_local / establishment schema
        |      Seed establishment reference data
        |      Extract and load every selected URN
        |
        +--> Rebuild governance_local / governance schema
               Extract current StaffRecord appointments for every selected URN
               Load each governance appointment fixture, including zero-row fixtures
        |
        v
Validate both local PostgreSQL targets
        |
        v
Remove SQL Server password variable and temporary files
```

### Establishment Slice

The wrapper runs `establishment/core-establishment-schema.sql`, then `seed/seed-reference-data.sql`, then `invoke-establishment-migration.ps1` once per selected URN. The runner uses the reusable BAU transform and PostgreSQL loader under `establishment/`.

### Governance Slice

The wrapper runs `governance/governance-schema.sql`, then `invoke-governance-migration.ps1` once per selected URN. The current minimal table contains only a target UUID, the establishment URN, `StaffRecord.uid` as the source appointment identifier, and an optional role type code. The first pass does not migrate people, terms, appointment bases or appointing bodies.

### Validation

The wrapper shows every selected Establishment record with pupil and FSM measures, then the governance appointment counts for the same URNs. An establishment with no qualifying current appointment loads an empty governance fixture and does not stop the wider run. The output does not print names or other personal information from `StaffRecord`.

## Credential And Temporary-File Handling

The SQL Server password is entered interactively, converted into the temporary `EPR_BAU_SQL_PASSWORD` environment variable for the two child runners, and removed in the wrapper's `finally` block. It is never written to a repository file, CSV, SQL file or command line.

`psql` is invoked with `-w`, so it reads PostgreSQL credentials from `pgpass.conf` rather than prompting or receiving a command-line password.

Unless `-KeepFixture` is supplied, the wrapper deletes every temporary CSV file, one Establishment and one Governance file per selected URN. Each domain runner also removes its temporary rendered loader SQL file.
