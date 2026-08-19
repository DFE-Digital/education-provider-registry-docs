# Rebuild And Run The Basic Establishment Fixture

This runbook documents the single command used from the
`education-provider-registry-docs` repository:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-and-run-basic-establishment-fixture.ps1"
```

The command rebuilds the disposable local PostgreSQL Establishment schema,
seeds reference data, transforms three controlled BAU records, loads them into
PostgreSQL and validates the result.

Run the wrapper command, everything
after that is an internal execution stage performed by the PowerShell scripts.

The controlled fixture contains URNs `100018`, `106431` and `136102`.

## Boundary and safety

Automation starts from the local SQL Server copy `gias_bau_test_local`. It must
never connect directly to the BAU databases. The PostgreSQL target database `establishment_local`.

The wrapper deliberately drops and recreates only the PostgreSQL
`establishment` schema. It is suitable for local modelling and test data only;
do not run it against shared, Test, staging or production databases.

## Execution flow

```text
Run from education-provider-registry-docs
        |
        v
rebuild-and-run-basic-establishment-fixture.ps1
        |
        +--> Locate schema, seed, runner and PostgreSQL client files
        |
        +--> Prompt for local SQL Server reader password
        |
        +--> psql: basic-establishment-data-schema.sql
        |       `-- DROP/CREATE establishment schema and tables
        |
        +--> psql: seed/seed-reference-data.sql
        |       `-- Insert controlled reference values
        |
        +--> Set EPR_BAU_SQL_PASSWORD for this process only
        |
        +--> migrate-basic-establishment-fixture.ps1
        |       |
        |       +--> .NET SQL client connects to gias_bau_test_local
        |       +--> Run the BAU transform for URNs 100018, 106431 and 136102
        |       +--> Write a temporary pipe-delimited CSV
        |       +--> Substitute the CSV path into temporary loader SQL
        |       `--> psql loads the fixture into establishment_local
        |
        +--> psql validation query
        |
        `--> finally: remove password variable and, unless -KeepFixture,
                    delete the temporary CSV
```

## Prerequisites

The one-command process assumes the local source and target environments have
already been prepared. These are setup activities, not part of the migration
run itself.

### Isolated local SQL Server source copy

Create and maintain a separate local SQL Server database named
`gias_bau_test_local`. Copy only the required BAU schema and data into this
database using the approved manual SSMS process. Automation must never connect
directly to the BAU Test database.

For the current fixture, the local copy must contain `dbo.Establishment` and
the lookup tables used by `models/schema/transforms/establishment-from-bau.sql`.
It must contain the controlled URNs:

```text
100018
106431
136102
```

### SQL Server `reader` login

Configure a local SQL Server login named `reader` with a password known only to
the operator. Grant it read-only access to `gias_bau_test_local`, normally by
mapping it to a database user and granting the required `SELECT` permissions on
the copied source and lookup tables. An illustrative SSMS setup is:

```sql
CREATE LOGIN [reader] WITH PASSWORD = '<local-password>';
USE [gias_bau_test_local];
CREATE USER [reader] FOR LOGIN [reader];
ALTER ROLE [db_datareader] ADD MEMBER [reader];
```

Use the local administrator's approved process to create this login. Replace
`<local-password>` interactively; do not save the statement containing the
password in the repository.

The migration runner uses this login through the local .NET SQL client. The
password is entered interactively when the wrapper runs; it is not stored in
the repository or in the command line.

### Local PostgreSQL target database

Create a local PostgreSQL database named:

```text
establishment_local
```

The PostgreSQL `postgres` user runs the schema, seed, loader and validation
commands. The wrapper rebuilds the `establishment` schema inside this database;
it does not create or drop the database itself.

The database and role permissions are configured separately from `pgpass.conf`.
The `postgres` role must be able to connect to `establishment_local`, create and
drop the `establishment` schema, create tables and insert reference and fixture
data. The password file only supplies the credential to `psql`; it does not
grant permissions.

### PostgreSQL password-file access

Configure the current Windows user's PostgreSQL password file at:

```text
C:\Users\<user>\AppData\Roaming\postgresql\pgpass.conf
```

For this process it must contain an entry matching:

```text
127.0.0.1:5432:establishment_local:postgres:<local-password>
```

`psql` reads this file automatically. Do not put the password in the script,
the repository or a command-line argument. If `governance_local` is used by a
future process, add a separate database-specific entry for it.

## How to run the process

The command assumes the current PowerShell directory is:

```text
\education-provider-registry-docs
```

Run this command from the repository root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-and-run-basic-establishment-fixture.ps1"
```

`-ExecutionPolicy Bypass` applies only to this invocation. It does not change
the machine or user execution policy.

