# Provider Registry Questions and Answers

Questions raised about the EPR data model and ontology, with answers drawn from the model artefacts.

---

## Ontology Questions

### How have the Establishment subtypes been decided? Has this been provided by business? Does it relate at all to the attributes that each type has?

The establishment type subtypes derive directly from the GIAS establishment type code list, which is an existing business classification. The business defined these types through the GIAS data model; the EPR model formalised them as OWL class subtypes.

The class hierarchy uses an intermediate layer — `LaMaintainedSchool`, `Academy`, `FreeSchoolEstablishment` and others — that reflects meaningful business groupings rather than pure attribute differentiation. These intermediate classes are not GIAS-native; they are analytic groupings introduced in the ontology (v0.5) to provide a usable hierarchy.

The taxonomy itself acknowledges the problem: the `EstablishmentType` concept is noted as "an overloaded legacy classification mixing legal form, sector and operational model."

So the answer is: types were provided by business (as the existing GIAS type code list), and the intermediate groupings were determined by the model authors. Type is not purely attribute-driven, but the SHACL does enforce type-specific attribute applicability — so there is a relationship between type and attributes even if type was not originally designed around attribute differences.

---

### Is the Establishment Classification the same as the subtypes in the ontology?

No — they are distinct but related.

`EstablishmentClassification` is an OWL class in the ontology that groups three things together for an establishment:

- `EstablishmentType` — the specific type code (e.g. Community school, Academy converter)
- `EstablishmentTypeGroup` — the grouping of types (e.g. LA-maintained schools, Academies, Colleges)
- `EducationPhase` — the broad stage of education provided (e.g. Primary, Secondary, All through)

The OWL subtype hierarchy (the "subtypes") is a separate mechanism: each GIAS establishment type is also declared as an OWL class that is a `rdfs:subClassOf epr:Establishment`, via the intermediate classes. This allows reasoners to classify an establishment instance as a `LaMaintainedSchool` or an `Academy` purely from its class membership.

These two representations are complementary. The `EstablishmentClassification` pattern expresses classification as data (attributes carried by the record). The OWL subtype hierarchy expresses it as class membership (the type of the thing). A consuming system can use either or both depending on whether it needs data-level type lookup or OWL reasoning.

---

### Can they tell which "Provider Organisations" each school is linked to? How is this represented in the ontology diagram? There is an "accountable for" relationship — is it different when there is a Federation? Is the Federation considered "accountable" as well?

Yes, provider organisation linkage is represented — but it is split between two distinct patterns depending on the type of relationship.

**Accountability relationships** are captured via `EstablishmentAccountability` with three typed object properties:

- `epro:accountableToLocalAuthority` → `epr:LocalAuthority` (all establishment types where LA is the maintaining body)
- `epro:accountableToAcademyTrust` → `epr:AcademyTrust` (academies and free schools)
- `epro:accountableToProprietor` → `epr:Proprietor` (independent schools)

These represent the legal accountability relationship — who is responsible for the school in a statutory or funding-agreement sense.

**Federation membership is modelled differently and is not accountability.** A Federation is an `EstablishmentGroup` (subclass). Membership of a Federation is expressed through `GroupMembership`, not through any accountability property. The school's accountability remains with the local authority (it is still an LA-maintained school); the Federation is an organisational grouping sitting alongside that accountability, not replacing it.

In short: the ontology keeps accountability (legal/funding responsibility) and group membership (organisational structure) deliberately separate. Federations do not carry the "accountable for" relationship. If you want to know what group-type organisations a school is linked to, you follow `hasGroupMembership → GroupMembership → memberOf → EstablishmentGroup`. If you want to know who is accountable for the school, you follow `hasEstablishmentAccountability → accountableTo*`.

---

### Are there any attributes specific to Primary vs Secondary vs Colleges, or are all common attributes — and therefore no need to split subtypes by this categorisation?

