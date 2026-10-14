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

The OWL subtype hierarchy (the "subtypes") is a separate mechanism: each GIAS establishment type is also declared as an OWL class that is a `rdfs:subClassOf est:Establishment`, via the intermediate classes. This allows reasoners to classify an establishment instance as a `LaMaintainedSchool` or an `Academy` purely from its class membership.

These two representations are complementary. The `EstablishmentClassification` pattern expresses classification as data (attributes carried by the record). The OWL subtype hierarchy expresses it as class membership (the type of the thing). A consuming system can use either or both depending on whether it needs data-level type lookup or OWL reasoning.

---

### Can they tell which "Provider Organisations" each school is linked to? How is this represented in the ontology diagram? There is an "accountable for" relationship — is it different when there is a Federation? Is the Federation considered "accountable" as well?
Yes. Since ontology v2.0 there are three separate patterns, depending on the relationship.

**Responsibilities** say which legal entity or person is responsible for a school, in which way, for which period. They are `est:EstablishmentResponsibility` records with four types:

- run by academy trust (`est:AcademyTrustResponsibility`), for academies and free schools
- supported by foundation trust (`est:FoundationTrustResponsibility`), for foundation and foundation special schools
- sponsored by (`est:SponsorResponsibility`), for academies and free schools
- proprietor (`est:ProprietorResponsibility`), for independent schools and other proprietor-run types. A proprietor is responsible for running the school; it need not own its business or premises.

`esto:runByAcademyTrust`, `esto:sponsoredBy` and `esto:hasProprietor` name the present-day trust, sponsor and proprietors.

**Local authority maintenance** is still recorded through `est:EstablishmentAccountability` and `esto:accountableToLocalAuthority`, for maintained schools.

**Federation membership is not a responsibility.** A federation is an `est:EstablishmentGroup`, and its member schools are linked through `est:GroupMembership`. The schools stay maintained by their local authority, and a federation can include schools in more than one local authority. The federation is a grouping alongside that, not a body responsible for the schools.

---

### Are there any attributes specific to Primary vs Secondary vs Colleges, or are all common attributes — and therefore no need to split subtypes by this categorisation?

Correct assessment: there is no need to split OWL subtypes by education phase. The ontology does not have OWL subclasses for Primary, Secondary or College as distinct types.

Education phase is captured as a separate dimension within `EstablishmentClassification` via `hasEducationPhase → EducationPhase`. It is a named individual (one of a closed enumeration: Primary, Secondary, All through, Not applicable, etc.). This means phase is an attribute of the classification record, not a type-determining feature.

