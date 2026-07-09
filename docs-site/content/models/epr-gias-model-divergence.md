# EPR Model Divergence from Legacy GIAS

Where the EPR target ontology deliberately diverges from the legacy GIAS 1.0 data model, and the reasons for each decision.

---

## 1. Organisation and Person superclasses introduced

**GIAS 1.0:** No common superclass for organisation-like things. `Establishment`, `EstablishmentGroup`, `LocalAuthority` and related concepts exist independently with no shared type.

**EPR target:** `epr:Organisation` is introduced as a common superclass. `epr:Establishment`, `epr:EstablishmentGroup` and `epr:LocalAuthority` are all subclasses of it. `epr:Person` is introduced as a superclass of `epr:GovernancePerson` to cover all natural persons with a role in the education system.

**Reason:** Enterprise Data Model alignment requires a common organisation concept. The absence of a shared superclass makes it impossible to write a query or constraint that applies to all organisation-like things without enumerating every type.

---

## 2. School Sponsor removed as an establishment group type

**GIAS 1.0:** `School sponsor` is GIAS group type 05. Sponsor body records are stored in the groups table, linked to establishments via the group-link mechanism. The front end presents it as `Academy sponsor`.

**EPR target:** `epr:SchoolSponsor` is removed as an OWL class. The SKOS taxonomy entry is retained and marked legacy. Sponsor relationships are expressed via `epro:sponsoredBy` (domain `epr:Establishment`, range `epr:Organisation`) directly on the establishment record.

**Reason:** GIAS stored sponsor bodies in the groups table as a legacy implementation choice. The business semantics are sponsor semantics throughout — the field is labelled "Academy sponsor", the flag says "Linked to a sponsor", and the permission is sponsor-specific. A sponsor is an organisation that establishments link to, not a type of group that establishments belong to.

---

## 3. Academy Sponsor removed as an OWL class

**GIAS 1.0:** `epr:AcademySponsor` was an OWL class. The property `epro:hasAcademySponsor` linked a trust to its sponsor.

**EPR target:** Both removed. The sponsoring body is typed as `epr:Organisation`, linked via `epro:sponsoredBy` on `epr:Establishment`.

**Reason:** A sponsor is something an organisation *does*, not something an organisation *is*. A university, charity, business or trust can sponsor an academy without being a distinct kind of organisation. The old property was also on `epr:AcademyTrust` rather than on the establishment, which did not match GIAS link semantics (the link is from establishment to sponsor).

---

## 4. Proprietor removed as an OWL class

**GIAS 1.0:** `epr:Proprietor` was an OWL class representing the person or body that owns or operates an independent school.

**EPR target:** Removed. The proprietor relationship is expressed via `epro:hasProprietor` (domain `epr:Establishment`, range: union of `epr:Organisation` and `epr:Person`).

**Reason:** A proprietor can be either a natural person (an individual operating as a sole trader) or an organisation (a company or charity). A single class could not be placed cleanly in either hierarchy. A direct property with a union range correctly covers both cases.

---

## 5. Academy type hierarchy flattened — 8 leaf types replaced by 5 types + route property

**GIAS 1.0:** 8 distinct academy establishment types, including separate types for converter and sponsor-led variants (e.g. type 28 Academy sponsor led, type 34 Academy special school sponsor led).

**EPR target:** 5 primary academy types plus an `epr:AcademyRoute` classification (Converter or SponsorLed) expressed via `epro:hasAcademyRoute`.

**Reason:** The route by which an academy was established is a property of how it came to exist, not of what it fundamentally is. The 8-type leaf structure duplicated type definitions and required further leaf types for any new route variant. Separating type from route makes the model extensible and reduces duplication.

---

## 6. SHACL sponsor constraint path updated

**GIAS legacy SHACL path:**
```
epro:hasAccountabilityRelationship epro:accountableToAcademyTrust epro:hasAcademySponsor
```

**EPR target path:**
```
epro:sponsoredBy
```

**Reason:** The sponsor is now directly on the establishment. The multi-hop path through the accountability chain and the trust is no longer needed.
