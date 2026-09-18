# Establishment geography

This is the first geography slice for the Establishment Registry. It models
the establishment's current local-authority, Government Office Region and
administrative-district relationships without attempting to model the complete
administrative geography hierarchy.

## Scope

This slice answers:

```text
Which local authority is associated with this establishment?
```

It covers:

- The current local authority associated with an establishment.
- The Government Office Region classification associated with an establishment.
- The controlled local-authority code and name.
- The Government Statistical Service local-authority code used for ONS
  geographic integration.
- Normalised local-authority contact records.
- The distinction between local-authority accountability and the physical
  address of the establishment.
- The administrative district associated with the establishment's location.

It does not yet cover wards, parliamentary constituencies, LSOAs,
MSOAs, urban/rural classifications or postcode-derived
geography. Those should be added as separate geography slices after the local
authority relationship is reviewed.

## Design decision

Local-authority geography is modelled in a dedicated `establishment_geography`
entity rather than as a column on `establishment`. This keeps the core identity
record focused on the establishment itself and gives geography a clear place
for future attributes, such as additional administrative areas or effective
dates. The first version is an optional one-to-one record containing a
`local_authority_id` foreign key to the stable local-authority reference,
an optional `government_office_region_id` foreign key to the region reference,
and an optional `district_administrative_id` foreign key to the district
reference.

## Geography ERD

```mermaid
erDiagram
    ESTABLISHMENT ||--o| ESTABLISHMENT_GEOGRAPHY : "has geography"
    ESTABLISHMENT_GEOGRAPHY }o--o| LOCAL_AUTHORITY : "uses local authority"
    ESTABLISHMENT_GEOGRAPHY }o--o| GOVERNMENT_OFFICE_REGION : "uses region"
    ESTABLISHMENT_GEOGRAPHY }o--o| DISTRICT_ADMINISTRATIVE : "uses district"
    LOCAL_AUTHORITY }o--|| LOCAL_AUTHORITY_JURISDICTION : "has jurisdiction"
    LOCAL_AUTHORITY }o--o| GSS_LOCAL_AUTHORITY_CODE : "uses GSS code"
    LOCAL_AUTHORITY ||--o{ LOCAL_AUTHORITY_CONTACT : "has contacts"

    ESTABLISHMENT {
        uuid establishment_id PK
        numeric urn UK
        integer establishment_number
        string name
    }

    ESTABLISHMENT_GEOGRAPHY {
        uuid establishment_geography_id PK
        uuid establishment_id FK, UK
        uuid local_authority_id FK
        uuid government_office_region_id FK
        uuid district_administrative_id FK
    }

    GOVERNMENT_OFFICE_REGION {
        uuid government_office_region_id PK
        string code UK
        string name
    }

    DISTRICT_ADMINISTRATIVE {
        uuid id PK
        string code UK
        string name
        boolean archived
    }

    LOCAL_AUTHORITY {
        uuid local_authority_id PK
        integer code UK
        string name
        integer local_authority_jurisdiction_id FK
        uuid gss_local_authority_code_id FK
    }

    GSS_LOCAL_AUTHORITY_CODE {
        uuid id PK
        string code UK
    }

    LOCAL_AUTHORITY_CONTACT {
        uuid local_authority_contact_id PK
        uuid local_authority_id FK
        string contact_email
        string contact_first_name
        string contact_last_name
        string contact_title
        string contact_phone
        string contact_role
        boolean is_current
    }

    LOCAL_AUTHORITY_JURISDICTION {
        integer local_authority_jurisdiction_id PK
        string name UK
    }
```

## Local authority

`local_authority` is controlled reference data for the local authority
associated with an establishment. The relationship is optional because not
all establishment types have the same local-authority context, and some
providers operate outside a conventional English local-authority structure.

| Column | Required | Meaning and rule |
| --- | --- | --- |
| `local_authority_id` | Yes | Stable target identifier for the reference record. |
| `code` | Yes | Numeric DfE local-authority code used for LAESTAB/DfE-number reconciliation. |
| `name` | Yes | Current published local-authority name. |
| `local_authority_jurisdiction_id` | Yes | Controlled jurisdiction classification for the local authority. |

The code is the integration and reconciliation value. The name is a label and
may change without changing the identity of the local authority record.

## GSS local-authority code