Correct assessment: there is no need to split OWL subtypes by education phase. The ontology does not have OWL subclasses for Primary, Secondary or College as distinct types.

Education phase is captured as a separate dimension within `EstablishmentClassification` via `hasEducationPhase → EducationPhase`. It is a named individual (one of a closed enumeration: Primary, Secondary, All through, Not applicable, etc.). This means phase is an attribute of the classification record, not a type-determining feature.

The SHACL does not use phase to drive different attribute sets. The meaningful attribute differences in the model are driven by establishment type (e.g. PRU-specific operational record, FE-specific type classification, children's centre-specific management), not by phase alone. A primary school and a secondary school are both modelled the same way in the ontology — they are both `LaMaintainedSchool` or `Academy` subtypes, with the same attribute set.

---

### Can pupil referral units be a type of school or separate from a school (rather than just a part of a school)?

A Pupil Referral Unit is modelled as a **type of establishment** — it is a subclass of `epr:Establishment` in the type hierarchy. It is not a sub-entity or a part of another establishment.

What makes PRUs distinct is that the ontology also has a separate `PupilReferralUnitOperationalRecord` class, attached to an establishment via `hasPupilReferralUnitOperationalRecord`. This class carries PRU-specific operational data — capacity, places for different pupil types, managed move figures, and whether the establishment is classified as a PRU. This is a type-specific detail record, analogous to the `AccreditationRecord` pattern used for online providers.

So: PRU is a type of establishment (an OWL subtype), and the operational record captures the PRU-specific attributes that do not exist on other establishment types.

---

### Do we deal with other types of accountability owner organisations other than Academies — e.g. Charities?

The accountability model has three typed relationships, covering the main accountability body types:

- Local authority — `epro:accountableToLocalAuthority`
- Academy trust — `epro:accountableToAcademyTrust`
- Proprietor — `epro:accountableToProprietor`

**Proprietors** cover independent schools and they can be any legal form — an individual, a company, a charity, a religious body. The model does not break `Proprietor` into further subtypes by legal form (e.g. no separate `ProprietorCharity` class). The Proprietor carries its name and identity, but its legal form is not separately classified in the current ontology.

So if the question is: do we record a charity as the accountability body for an independent school? Yes — through `Proprietor`. If the question is: do we explicitly model the charity-as-legal-entity with Companies House registration or charity number? Not in the current EPR model. The `CompaniesHouseNumber` class exists for groups and online providers; it is not currently scoped to Proprietors.

If a consuming data model needs to distinguish the legal form of a Proprietor, that would require either sub-typing `Proprietor` or adding an identifier property for charity number or company number.

---

### Do we record independent schools' accountability?

Yes. Independent schools are accountable to a Proprietor, captured via:

```
Establishment
  → hasEstablishmentAccountability → EstablishmentAccountability
    → accountableToProprietor → Proprietor
```

`Proprietor` is a first-class OWL class in the ontology. The SHACL enforces that the `accountableToProprietor` path is applicable to independent school types and is not used for maintained or academy types.

---

### What types of groups are recorded and is the parent entity of a group a type of organisation? It appears that a group is a type of organisation as it has a Group Identifier and a UKPRN.

Correct observation. `EstablishmentGroup` is organisation-like in the model — it carries identifiers (Group ID, Group UKPRN), addresses (registered address, contact address), status, lifecycle dates, governance appointments, and a Companies House number where applicable. There is no generic `Organisation` superclass in the current ontology, but establishment groups map strongly to organisation concepts in external data models.

The group types currently modelled as OWL subclasses of `EstablishmentGroup` are:

| OWL class | Plain name |
| --- | --- |
| `epr:MultiAcademyTrust` | Multi-academy trust |
| `epr:SingleAcademyTrust` | Single-academy trust |
| `epr:SecureSingleAcademyTrust` | Secure single-academy trust |
| `epr:Federation` | Federation |
| `epr:GenericTrust` | Trust (non-academy) |
| `epr:ChildrensCentreGroup` | Children's Centre Group |
| `epr:ChildrensCentreCollaboration` | Children's Centre Collaboration |
| `epr:SchoolSponsor` | School sponsor |

Note that `AcademyTrust` has dual inheritance — it is both a subclass of `EstablishmentGroup` (organisational structure role) and sits in the accountability hierarchy (accountability body role). This dual role is the key modelling point for trusts.

---

### Is there always an Organisation that acts as the head of a Group?

Not always, and it varies by group type.

For **academy trusts** (MAT, SAT, SSAT): the trust itself is the incorporated organisation. There is no separate "head organisation" sitting above the trust. The trust is the group and the legal entity simultaneously.

For **Federations**: there is typically a "lead school" within the federation, but this is not modelled as a "head organisation" in the current ontology. Federation membership uses `GroupMembership`, and `GroupRelationship` (with named individuals like `SuccessorMultiAcademyTrust`, `PredecessorSingleAcademyTrust`) captures succession or merger relationships between groups. There is no `hasLeadSchool` or `hasHeadOrganisation` property in the current model. The local authority remains accountable for the constituent schools; the Federation is an organisational grouping without a separate accountability head.

For **Children's Centre Groups and Collaborations**: local authorities play a coordination role, but this is not modelled as "head of group" in the ontology. The `hasLocalAuthorityForGroup` property (scoped in SHACL to children's centre group types) records the LA in context, but this is a classification / maintaining-authority link, not a head-organisation relationship.