The wrapper resolves its paths from `$PSScriptRoot`.

## Internal execution stages

The following stages are performed by the wrapper and inner migration scripts;
the developer does not run them individually.

### Internal stage 1: Rebuild the PostgreSQL schema

The wrapper calls `models/schema/basic-establishment-data-schema.sql`. Its key
operations are:

```sql
DROP SCHEMA IF EXISTS establishment CASCADE;
CREATE SCHEMA IF NOT EXISTS establishment;
```

This removes and recreates only the local `establishment` schema. The
`establishment_local` database itself is not dropped.

### Internal stage 2: Seed reference data

The wrapper then runs:

```text
models/schema/seed/seed-reference-data.sql
```

This inserts the stable reference identifiers used by target foreign keys,
including establishment type, education phase, gender, admissions, boarding,
nursery, sixth-form and specialist-provision values.

### Internal stage 3: Enter the SQL Server password securely

The wrapper prompts interactively:

```powershell
$securePassword = Read-Host 'Local SQL Server reader password' -AsSecureString
$env:EPR_BAU_SQL_PASSWORD = [System.Net.NetworkCredential]::new('', $securePassword).Password
```

The password is held only for the child migration process, read by
`migrate-basic-establishment-fixture.ps1`, passed to the local .NET SQL client,
and removed in the wrapper's `finally` block. No SQL Server password is stored
in the repository, CSV, SQL file or command-line history.

The source connection is local-only:

```text
Server: localhost
Database: gias_bau_test_local
Login: reader
```

### Internal stage 4: Transform the controlled source records

The inner runner invokes:

```text
models/schema/transforms/establishment-from-bau.sql
```

It runs the transform once for each controlled URN:

```text
100018
106431
136102
```

Key mappings include:

```text
SchoolCapacity                    -> school_capacity
NumberOfPupils                    -> pupil_count
freeSchoolMeals                   -> free_school_meal_measure
StatutoryLowAge/HighAge           -> statutory age range
resourcedProvision*               -> resourced provision measures
senUnit*                          -> SEN-unit measures
primary address fields             -> main Site -> Address
```

The BAU source has no census-date field, so `census_date` remains `NULL` rather
than being inferred.

### Internal stage 5: Create the temporary CSV

The runner writes the transformed rows to:

```text
C:\Users\<user>\AppData\Local\Temp\epr-basic-establishment-fixture.csv
```

The file is pipe-delimited and is only a local hand-off between the SQL Server
transform and PostgreSQL loader. It may contain local source data and must not
be committed.

To retain it for troubleshooting:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-and-run-basic-establishment-fixture.ps1" -KeepFixture
```

Without `-KeepFixture`, the wrapper deletes the CSV in its `finally` block.

### Internal stage 6: Load PostgreSQL

The inner runner reads:

```text
models/schema/automation/load-basic-establishment-fixture.sql
```

It substitutes the temporary CSV path into a temporary copy of the loader SQL
and runs that copy with `psql`. The committed loader SQL is not modified.

The loader stages the CSV, upserts establishments by URN, loads the main site
and address, capacity and pupil measures, FSM measures, education/admissions
values, statutory ages and specialist-provision measures.

PostgreSQL does not receive a password from the script. `psql` reads it from:

```text
C:\Users\<user>\AppData\Roaming\postgresql\pgpass.conf
```

The matching entry has this form:

```text
127.0.0.1:5432:establishment_local:postgres:<local-password>
```

Replace `<local-password>` locally. Never commit the password value.

### Internal stage 7: Validate the result

The wrapper runs:

```sql
SELECT e.urn,
       e.name,
       m.pupil_count,
       m.free_school_meal_measure
FROM establishment.establishment AS e
JOIN establishment.capacity_and_pupil_measures AS m
  ON m.establishment_id = e.establishment_id
WHERE e.urn IN (100018, 106431, 136102)
ORDER BY e.urn;
```

Expected values are:

| URN | Pupil count | Free-school-meal measure |
|---:|---:|---:|
| 100018 | 383 | 224 |
| 106431 | 209 | 15 |
| 136102 | 1300 | 735 |

### Internal stage 8: Password and temporary-data cleanup

The wrapper always executes:

```powershell
Remove-Item Env:EPR_BAU_SQL_PASSWORD -ErrorAction SilentlyContinue
Remove-Variable securePassword -ErrorAction SilentlyContinue
if (-not $KeepFixture) {
    Remove-Item -LiteralPath $FixturePath -Force -ErrorAction SilentlyContinue
}
```

The PostgreSQL `pgpass.conf` file remains on the local machine for future
`psql` commands. It is outside the repository and must not be copied into or
shared from the repository.
