# Validation SQL

The test suite runs these three scripts against the local Establishment
database, through `Test-EstablishmentCoreValidation`:

| Script | Checks |
| --- | --- |
| `validate-establishment-fixture.sql` | Core tables are populated and their keys join up. |
| `validate-null-reference-policy.sql` | No Unknown or Not applicable rows or links remain in the reference tables. |
| `validate-group-address-constraints.sql` | Group and legal-entity address constraints hold. |

Some checks write synthetic rows inside a transaction that rolls back, so use
the local modelling target, not a production database.

Run the suite from the repository root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\run-establishment-tests.ps1"
```
