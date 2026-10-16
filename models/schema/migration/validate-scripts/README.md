# Validation SQL

All `validate*.sql` scripts for the local Establishment fixture live here.
The migration runners and shared test module resolve this directory from the
schema root, rather than relying on the caller's working directory. The case
catalogue retains validator filenames; its loader supplies this directory.

Run the complete suite from the repository root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\run-establishment-tests.ps1"
```

The suite checks all 22 active cases across 41 establishments. Address validators
also display owner, purpose, postal values, business dates and current status.
Some scripts perform synthetic writes within a transaction that rolls back;
use the local modelling target, not a production database. Moving these files
does not change their SQL checks or require reimporting fixture data.

For a read-only E08 report, run
[validate-capacity-and-pupil-measures.sql](validate-capacity-and-pupil-measures.sql)
against the PostgreSQL target. It reports the non-null count for each business
field, whether all four have at least one value, and the measures and census date
for each establishment with a measure block. Census dates come from BAU
`dbo.IndependentSchools.CensusDate`, including for academies and maintained
schools. Missing source dates remain null.
