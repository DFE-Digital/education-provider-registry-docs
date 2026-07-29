---
title: Governance Ontology — Co-operative Academies Trust / Co-op Academy Medlock example
---

[← Worked examples](../)

# Governance Ontology — Co-operative Academies Trust / Co-op Academy Medlock example

| | |
|---|---|
| **Trust** | The Co-operative Academies Trust — GIAS UID 2777, Companies House 07747126 |
| **Academy** | Co-op Academy Medlock, URN 150612 |
| **Trust type** | Multi-academy trust (MAT) |
| **Governance ontology namespace** | `https://dfe-digital.github.io/education-provider-registry-docs/models/governance/ontology/` |
| **Governance vocabulary namespace** | `https://dfe-digital.github.io/education-provider-registry-docs/models/governance/vocabulary/` |
| **Preferred prefixes** | `govo:` (properties) · `gov:` (classes and named individuals) · `epr:`/`epro:` (reused from the main EPR ontology) |
| **Governance ontology version** | 0.2 |
| **OWL documentation** | [Governance ontology reference (WIDOCO)](../../ontology/) |
| **Source** | [governance-ontology.ttl](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/governance/governance-ontology.ttl) |
| **Repository** | [DFE-Digital/education-provider-registry-docs](https://github.com/DFE-Digital/education-provider-registry-docs) |
| **Licence** | [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) |

---

**Evidence and anonymisation.** This page is in two parts. **Section 1** is the real-world governance structure as documented in a bounded, sourced internal investigation ("Governance Model With Worked MAT Example: Co-op Academy Medlock") - what the Trust itself publishes, independent of any ontology. **Section 2** maps that same structure onto `governance-ontology.ttl`. Neither section is itself GIAS or Companies House data, and the source investigation is not published in this repository.

Person names throughout are shown as initials, exactly as the source investigation anonymised them (e.g. `RG`, `TC`) - this example does not use, and has not gone back to, the Trust's full published names. Both sections show the same representative **subset** of people, not the full roster - 6 Academy Trust Members, 10 Trust Board people and 11 Academy Community Council Members are evidenced in the source - so that Section 1 and Section 2 stay directly comparable. Left out: 3 further Academy Trust Members (`GGM`, `KN`, `HT`), 8 further Trustees (`APM`, `MA`, `RW`, `GG-T`, `SB`, `CC`, `SFC`, `MW`) and 9 further Community Council Members.

---

## Section 1 — The real-world governance structure

This section is the structure as evidenced, before any ontology is applied.

### Sources published by the Trust

| Source | Publisher | What it evidences | Observed |
|---|---|---|---|
| [Our Members](https://www.coopacademies.co.uk/our-members) | Co-op Academies Trust | Six published Academy Trust Members, including the Co-op Group as a corporate Member and its representative | 27 July 2026 |
| [Trust Board](https://www.coopacademies.co.uk/trust-board) | Co-op Academies Trust | Ten published Trust Board people, their appointment route, and Chair/Vice-Chair roles | 27 July 2026 |
| [Co-op Academy Medlock: Academy Community Council](https://www.medlock.coopacademies.co.uk/governance) | Co-op Academy Medlock | Eleven published current Community Council Members, their categories, appointment routes and Chair role | 27 July 2026 |
| [Trust governance](https://www.coopacademies.co.uk/governance/) | Co-op Academies Trust | Academy Community Councils are committees of the Trust Board; Community Council Members take the place of governors in this Trust's structure | 27 July 2026 |

The Accounting Officer, Chief Financial Officer, Governance Professional and Company Secretary shown below are not named on these four pages - they come from separate secondary evidence (a historical GIAS/Companies House reconciliation, and the [Academy Trust Handbook 2025](https://www.gov.uk/government/publications/academy-trust-handbook/academy-trust-handbook-2025-effective-from-1-september-2025)), included here because they are real appointments against the same Academy Trust, not because the Trust's own governance pages name them.

### Structure

Adapted from the source investigation's own instance-level mapping, trimmed to a representative subset of people for readability - the same subset modelled in Section 2 below.

```mermaid
flowchart LR
    AT["Academy Trust / Legal Entity<br/>The Co-operative Academies Trust<br/>Company limited by guarantee"]

    AT -->|"governed through"| TB["Governance Body<br/>Trust Board"]
    AT -->|"operates"| E["Co-op Academy Medlock<br/>URN 150612"]

    AT --> AM["Academy Trust Memberships"]
    AM --> COOP["Co-op Group<br/>Corporate Academy Trust Member"]
    COOP --> DKW["DKW<br/>Corporate Member representative"]
    AM --> RG["RG<br/>Academy Trust Member<br/>Academy Trustee<br/>Chair of Trust Board"]
    AM --> PG["PG<br/>Independent Academy Trust Member"]

    TB -->|"has Academy Trustee"| RG
    TB -->|"has Academy Trustee"| TC["TC<br/>Academy Trustee<br/>Vice-Chair of Trust Board"]
    TB -->|"Trustees hold"| CAP["Legal capacities<br/>Charity Trustee + Company Director"]

    TB -->|"has committee"| ACC["Governance Body<br/>Academy Community Council"]
    ACC -->|"has governance scope over"| E
    ACC -->|"has Community Council Member"| HR["HR<br/>Sponsor CCM<br/>Chair of ACC"]
    ACC -->|"has Community Council Member"| JB["JB<br/>Ex-officio CCM<br/>Headteacher"]

    AT --> OA["Operational appointments"]
    OA --> AO["Accounting Officer<br/>typically paid employee"]
    OA --> CFO["Chief Financial Officer<br/>typically paid employee"]
    TB --> GP["Governance Professional<br/>SL"]
    AT --> CS["Company Secretary appointment<br/>SL<br/>separate from governance-professional appointment"]
```

The diagram represents the real-world Academy Trust, not registry records. GIAS UID `2777`, Companies House number `07747126` and URN `150612` are identifiers and evidence, not model entities in their own right. RG demonstrates two distinct relationships for one person - Academy Trust Member and Academy Trustee (Chair) - not one interchangeable role. `SL` demonstrates the same pattern for Governance Professional and Company Secretary.

---

## Section 2 — Modelled in the governance ontology

The same people, bodies and appointments from Section 1, expressed in Turtle using `governance-ontology.ttl` (`gov:`/`govo:`).

### Structure

```mermaid
flowchart LR
    AT["inst:coop-academies-trust<br/>(epr:AcademyTrust)<br/>The Co-operative Academies Trust"]
    MED["inst:medlock<br/>(epr:Academy)<br/>Co-op Academy Medlock"]
    TB["ginst:coop-trust-board<br/>(gov:TrustBoard)"]
    ACC["ginst:medlock-acc<br/>(gov:Committee)<br/>Academy Community Council"]

    AT -->|govo:hasGovernanceBody| TB
    ACC -->|govo:isCommitteeOf| TB
    MED -->|govo:hasGovernanceBody| ACC

    AT -->|govo:hasGovernanceAppointment| M1["RG — AcademyTrustMember"]
    AT -->|govo:hasGovernanceAppointment| M2["Co-op Group — AcademyTrustMember<br/>(corporate member — gap, see below)"]

    TB -->|govo:hasGovernanceAppointment| T1["RG — Trustee<br/>+ LegalCapacity: CompanyDirector<br/>+ RoleAssignment: Chair"]
    TB -->|govo:hasGovernanceAppointment| T2["TC — Trustee<br/>+ LegalCapacity: CompanyDirector<br/>+ RoleAssignment: ViceChair"]

    ACC -->|govo:hasGovernanceAppointment| C1["HR — LocalGoverningBodyMember<br/>+ RoleAssignment: Chair of ACC"]
    ACC -->|govo:hasGovernanceAppointment| C2["JB — LocalGoverningBodyMember<br/>(ex officio, headteacher)"]

    AT -->|govo:hasGovernanceAppointment| O1["Accounting Officer<br/>OperationalEmploymentRole"]
    AT -->|govo:hasGovernanceAppointment| O2["Chief Financial Officer<br/>OperationalEmploymentRole"]
    TB -->|govo:hasGovernanceAppointment| P1["SL — GovernanceProfessional<br/>ProfessionalSupportRole"]
    AT -->|govo:hasGovernanceAppointment| P2["SL — CompanySecretary<br/>ProfessionalSupportRole"]
```

### Namespace prefixes

All examples in this section use the following prefixes.

```
@prefix gov:   <https://dfe-digital.github.io/education-provider-registry-docs/models/governance/vocabulary/> .
@prefix govo:  <https://dfe-digital.github.io/education-provider-registry-docs/models/governance/ontology/> .
@prefix epr:   <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/> .
@prefix epro:  <https://dfe-digital.github.io/education-provider-registry-docs/ontology/> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix inst:  <https://dfe-digital.github.io/education-provider-registry-docs/establishment/> .
@prefix ginst: <https://dfe-digital.github.io/education-provider-registry-docs/models/governance/instance/> .
```

### Example 1 — Legal entity, academy and trust board identity

The Academy Trust is one legal entity carrying two registry identifiers (GIAS UID and Companies House number) - not two organisations. `epr:AcademyTrust` and `epr:Academy` are reused directly from the main EPR ontology (they are type stubs in `governance-ontology.ttl` - see the [ontology graph viewer](../../ontology/webvowl/)); `epro:hasGroupUniqueIdentifier` and `epro:hasGroupCompaniesHouseNumber` are reused, unmodified, from `education-provider-ontology.ttl`.

```
inst:coop-academies-trust
    a epr:AcademyTrust ;
    rdfs:label "The Co-operative Academies Trust"@en ;

    epro:hasGroupUniqueIdentifier [
        a epr:GroupUniqueIdentifier ;
        rdfs:label "2777"
    ] ;

    epro:hasGroupCompaniesHouseNumber [
        a epr:CompaniesHouseNumber ;
        rdfs:label "07747126"
    ] .

inst:medlock
    a epr:Academy ;
    rdfs:label "Co-op Academy Medlock"@en ;

    epro:hasEstablishmentIdentity [
        a epr:EstablishmentIdentity ;
        epro:identifiedByUrn [
            a epr:UniqueReferenceNumber ;
            rdfs:label "150612"
        ]
    ] .

ginst:coop-trust-board
    a gov:TrustBoard ;
    rdfs:label "Co-operative Academies Trust — Trust Board"@en .

inst:coop-academies-trust
    govo:hasGovernanceBody ginst:coop-trust-board .
```

### Example 2 — Academy Community Council as a committee of the Trust Board

The Trust's own published pages call Medlock's delegated local governance body an **Academy Community Council**, a committee of the Trust Board - not a separate legal entity, and not the same as the historic GIAS "Local Governing Body" label for the same academy. This needs two distinct relationships: the committee's delegation *from* the Trust Board, and its governance scope *over* the academy. The first did not have a property in v0.1 - `govo:isCommitteeOf` was added in v0.2 directly because of this example.

```
ginst:medlock-acc
    a gov:Committee ;
    rdfs:label "Co-op Academy Medlock — Academy Community Council"@en ;
    rdfs:comment "The Trust's own term for Medlock's delegated local governance body, distinct from the historic GIAS 'Local Governing Body' label the Trust's current published pages no longer use."@en ;
    govo:isCommitteeOf ginst:coop-trust-board .

inst:medlock
    govo:hasGovernanceBody ginst:medlock-acc .
```

### Example 3 — Academy Trust Membership

Members relate to the Academy Trust legal entity directly - they are not automatically Trustees or Trust Board members. `RG` (below) separately holds a Trustee appointment (Example 4): two distinct relationships for one person, not one interchangeable role. This is also why `govo:hasGovernanceAppointment`'s `rdfs:domain` was relaxed in v0.2 - a v0.1 reader would have wrongly inferred that a Member appointment implies its subject is a `gov:GovernanceBody`.

```
ginst:person-rg
    a gov:GovernancePerson ;
    rdfs:label "RG"@en .

ginst:appointment-rg-member
    a gov:GovernanceAppointment ;
    govo:appointmentOf ginst:person-rg ;
    govo:hasRoleType gov:AcademyTrustMember ;
    govo:hasAppointmentBasis gov:StatutoryGovernanceAppointment .

inst:coop-academies-trust
    govo:hasGovernanceAppointment ginst:appointment-rg-member .

ginst:person-pg
    a gov:GovernancePerson ;
    rdfs:label "PG"@en .

ginst:appointment-pg-member
    a gov:GovernanceAppointment ;
    govo:appointmentOf ginst:person-pg ;
    govo:hasRoleType gov:AcademyTrustMember ;
    govo:hasAppointmentBasis gov:StatutoryGovernanceAppointment ;
    rdfs:comment "Independent Academy Trust Member (the Trust's own published term)."@en .

inst:coop-academies-trust
    govo:hasGovernanceAppointment ginst:appointment-pg-member .

ginst:appointment-coopgroup-member
    a gov:GovernanceAppointment ;
    govo:hasRoleType gov:AcademyTrustMember ;
    govo:hasAppointmentBasis gov:StatutoryGovernanceAppointment ;
    rdfs:comment "Corporate Academy Trust Member: the Co-op Group, represented by DKW. govo:appointmentOf is deliberately omitted here - its range is gov:GovernancePerson (natural persons only), and this ontology has no class for a corporate member. A gap surfaced by this example, not yet resolved - see 'What this example found' below."@en .

inst:coop-academies-trust
    govo:hasGovernanceAppointment ginst:appointment-coopgroup-member .
```

*(3 further Academy Trust Members - `GGM`, `KN`, `HT` - are evidenced in the source and not shown here.)*

### Example 4 — Trustee appointments, legal capacity and Chair role assignment

Academy Trustees are simultaneously charity trustees and, as a matter of company law, company directors - `govo:hasLegalCapacity` exists specifically to express this without inventing a second appointment. Chair and Vice-Chair are responsibilities layered onto a Trustee appointment, not separate appointment types - `gov:RoleAssignment` with `govo:layeredOn` expresses that layering.

```
ginst:person-tc
    a gov:GovernancePerson ;
    rdfs:label "TC"@en .

ginst:appointment-rg-trustee
    a gov:GovernanceAppointment ;
    govo:appointmentOf ginst:person-rg ;
    govo:hasRoleType gov:Trustee ;
    govo:hasAppointingBody gov:AppointedByAcademyMembers ;
    govo:hasAppointmentBasis gov:StatutoryGovernanceAppointment ;
    govo:hasLegalCapacity gov:CompanyDirector ;
    rdfs:comment "Legal capacity shown as a candidate person-level correlation with a Companies House Director record, not a confirmed match - see the source investigation's reconciliation evidence."@en .

ginst:coop-trust-board
    govo:hasGovernanceAppointment ginst:appointment-rg-trustee .

ginst:roleassignment-rg-chair
    a gov:RoleAssignment ;
    govo:layeredOn ginst:appointment-rg-trustee ;
    govo:assignsRole gov:Chair ;
    rdfs:comment "RG is Chair of Trustees, and separately holds Academy Trust Membership (Example 3) - two distinct relationships for one person."@en .

ginst:appointment-tc-trustee
    a gov:GovernanceAppointment ;
    govo:appointmentOf ginst:person-tc ;
    govo:hasRoleType gov:Trustee ;
    govo:hasAppointingBody gov:AppointedByAcademyMembers ;
    govo:hasAppointmentBasis gov:StatutoryGovernanceAppointment ;
    govo:hasLegalCapacity gov:CompanyDirector .

ginst:coop-trust-board
    govo:hasGovernanceAppointment ginst:appointment-tc-trustee .

ginst:roleassignment-tc-vicechair
    a gov:RoleAssignment ;
    govo:layeredOn ginst:appointment-tc-trustee ;
    govo:assignsRole gov:ViceChair .
```

*(8 further Trustees - `APM`, `MA`, `RW`, `GG-T`, `SB`, `CC`, `SFC`, `MW` - are evidenced in the source and not shown here.)*

### Example 5 — Academy Community Council membership

Eleven Community Council Members are evidenced, across five appointing categories the Trust publishes (community, staff, sponsor, parent, ex-officio). No role type in the taxonomy is named specifically for a Community Council Member, so this example reuses `gov:LocalGoverningBodyMember` - the closest existing value - and maps the Trust's category labels onto the closest `AppointingBody` individuals. Both mappings are candidates, not direct evidence: the source gives category labels, not the underlying appointing mechanism.

```
ginst:person-hr
    a gov:GovernancePerson ;
    rdfs:label "HR"@en .

ginst:appointment-hr-ccm
    a gov:GovernanceAppointment ;
    govo:appointmentOf ginst:person-hr ;
    govo:hasRoleType gov:LocalGoverningBodyMember ;
    govo:hasAppointingBody gov:AppointedByFoundationOrTrust ;
    govo:hasAppointmentBasis gov:StatutoryGovernanceAppointment ;
    rdfs:comment "Sponsor Community Council Member (Trust's own category). AppointingBody mapped to gov:AppointedByFoundationOrTrust as the closest candidate interpretation of 'sponsor' - not asserted by the source itself."@en .

ginst:medlock-acc
    govo:hasGovernanceAppointment ginst:appointment-hr-ccm .

ginst:roleassignment-hr-chairacc
    a gov:RoleAssignment ;
    govo:layeredOn ginst:appointment-hr-ccm ;
    govo:assignsRole gov:Chair ;
    rdfs:comment "HR chairs the Academy Community Council."@en .

ginst:person-jb
    a gov:GovernancePerson ;
    rdfs:label "JB"@en .

ginst:appointment-jb-ccm
    a gov:GovernanceAppointment ;
    govo:appointmentOf ginst:person-jb ;
    govo:hasRoleType gov:LocalGoverningBodyMember ;
    govo:hasAppointingBody gov:ExOfficioAppointment ;
    govo:hasAppointmentBasis gov:StatutoryGovernanceAppointment ;
    rdfs:comment "Ex-officio Community Council Member and headteacher - the same real-world capacity gov:ExOfficioGovernor describes at maintained schools, applied here to the Trust's own committee."@en .

ginst:medlock-acc
    govo:hasGovernanceAppointment ginst:appointment-jb-ccm .
```

*(9 further Community Council Members - community, staff and parent categories - are evidenced in the source and not shown here.)*

### Example 6 — Operational and professional support appointments

Accounting Officer and Chief Financial Officer are paid operational roles held directly against the Academy Trust, not Trust Board appointments - `govo:hasAppointmentBasis gov:OperationalEmploymentRole` marks this. The source does not name these two post-holders. Governance Professional and Company Secretary are two **separate** appointments that happen to be held by the same person (`SL`) - a real data-quality point the source investigation makes explicitly, and exactly what having two `GovernanceAppointment` records for one `GovernancePerson` is for.

```
ginst:appointment-ao
    a gov:GovernanceAppointment ;
    govo:hasRoleType gov:AccountingOfficer ;
    govo:hasAppointmentBasis gov:OperationalEmploymentRole ;
    rdfs:comment "Accounting Officer. Not named in the source investigation - govo:appointmentOf is deliberately omitted rather than invented."@en .

inst:coop-academies-trust
    govo:hasGovernanceAppointment ginst:appointment-ao .

ginst:appointment-cfo
    a gov:GovernanceAppointment ;
    govo:hasRoleType gov:ChiefFinancialOfficer ;
    govo:hasAppointmentBasis gov:OperationalEmploymentRole ;
    rdfs:comment "Chief Financial Officer. Not named in the source investigation."@en .

inst:coop-academies-trust
    govo:hasGovernanceAppointment ginst:appointment-cfo .

ginst:person-sl
    a gov:GovernancePerson ;
    rdfs:label "SL"@en .

ginst:appointment-sl-governanceprofessional
    a gov:GovernanceAppointment ;
    govo:appointmentOf ginst:person-sl ;
    govo:hasRoleType gov:GovernanceProfessional ;
    govo:hasAppointmentBasis gov:ProfessionalSupportRole ;
    rdfs:comment "Governance Professional supporting the Trust Board."@en .

ginst:coop-trust-board
    govo:hasGovernanceAppointment ginst:appointment-sl-governanceprofessional .

ginst:appointment-sl-companysecretary
    a gov:GovernanceAppointment ;
    govo:appointmentOf ginst:person-sl ;
    govo:hasRoleType gov:CompanySecretary ;
    govo:hasAppointmentBasis gov:ProfessionalSupportRole ;
    rdfs:comment "Company Secretary - the Companies House legal-company office. A separate appointment from Governance Professional above, held by the same person; the two must not be merged into one appointment record."@en .

inst:coop-academies-trust
    govo:hasGovernanceAppointment ginst:appointment-sl-companysecretary .
```

---

## Concept coverage

| Real-world concept | Medlock evidence | Ontology mapping | Fit |
|---|---|---|---|
| Academy Trust (legal entity) | The Co-operative Academies Trust, UID 2777, Companies House 07747126 | `epr:AcademyTrust` | Direct - reused type stub, not redefined |
| Academy | Co-op Academy Medlock, URN 150612 | `epr:Academy` | Direct - reused type stub |
| Trust Board | The board accountable for the Trust | `gov:TrustBoard` | Direct |
| Academy Community Council | Committee of the Trust Board, governance scope over Medlock | `gov:Committee` + `govo:isCommitteeOf` + `govo:hasGovernanceBody` | Direct, once `govo:isCommitteeOf` was added (v0.2) |
| Academy Trust Membership | 6 Members, including a corporate member | `gov:GovernanceAppointment` (`govo:hasRoleType gov:AcademyTrustMember`) attached directly to `epr:AcademyTrust` | Direct, once `govo:hasGovernanceAppointment`'s domain was relaxed (v0.2) |
| Trustee Appointment | 9 Trustees, 1 Chair of Trustees | `govo:hasRoleType gov:Trustee`, `govo:hasAppointingBody gov:AppointedByAcademyMembers` | Direct |
| Legal Capacity (Director) | Trustees are also company directors | `govo:hasLegalCapacity gov:CompanyDirector` | Direct |
| Role Assignment (Chair / Vice-Chair) | Chair of Trustees, Vice-Chair of Trust Board, Chair of ACC | `gov:RoleAssignment` + `govo:layeredOn` + `govo:assignsRole` | Direct |
| Community Council Member | 11 CCMs across 5 appointing categories | `govo:hasRoleType gov:LocalGoverningBodyMember` | Candidate - no CCM-specific role type exists; reused the closest generic value |
| CCM appointing category | community / staff / sponsor / parent / ex-officio | `govo:hasAppointingBody` (`gov:ElectedByStaff`, `gov:ExOfficioAppointment`, `gov:AppointedByFoundationOrTrust`, `gov:ElectedByParents`, `gov:AppointedByGoverningBody`) | Candidate - source gives category labels, not the appointing mechanism |
| Accounting Officer / Chief Financial Officer | 1 + 1, paid employees | `govo:hasRoleType` + `govo:hasAppointmentBasis gov:OperationalEmploymentRole` | Direct |
| Governance Professional / Company Secretary | SL holds both, as distinct appointments | Two `gov:GovernanceAppointment` records, `govo:hasAppointmentBasis gov:ProfessionalSupportRole` | Direct |
| Corporate Academy Trust Member | Co-op Group, represented by DKW | Not modelled | Gap - `govo:appointmentOf` range is `gov:GovernancePerson` (natural persons only) |
| Constitution / Constitution Position / Vacancy | No evidence in the source | Not modelled | Not evidenced |
| Declaration of Interest / Confirmation / Training Record / Meeting / Attendance | No evidence in the source | Not modelled | Not evidenced |

---

## What this example found

Testing the governance ontology against this real, sourced investigation changed the ontology itself, not just this page:

- **`govo:isCommitteeOf` added.** v0.1 had no way to say a committee is delegated from a parent governance body - only `govo:hasGovernanceBody`, which expresses a *different* relationship (a committee's own governance scope over an academy). The Academy Community Council needed both.
- **`govo:hasGovernanceAppointment`'s domain relaxed.** v0.1 restricted it to `gov:GovernanceBody`. Academy Trust Members, the Accounting Officer and the Chief Financial Officer are appointments against the Academy Trust legal entity directly - modelling them as Trust Board appointments would have wrongly implied board membership.

One gap remains open, not yet resolved: **the Co-op Group's corporate Academy Trust Membership has no home.** `govo:appointmentOf` only accepts a `gov:GovernancePerson` (a natural person); this ontology has no class for an organisation holding a governance appointment. Example 3 shows the appointment with `govo:appointmentOf` deliberately omitted rather than force-fitting the Co-op Group as a person.

---

**See also:** [Governance vocabulary](../../vocabulary/) · [Governance taxonomy](../../taxonomy/) · [Governance ontology](../../ontology/) · [Governance ontology graph viewer](../../ontology/webvowl/)
