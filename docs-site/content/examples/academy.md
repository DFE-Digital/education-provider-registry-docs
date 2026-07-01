---
title: EPR Ontology — academy (SAT) example
---

[← Worked examples](../)

# EPR Ontology — academy (SAT) example

| | |
|---|---|
| **Establishment** | Abbey College, Ramsey, URN 137377, Cambridgeshire |
| **Type** | Academy converter (secondary, single-academy trust) |
| **Trust** | Abbey College, Ramsey (SAT) — Group ID TR00001, Companies House 07740516 |
| **Ontology namespace** | `https://dfe-digital.github.io/education-provider-registry-docs/ontology/` |
| **Vocabulary namespace** | `https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/` |
| **Preferred prefixes** | `epro:` (properties) · `epr:` (classes and named individuals) |
| **Version** | 1.4 |
| **OWL documentation** | [Ontology reference (WIDOCO)](/education-provider-registry-docs/ontology/) |
| **Source** | [education-provider-ontology.ttl](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/education-provider-ontology.ttl) |
| **Repository** | [DFE-Digital/education-provider-registry-docs](https://github.com/DFE-Digital/education-provider-registry-docs) |
| **Licence** | [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) |

---

**All personal names in this document are anonymised.** The establishment used in the examples (Abbey College, Ramsey, URN 137377) is a real school drawn from the public GIAS extract. The headteacher name has been replaced with a fictional placeholder. No real personal data appears anywhere on this page.

---

This example shows how an **academy converter** differs from a community school in the EPR ontology. The two key structural differences are:

1. **Accountability** — the establishment is accountable to an `epr:AcademyTrust` via `epro:accountableToAcademyTrust`, not to a local authority. The local authority is still present in the identity block (as the context for the LAESTAB number) but plays no accountability role.
2. **Group membership** — the establishment is also linked to the trust via `epro:hasGroupMembership`, which carries the join date. For a single-academy trust, both the accountability and the membership point to the same trust instance.

Abbey College, Ramsey is a non-selective secondary (11–18, with sixth form). It converted to academy status and formed its own SAT in August 2011.

---

## Structure of an academy record

```mermaid
graph LR
    E["inst:137377<br/>(epr:AcademyConverter)"]

    E -->|hasEstablishmentIdentity| ID["epr:EstablishmentIdentity"]
    E -->|hasEstablishmentLifecycle| LC["epr:EstablishmentLifecycle"]
    E -->|hasEstablishmentClassification| CL["epr:EstablishmentClassification"]
    E -->|hasAccountabilityRelationship| AC["epr:EstablishmentAccountability"]
    E -->|hasEducationAdmissionsAndProvision| PR["epr:EducationAdmissionsAndProvision"]
    E -->|hasGroupMembership| GM["epr:GroupMembership"]

    ID -->|identifiedByUrn| URN["epr:UniqueReferenceNumber<br/>137377"]
    ID -->|hasUkprn| UK["epr:UkProviderReferenceNumber<br/>10035138"]

    LC -->|classifiedByEstablishmentStatus| OS["epr:OpenStatus"]

    CL -->|hasEstablishmentType| AT["epr:AcademyConverter"]
    CL -->|hasEducationPhase| SP["epr:SecondaryPhase"]

    AC -->|accountableToAcademyTrust| SAT["inst:sat-2045<br/>(epr:SingleAcademyTrust)"]
    GM -->|memberOf| SAT

    PR -->|classifiedBySixthFormProvision| SF["epr:HasSixthForm"]
```

---

## Namespace prefixes

All examples use the following prefixes.

```
@prefix epr:    <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/> .
@prefix epro:   <https://dfe-digital.github.io/education-provider-registry-docs/ontology/> .
@prefix rdf:    <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:   <http://www.w3.org/2000/01/rdf-schema#> .
@prefix owl:    <http://www.w3.org/2002/07/owl#> .
@prefix xsd:    <http://www.w3.org/2001/XMLSchema#> .
@prefix inst:   <https://dfe-digital.github.io/education-provider-registry-docs/establishment/> .
```

---

## Example 1 — Identity and lifecycle

The identity block for an academy is identical in structure to a community school. The local authority context (`inst:la-873`) is present in the LAESTAB number because Cambridgeshire is the geographic local authority, but the LA plays no accountability role for this establishment.

```
inst:137377
    a epr:AcademyConverter ;

    epro:hasEstablishmentIdentity [
        a epr:EstablishmentIdentity ;

        epro:identifiedByUrn [
            a epr:UniqueReferenceNumber ;
            rdfs:label "137377"
        ] ;

        epro:hasUkprn [
            a epr:UkProviderReferenceNumber ;
            rdfs:label "10035138"
        ] ;

        epro:hasLocalAuthorityScopedEstablishmentNumber [
            a epr:LocalAuthorityScopedEstablishmentNumber ;
            epro:hasLocalAuthorityContext  inst:la-873 ;
            epro:hasEstablishmentNumberValue [
                a epr:EstablishmentNumber ;
                rdfs:label "4603"
            ] ;
            epro:hasIdentifierRole epr:CurrentIdentifierRole
        ]
    ] ;

    epro:hasEstablishmentLifecycle [
        a epr:EstablishmentLifecycle ;
        epro:classifiedByEstablishmentStatus epr:OpenStatus
    ] .

inst:la-873
    a epr:LocalAuthority ;
    rdfs:label "Cambridgeshire"@en ;
    rdfs:comment "LA code 873"@en .
```

---

## Example 2 — Classification and accountability

The establishment type is `epr:AcademyConverter`. The accountability relationship uses `epro:accountableToAcademyTrust` pointing to the single-academy trust (`inst:sat-2045`). There is no `accountableToLocalAuthority` property — academies are not LA-maintained.

```
inst:137377
    a epr:AcademyConverter ;

    epro:hasEstablishmentClassification [
        a epr:EstablishmentClassification ;
        epro:hasEstablishmentType  epr:AcademyConverter ;
        epro:hasEducationPhase     epr:SecondaryPhase
    ] ;

    epro:hasAccountabilityRelationship [
        a epr:EstablishmentAccountability ;
        epro:accountableToAcademyTrust inst:sat-2045
    ] .
```

---

## Example 3 — Location, contact and administrative geography

```
inst:137377
    a epr:AcademyConverter ;

    epro:hasEstablishmentLocationAndContact [
        a epr:EstablishmentLocationAndContact ;

        epro:hasMainAddress [
            a epr:MainAddress ;
            rdfs:label "Abbey Road, Ramsey, PE26 1DG"
        ] ;

        epro:hasWebsite [
            a epr:Website ;
            rdfs:label "https://www.abbey.college/"
        ] ;

        epro:hasTelephoneNumber [
            a epr:TelephoneNumber ;
            rdfs:label "01487812352"
        ] ;

        epro:hasHeadteacherOrPrincipal [
            a epr:HeadteacherOrPrincipal ;
            rdfs:label "Mr Andrew Clarke"@en
        ]
    ] ;

    epro:hasAdministrativeGeography [
        a epr:AdministrativeGeography ;

        epro:classifiedByGovernmentOfficeRegion [
            a epr:GovernmentOfficeRegion ;
            rdfs:label "East of England"@en
        ] ;

        epro:classifiedByParliamentaryConstituency [
            a epr:ParliamentaryConstituency ;
            rdfs:label "North West Cambridgeshire"@en ;
            rdfs:seeAlso <http://statistics.data.gov.uk/id/statistical-geography/E14001401>
        ]
    ] .
```

---

## Example 4 — Education, admissions and provision

Abbey College is non-selective, mixed, no boarding, and has a sixth form. The sixth form is represented by the `epr:HasSixthForm` named individual (contrasting with `epr:NoSixthForm` in the community school example).

```
inst:137377
    a epr:AcademyConverter ;

    epro:hasEducationAdmissionsAndProvision [
        a epr:EducationAdmissionsAndProvision ;

        epro:hasStatutoryAgeRange [
            a epr:StatutoryAgeRange ;
            rdfs:label "11 to 18"
        ] ;

        epro:classifiedByAdmissionsPolicy   epr:NonSelectiveAdmissions ;
        epro:classifiedByGenderOfEntry      epr:MixedGenderEntry ;
        epro:classifiedByBoardingProvision  epr:NoBoarders ;
        epro:classifiedBySixthFormProvision epr:HasSixthForm
    ] .
```

---

## Example 5 — Trust identity (single-academy trust)

The trust is a named individual (`inst:sat-2045`) of type `epr:SingleAcademyTrust`. It carries the group-level identifiers: the GIAS internal group UID, the Group ID (used in trust registers), the UKPRN assigned to the trust organisation, the Companies House number, and the incorporation date.

The establishment also has a `epr:GroupMembership` linking it to the trust, which records when the academy joined. For a SAT, this is the same trust as in the accountability relationship — both point to `inst:sat-2045`.

Trust (`inst:sat-2045`):

```
inst:sat-2045
    a epr:SingleAcademyTrust ;
    rdfs:label "Abbey College, Ramsey"@en ;

    epro:hasGroupUniqueIdentifier [
        a epr:GroupUniqueIdentifier ;
        rdfs:label "2045"
    ] ;

    epro:identifiedByGroupId [
        a epr:GroupId ;
        rdfs:label "TR00001"
    ] ;

    epro:hasGroupUkprn [
        a epr:GroupUkprn ;
        rdfs:label "10059272"
    ] ;

    epro:hasGroupCompaniesHouseNumber [
        a epr:CompaniesHouseNumber ;
        rdfs:label "07740516"
    ] ;

    epro:hasGroupIncorporatedOnDate [
        a epr:GroupIncorporatedOnDate ;
        rdfs:label "2011-08-15"^^xsd:date
    ] .
```

Group membership linking the academy to its trust:

```
inst:137377
    a epr:AcademyConverter ;

    epro:hasGroupMembership [
        a epr:GroupMembership ;
        epro:memberOf inst:sat-2045 ;
        epro:hasGroupMembershipDate [
            a epr:GroupMembershipDate ;
            rdfs:label "2011-09-01"^^xsd:date
        ]
    ] .
```

---

**See also:** [Community school example](../community-school/) · [SAT example (trust view)](../sat/) · [Multi-academy trust example](../mat/)