The SHACL does not use phase to drive different attribute sets. The meaningful attribute differences in the model are driven by establishment type (e.g. PRU-specific operational record, FE-specific type classification, children's centre-specific management), not by phase alone. A primary school and a secondary school are both modelled the same way in the ontology — they are both `LaMaintainedSchool` or `Academy` subtypes, with the same attribute set.

---

### Can pupil referral units be a type of school or separate from a school (rather than just a part of a school)?

A Pupil Referral Unit is modelled as a **type of establishment** — it is a subclass of `est:Establishment` in the type hierarchy. It is not a sub-entity or a part of another establishment.

What makes PRUs distinct is that the ontology also has a separate `PupilReferralUnitOperationalRecord` class, attached to an establishment via `hasPupilReferralUnitOperationalRecord`. This class carries PRU-specific operational data — capacity, places for different pupil types, managed move figures, and whether the establishment is classified as a PRU. This is a type-specific detail record, analogous to the `AccreditationRecord` pattern used for online providers.

So: PRU is a type of establishment (an OWL subtype), and the operational record captures the PRU-specific attributes that do not exist on other establishment types.

---

### Do we deal with other types of accountability owner organisations other than Academies — e.g. Charities?
Yes. Since ontology v2.0 the bodies responsible for schools are **legal entities** (`est:LegalEntity`), whatever their form: a charitable company, a company, a charitable incorporated organisation, a partnership, a sole trader, an unincorporated trust or a public body. A natural person can also be a proprietor or a sponsor.

A legal entity can record:

- its legal form (`est:LegalForm`)
- its charity status: registered, exempt or excepted (`est:CharityStatus`)
- its Companies House number and its own UKPRN
- its incorporation and dissolution dates
- its registered office.

So a charity that is the proprietor of an independent school is a legal entity with a proprietor responsibility for that school, and its charity status is recorded on the legal entity. Charity numbers are not yet modelled as an identifier.

---

### Do we record independent schools' accountability?
Yes. An independent school's proprietor is a legal entity or person holding a proprietor responsibility for it:

```
Establishment
  → hasResponsibility → EstablishmentResponsibility (type: Proprietor)
    → hasResponsibleParty → LegalEntity or Person
```

`esto:hasProprietor` names the present-day proprietors directly. A school can have more than one. The SHACL rules for each establishment type say where a proprietor applies; it is not used for maintained schools or academies.

---

### What types of groups are recorded and is the parent entity of a group a type of organisation? It appears that a group is a type of organisation as it has a Group Identifier and a UKPRN.
Since ontology v2.0, an `est:EstablishmentGroup` is a group of establishments that is **not** itself a legal entity. Only three kinds remain:

| OWL class | Plain name |
| --- | --- |
| `est:Federation` | Federation |
| `est:ChildrensCentreGroup` | Children's centre group |
| `est:ChildrensCentreCollaboration` | Children's centre collaboration |

Trusts are no longer groups. An academy trust, foundation trust or umbrella trust is a **legal entity** (`est:LegalEntity`, a subclass of `est:Organisation`) holding a dated **recognised role**. An academy trust also has dated classifications as a single-academy, multi-academy or secure single-academy trust, so a conversion is a change of classification on one organisation, not a new one. Academy sponsor is a role too.

The identifiers and addresses that made GIAS groups look like organisations - Companies House number, UKPRN, incorporation date, registered office - belong to the legal entity. GIAS group numbers (group UID and Group ID) are a GIAS and migration concern, held in the logical and physical models rather than the conceptual model.

---

### Is there always an Organisation that acts as the head of a Group?
Not always, and since ontology v2.0 the question mostly answers itself.

**Academy trusts** are no longer groups. A trust is a legal entity that runs its academies through establishment responsibilities. There is no group above it.

**Federations** have no head organisation. A federation is a group of maintained schools with a shared governing body. It has no local authority owner, and its schools stay maintained by their own local authorities.

**Children's centre groups** can have a lead centre. This is recorded as a dated `est:LeadCentreDesignation` on the lead centre's membership, because which centre leads can change while the membership continues. The group's local authority is recorded through `esto:hasLocalAuthorityForGroup`, which only children's centre groups and collaborations use.

Relationships between GIAS group records, such as a predecessor single-academy trust and a successor multi-academy trust, are no longer modelled: a conversion is a change of classification on one legal entity.

---

### What are examples of institutions funded by other government departments?

The taxonomy has a specific type for this: `est:InstitutionFundedByOtherGovernmentDepartment` (type code 56), grouped under `EstablishmentTypeGroupOtherTypes`.

Additionally, the "Other types" group includes:

| Type | Notes |
| --- | --- |
| Service children's education (`est:ServiceChildrensEducation`) | Schools funded by the Ministry of Defence or FCDO for the children of service personnel, both in England and overseas |
| Institution funded by other government department (type code 56) | Establishments funded by a government department other than DfE; the specific departments are not enumerated in the taxonomy |
| British schools overseas | English-medium schools outside the UK, not funded by DfE |
| Offshore schools | Schools in UK Crown dependencies or overseas territories |

Further Education colleges and universities/higher education institutions are also distinct type groups but are primarily funded through DfE/ESFA routes, not other government departments.

---

### What kind of Groups have a Companies House number? This implies the Group is actually an Organisation.
Since ontology v2.0 this is answered directly: a Companies House number belongs to a **legal entity** (`esto:hasCompaniesHouseRegistration` on `est:LegalEntity`), not to a group.

Academy trusts - single-academy, multi-academy and secure single-academy - are charitable companies limited by guarantee, so they have a Companies House number. Other legal entities that run, support, sponsor or own schools may be companies too, or may be charities, partnerships, individuals or public bodies without one.

The remaining establishment groups - federations and children's centre groups and collaborations - are not legal entities, so they have no Companies House number. The same `est:CompaniesHouseNumber` class is also used for online providers through their accreditation record.

This matches the enterprise data model's `LEGAL_ENTITY` concept: academy trusts and other responsible bodies map to it.
