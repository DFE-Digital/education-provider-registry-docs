# Validation SQL

All `validate*.sql` scripts for the local Establishment fixture live here.
The migration runners and shared test module resolve this directory from the
schema root, rather than relying on the caller's working directory. The case
catalogue retains validator filenames; its loader supplies this directory.

Run the complete suite from the repository root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\run-establishment-tests.ps1"
```

The suite checks all 23 active cases across 42 establishments. Address validators
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

[validate-additional-classifications.sql](validate-additional-classifications.sql)
is the read-only E15 report. It counts further-education-type and Section 41
values, then lists the retained codes and readable labels by URN. Not applicable
and Unknown source values map to null, as do missing source values. The
reviewed T10 controlled school core retains its intentionally limited scope.

[validate-faith-and-diocese.sql](validate-faith-and-diocese.sql) is the read-only
E16 report. It counts religious character, religious ethos and diocese values,
then lists their retained codes and labels by URN. None is a real value;
Not applicable, Unknown and missing source data map to null.

[validate-null-reference-policy.sql](validate-null-reference-policy.sql) checks
classification and geography reference tables and their incoming foreign keys.
It fails if Unknown or Not applicable rows or links remain and runs with the
core validation suite.

[validate-ofsted-link.sql](validate-ofsted-link.sql) is the read-only E17 report.
It counts populated text links, checks whether every populated link follows
the migration rule and lists the links by URN. A populated link is navigation
to Ofsted, not confirmation that a report exists.

[validate-specialist-provision.sql](validate-specialist-provision.sql) is the
read-only E09 report. It counts all six business fields, including false
special-classes values and zero measures. The Netley source sample (100018)
is checked by `validate-e09-specialist-provision.sql` in the full regression
suite. The current catalogue has 23 active cases across 42 establishments.

[validate-group-address-coverage.sql](validate-group-address-coverage.sql)
reports E14 migrated-data coverage and lists the actual group/legal-entity
addresses. It separates populated postal fields, address purposes and business
dates; rolled-back synthetic constraint-test rows do not count as migration data.

[validate-t10-registered-office.sql](validate-t10-registered-office.sql) checks
the Companies House registered office for Outwood and its source provenance.
It also asserts that the BAU administrative address remains intact. This is a
supplementary T10 check in the normal 23-case regression suite.
