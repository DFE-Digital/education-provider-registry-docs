# Validation SQL

The test suite runs these scripts against the local Establishment
database, through `Test-EstablishmentCoreValidation`:

| Script | Checks |
| --- | --- |
| `validate-establishment-fixture.sql` | Core tables are populated and their keys join up. |
| `validate-null-reference-policy.sql` | No Unknown or Not applicable rows or links remain in the reference tables. |
| `validate-group-address-constraints.sql` | Group and legal-entity address constraints hold. |
| `validate-sen.sql` | Current SEN reference values, associations and keys hold. |
| `validate-reference-identities.sql` | Reference identities match the imported source dictionaries. |

Some checks write synthetic rows inside a transaction that rolls back, so use
the local modelling target, not a production database.

Both rebuild commands run the suite automatically. To test the already loaded
selection from the repository root:

```powershell
Import-Module .\models\schema\automation\EprLocalAutomation\EprLocalAutomation.psm1
Invoke-EstablishmentTests -Target (New-PostgresTarget) -Selection (Get-FixtureSelection)
```