GSS means Government Statistical Service. A GSS local-authority code is the
standard ONS geographic identifier for a local authority, for example
E08000007 for Stockport. It is used to link a local authority to ONS
statistical datasets and other published geographic products.

The GSS code is distinct from the numeric DfE local-authority code:

| Identifier | Example | Purpose |
| --- | --- | --- |
| DfE local-authority code | 861 | Legacy GIAS integration and DfE number/LAESTAB reconciliation. |
| GSS local-authority code | E08000007 | ONS and Government Statistical Service geographic integration. |

The legacy BAU source represents this relationship through:

| BAU table | Role |
| --- | --- |
| dbo.GSSLACode | GSS code. The source name, archive and order fields are not retained in the target. |
| dbo.LaGssMapping | Maps localAuthority_code to gssLaCode_code. |
| dbo.Establishment.GssLaCode_code | Direct GSS code recorded against an establishment. |

The local-authority reference should use the mapping from dbo.LaGssMapping to
associate the existing DfE local-authority code with the GSS code. The GSS code
must remain text; values begin with a letter and must not be converted to an
integer.

## Local authority jurisdiction

`local_authority_jurisdiction` classifies the jurisdiction represented by a
local-authority reference. It replaces the legacy `LocalAuthorityGroup` name,
which describes these values inaccurately as a group.

This is a closed controlled list:

| Value | Meaning |
| --- | --- |
| English | Local authority for an English jurisdiction. |
| Welsh | Local authority for a Welsh jurisdiction. |

“Not applicable” is represented by a missing geography relationship, not by a
sentinel jurisdiction or local-authority record.

## Establishment geography

`establishment_geography` is an optional, one-to-one owned substructure for
the establishment's current geography. It keeps geography attributes out of
the core establishment identity table while preserving the DfE number/LAESTAB
relationship through the referenced `local_authority` record.

| Attribute | Required | Meaning and rule |
| --- | --- | --- |
| `establishment_geography_id` | Yes | Technical key for the geography substructure. |
| `establishment_id` | Yes | One-to-one owner relationship to `establishment`. |
| `local_authority_id` | Conditional | Current local-authority relationship, where the source provides one. Foreign key to `local_authority.local_authority_id`. |
| `government_office_region_id` | Conditional | Current Government Office Region classification, where the source provides one. Foreign key to `government_office_region.government_office_region_id`. |
| `district_administrative_id` | Conditional | Current administrative district classification, where the source provides one. Foreign key to `district_administrative.id`. |

An establishment has at most one current geography record and at most one
current local authority in this slice. This
does not imply that the local authority is the establishment's owner or
accountable body. Ownership, accountability and governance relationships are
separate concepts and will be modelled in the establishment-group and
governance slices.

## Government Office Region

`government_office_region` is controlled reference data for the region
classification recorded directly against an establishment. It is linked from
`establishment_geography`, rather than from `local_authority`, because the
legacy source stores `GOR_code` on `dbo.Establishment`.

| Attribute | Required | Meaning and rule |
| --- | --- | --- |
| `government_office_region_id` | Yes | Stable target identifier for the reference record. |
| `code` | Yes | Legacy GOR integration code; unique in the target reference data. |
| `name` | Yes | Published region name. |

The region relationship is optional. A missing value means that no GOR
classification is available; it does not require a sentinel region record.

## Administrative district

`district_administrative` is controlled reference data for the administrative
district recorded against an establishment. The source uses the term
`DistrictAdministrative`. In two-tier areas this is a district council below
county level; in unitary-authority, metropolitan-district and London-borough
areas it may represent the same geography as the local authority.

All rows from the BAU reference table are retained, including archived rows.
The archive flag describes the status of the reference value; it does not
justify deleting a value that is still referenced by an establishment. This
also preserves special values such as `L99999999` (Channel Islands) and
`M99999999` (Isle of Man).

| Attribute | Required | Meaning and rule |
| --- | --- | --- |
| `id` | Yes | Technical UUID key generated by the target. |
| `code` | Yes | BAU `DistrictAdministrative.code`, unique in the target. |
| `name` | Yes | BAU district name. |
| `archived` | Yes | BAU archive indicator retained as a boolean. |

The establishment relationship is optional. A missing value means that the
source did not provide a district classification; it does not require a
sentinel district record.

## Local authority contact

`local_authority_contact` stores contact details separately from the local
authority identity. A local authority may have multiple contacts, and contact
records can be retained when responsibilities or contact details change.

