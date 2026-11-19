# Run local BAU migrations by domain

From the `education-provider-registry-docs` repository root:

```powershell
# Establishment only.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-from-local-bau.ps1" -SqlServer "localhost" -Establishment

# Governance only; keeps the already-loaded Establishment database.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-from-local-bau.ps1" -SqlServer "localhost" -Governance

# Both domains, Establishment followed by Governance.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-from-local-bau.ps1" -SqlServer "localhost" -Establishment -Governance
```

At least one domain switch is required.

For the single **EPR Transation** instance on port 5433, containing databases
`establishment` and `governance`, explicitly override the older defaults:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-from-local-bau.ps1" -SqlServer "localhost" -Establishment -Governance -EstablishmentPort 5433 -GovernancePort 5433 -EstablishmentDatabase "establishment" -GovernanceDatabase "governance"
```

Both password-file entries use the same transactional instance administrator
password, with database names `establishment` and `governance` and port 5433.
Database-name overrides also accept the previous `epr_*` and `*_local` names.

The independent branches are:

```powershell
if ($Establishment) { # Call rebuild-establishment-from-local-bau.ps1 }
if ($Governance)    { # Call rebuild-governance-from-local-bau.ps1 }
```

The wrapper chooses domains and shares connection options; each domain script
retains its SQL, load rules, checks and transaction handling. Both domain scripts
remain independently runnable. There is no shared transaction across databases.
A failure stops the wrapper; a completed Establishment load is retained if the
later Governance load fails. Logged Establishment data rejections do not stop it.

| Domain | Default target | Override parameters |
| --- | --- | --- |
| Establishment | `127.0.0.1:5433/epr_establishment` | `-EstablishmentPort`, `-EstablishmentDatabase`, `-EstablishmentPassword` |
| Governance | `127.0.0.1:5434/epr_governance` | `-GovernancePort`, `-GovernanceDatabase`, `-GovernancePassword` |

Both databases must already exist. Configure their separate entries in
`%APPDATA%\postgresql\pgpass.conf` using each instance's own password:

```text
127.0.0.1:5433:epr_establishment:postgres:<establishment-password>
127.0.0.1:5434:epr_governance:postgres:<governance-password>
```

Shared parameters include `-PostgresHost`, `-PostgresUser`, `-SqlServer`,
`-SourceDatabase`, `-SqlUser` and `-UseWindowsAuthentication`. The BAU password is
resolved once from `-SqlPassword` (SecureString), `EPR_BAU_SQL_PASSWORD` or a prompt,
then passed to both scripts without storing it in files. `-Urn 136102` applies
the same single-establishment selection to both chosen branches. `-KeepFixture`
retains working files for troubleshooting.

See the [Establishment runbook](rebuild-establishment-from-local-bau.md) and
[Governance runbook](rebuild-governance-from-local-bau.md) for the independent
load semantics. These are disposable development rebuilds. A successful
Governance rebuild generates fresh UUIDs.
