# Code-list identity migration

The five reviewed code lists now separate internal UUID identity from published
BAU codes. Codes and matching labels are reconciled directly against the local
BAU dictionaries; lookup-row IDs are not used as business codes.

| Table | Primary key | Business code |
| --- | --- | --- |
| `establishment_type_category` | Existing UUID | Required unique integer |
| `establishment_status` | UUID | Required unique integer |
| `education_phase` | UUID | Required unique integer |
| `reason_establishment_opened` | UUID | Required unique text |
| `reason_establishment_closed` | UUID | Required unique text |

Names are required and unique. Reason codes retain leading zeroes, such as
`01` and `04`. Detailed `establishment_type.code` remains text.

The lifecycle status/reason foreign keys and establishment phase foreign key
use UUIDs. Business rules compare the joined reference code. In particular,
maintenance and proprietor rules still include status codes `1` and `3` where
they did before this change.

The previous education-phase IDs were not BAU codes: for example, internal ID
`5` meant Secondary, whose BAU code is `4`. The conversion preserves each
reference's meaning and assigns the correct published code. BAU code `6` is
labelled `16 plus`; this replaces the previous target label `16 to 19`.

## Existing local target

From the repository root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File models/schema/automation/migrate-code-lists-from-local-bau.ps1
```

The command runs [the transactional upgrade](upgrade-code-list-identities.sql),
checks UUID/code constraints and compares every modelled code/name pair and
all detailed-type/category-code mappings with BAU. The upgrade preserves the
existing establishment set, status meanings, dates and reason relationships.
It can also be run against an already upgraded target.

Use the existing connection parameters for a different local SQL Server
instance or PostgreSQL connection. The automation retains its local-only
source and target restrictions.

## Rebuilds and fixtures

The BAU rebuild validates the reference codes against BAU before importing
establishments. The establishment transform supplies source codes and the
PostgreSQL loader resolves UUIDs from those codes. Missing, malformed,
unmapped or conflicting meaningful codes are rejected before record changes.
Documented unknown/inapplicable optional values remain absent.

The checked-in reference and establishment seeds contain the same UUID/code
mappings. Approval queries return business codes separately from internal
UUIDs. Both rebuild paths run
[code-list constraint checks](validate-scripts/validate-code-list-identities.sql)
and the existing catalogue and approval tests.

## Inspect the target

```sql
SELECT * FROM establishment.establishment_type_category ORDER BY code;
SELECT * FROM establishment.establishment_status ORDER BY code;
SELECT * FROM establishment.education_phase ORDER BY code;
SELECT * FROM establishment.reason_establishment_opened ORDER BY code;
SELECT * FROM establishment.reason_establishment_closed ORDER BY code;
```

The current model contains 11 categories, 4 statuses, 7 phases, 13 opening
reasons and 13 closing reasons. Extra administrative BAU statuses and
unknown/inapplicable placeholders are outside these modelled lists.

Logical reference tables show business codes and names; canonical-identifier
metadata has been removed from the logical models.