| Column | Required | Meaning and rule |
| --- | --- | --- |
| `local_authority_contact_id` | Yes | Technical key for the contact record. |
| `local_authority_id` | Yes | Foreign key to the owning local authority. |
| `contact_email` | Conditional | Contact email address, where supplied. |
| `contact_first_name` | Conditional | Contact person's given name, where supplied. |
| `contact_last_name` | Conditional | Contact person's family name, where supplied. |
| `contact_title` | Conditional | Contact person's title or job title, where supplied. |
| `contact_phone` | Conditional | Contact telephone number, where supplied. |
| `contact_role` | Conditional | Role or purpose of the contact; controlled values require further evidence. |
| `is_current` | Yes | Indicates whether the contact is current. Multiple current contacts are permitted until role rules are agreed. |

## BAU source mapping

The legacy schema already treats `dbo.Establishment.LA_code` as a foreign key
to `dbo.LocalAuthority.code`:

| Logical concept | BAU source | Notes |
| --- | --- | --- |
| Establishment local-authority code | `dbo.Establishment.LA_code` | Nullable current relationship, loaded into `establishment_geography`. |
| Local-authority code | `dbo.LocalAuthority.code` | Controlled integration value. |
| Local-authority name | `dbo.LocalAuthority.name` | Current display label. |
| Local-authority jurisdiction | `dbo.LocalAuthority.group_code` -> `dbo.LocalAuthorityGroup.name` | Legacy source relationship; target name is `LocalAuthorityJurisdiction`. |
| GSS local-authority code | `dbo.LaGssMapping.localAuthority_code` -> `dbo.LaGssMapping.gssLaCode_code` -> `dbo.GSSLACode.code` | Standard ONS geographic identifier for the local authority. |
| Government Office Region | `dbo.Establishment.GOR_code` -> `dbo.GovernmentOfficeRegion.code` | Nullable establishment geography classification. |
| Administrative district | `dbo.Establishment.districtAdministrative_code` -> `dbo.DistrictAdministrative.code` | Nullable establishment geography classification. All `dbo.DistrictAdministrative` rows are retained, including archived values. |

The existing DfE number remains derived from local-authority code and
establishment number. This geography slice does not change the identifier
rules; it normalises the local-authority reference so the relationship has an
explicit target entity.

## Rules and open decisions

- `local_authority.code` must be unique in the target reference data.
- `district_administrative.code` must be unique in the target reference data.
- All BAU DistrictAdministrative rows are migrated; `archived` is preserved and
  must not be used to filter rows that are still referenced.
- GSS local-authority codes must be stored as text and remain unique in the GSS
  reference data.
- A DfE local-authority code may map to at most one current GSS code in the
  initial model.
- An establishment may have no local-authority relationship when the source
  does not provide one or the establishment is outside the conventional local
  authority model.
- Local-authority names must not be copied into `establishment` as free text.
- Local-government reorganisation and historical local-authority changes are
  deferred. A future history model will be needed if the service must explain
  which authority applied at a past date.
- The complete set of local-authority values should be extracted from the BAU
  source before physical-schema and seed work begins.

## Physical implementation boundary

The physical model uses these tables:

| Logical concept | Physical table | Current status |
| --- | --- | --- |
| Establishment geography | `establishment.establishment_geography` | Physical table defined with nullable `local_authority_id`; source migration populates it only when a real local authority applies. |
| Local-authority jurisdiction | `establishment.local_authority_jurisdiction` | Schema and English/Welsh controlled values defined. |
| Local authority | `establishment.local_authority` | Schema defined; BAU reference data still to be loaded. |
| GSS local-authority code | `establishment.gss_local_authority_code` | Target-owned UUID `id` and unique text `code`; BAU `dbo.GSSLACode` and `dbo.LaGssMapping` supply the code values. |
| Government Office Region | `establishment.government_office_region` | Controlled reference table defined and wired to the migration; load from the local BAU `dbo.GovernmentOfficeRegion` copy before establishment rows. |
| Local-authority contact | `establishment.local_authority_contact` | Schema defined as a one-to-many relationship; BAU contact data still to be loaded. |

The target relationship will use `establishment_geography.local_authority_id`
as the foreign key to `local_authority.local_authority_id`. The local
authority's numeric `code` remains reference data used for DfE-number/LAESTAB
reconciliation, but is not used as the relationship key.
