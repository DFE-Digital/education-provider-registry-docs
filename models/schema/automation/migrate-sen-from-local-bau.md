# Add SEN to the existing local database

Run from `education-provider-registry-docs`:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\models\schema\automation\migrate-sen-from-local-bau.ps1
```

This additive migration reads the URNs already present in `establishment_local`, extracts their SEN data and the complete dictionary from `gias_bau_test_local`, and takes a full PostgreSQL backup before making changes. It applies the shared [SEN schema](../establishment/sen-schema.sql), imports current reference values from the source extract and applies all selected association loads in one transaction. It does not load the static SEN reference seed. An error rolls back that transaction. Existing establishment and association identities are retained. The working files and pre-migration backup remain in the reported working directory.

The connection guards permit only local databases. Source credentials use the existing `EPR_BAU_SQL_PASSWORD` reader setting, or `-UseWindowsAuthentication`. PostgreSQL uses the existing local `pgpass.conf`. `-SqlServer`, `-SourceDatabase`, `-PostgresHost`, `-PostgresDatabase` and `-FixtureDirectory` provide the same local choices as the rebuild tooling.

The current-only cut contains 12 substantive lookup values. Code `00` (Not Applicable), archived values and their associations are excluded. A source establishment with only code `00` has no target SEN relationship. The target has no archive column. Source codes map by their leading-zero text values. A substantive current association in legacy buckets 2–4, a broken source reference or dictionary drift stops the migration for review.

Each successful association load retains raw source rows, bucket provenance and exclusion counts through the existing migration run, snapshot and source-record tables. Replaying a set keeps unchanged link UUIDs and removes associations no longer present. No links and a missing source establishment have different outcomes: the first clears the selected set, while the second fails.

The command runs `Test-SenMigration` after committing. That check covers the reference inventory, foreign keys, unique pairs and 12 loader scenarios. Test scenarios roll back. A failing post-migration check reports failure; it does not undo an already committed migration. Use the retained backup if a full restore is required.

Both rebuild paths also support SEN. The BAU path reconciles the dictionary and loads each selected URN's associations. The checked-in path restores the exported lookup, links and provenance. The internal establishment facts query includes the SEN code/name array; this does not change the public API contract.