So the short answer is: there is no modelled guarantee that a group always has a head organisation. For trusts the trust is the organisation; for other group types the head-organisation concept is absent from the current model.

---

### What are examples of institutions funded by other government departments?

The taxonomy has a specific type for this: `epr:InstitutionFundedByOtherGovernmentDepartment` (type code 56), grouped under `EstablishmentTypeGroupOtherTypes`.

Additionally, the "Other types" group includes:

| Type | Notes |
| --- | --- |
| Service children's education (`epr:ServiceChildrensEducation`) | Schools funded by the Ministry of Defence or FCDO for the children of service personnel, both in England and overseas |
| Institution funded by other government department (type code 56) | Establishments funded by a government department other than DfE; the specific departments are not enumerated in the taxonomy |
| British schools overseas | English-medium schools outside the UK, not funded by DfE |
| Offshore schools | Schools in UK Crown dependencies or overseas territories |

Further Education colleges and universities/higher education institutions are also distinct type groups but are primarily funded through DfE/ESFA routes, not other government departments.

---

### What kind of Groups have a Companies House number? This implies the Group is actually an Organisation.

Correct implication. In the ontology, `epro:hasGroupCompaniesHouseNumber` has domain `epr:EstablishmentGroup`. In practice, the groups that hold a Companies House number are incorporated legal entities:

- **Multi-academy trusts** — charitable companies limited by guarantee, registered at Companies House
- **Single-academy trusts** — same legal form
- **Secure single-academy trusts** — same legal form

Other group types (Federations, Children's Centre Groups, School Sponsors, GenericTrust) may or may not be incorporated entities; the Companies House number is not guaranteed for these types.

The model uses a single `epr:CompaniesHouseNumber` class reused across group types and online providers. It is a property of `EstablishmentGroup` as a whole (`epro:hasGroupCompaniesHouseNumber`), but in practice it is populated only for incorporated trust types.

This is exactly why the dual-inheritance design for `AcademyTrust` matters: it is simultaneously an `EstablishmentGroup` (the organisational structure) and an accountability body (the legal entity holding the funding agreement). A MAT with a Companies House number is both a group containing establishments and an organisation with legal personality. The model acknowledges this rather than forcing a single parent class.

The concept of "legal entity" is not modelled generically in EPR — it surfaces only as a Companies House number identifier property. If an external data model has a `LegalEntity` concept, MATs and SATs should be mapped there as well as to the organisation / group concepts.
