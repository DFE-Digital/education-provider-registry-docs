# E09: Netley specialist provision

URN **100018**, Netley Primary School & Centre for Autism, supplies the real
source sample needed for E09 field coverage. It is loaded by the standard BAU
establishment transform and loader, through `seed/fixture-selection.json`.
The active catalogue names this coverage case E09 alongside the existing T cases.

The local BAU source checked on 16 October 2026 records:

- `typeOfReservedProvision_code=3`: resourced provision and SEN unit.
- Resourced capacity and pupils on roll: **24** and **24**.
- SEN-unit capacity and pupils on roll: **24** and **24**.
- `specialClasses_code=1`: special classes **true**.

This is a school-provision sample. No additional group identity or membership
is inferred. Its full establishment approval is saved as
`tests/approval/establishment-100018.approved.json`. The E09 regression SQL
asserts the six source-derived facts. The source-to-target migration retains
all previous selected establishments and adds this school, giving 42 total.
