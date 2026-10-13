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
