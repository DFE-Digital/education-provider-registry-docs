---
title: EPR Ontology — multi-academy trust example
---

[← Worked examples](../)

# EPR Ontology — multi-academy trust example

| | |
|---|---|
| **Trust** | Abbey Academies Trust — Group ID TR00261, Companies House 07318714 |
| **Trust type** | Multi-academy trust (MAT) |
| **Member used in examples** | Bourne Abbey Church of England Primary Academy, URN 136354, Lincolnshire |
| **Ontology namespace** | `https://dfe-digital.github.io/education-provider-registry-docs/ontology/` |
| **Vocabulary namespace** | `https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/` |
| **Preferred prefixes** | `epro:` (properties) · `epr:` (classes and named individuals) |
| **Version** | 1.4 |
| **OWL documentation** | [Ontology reference (WIDOCO)](/education-provider-registry-docs/ontology/) |
| **Source** | [education-provider-ontology.ttl](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/education-provider-ontology.ttl) |
| **Repository** | [DFE-Digital/education-provider-registry-docs](https://github.com/DFE-Digital/education-provider-registry-docs) |
| **Licence** | [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) |

---

**All personal names in this document are anonymised.** Establishment names and identifiers are drawn from the public GIAS extract. The headteacher name has been replaced with a fictional placeholder. No real personal data appears anywhere on this page.

---

This example shows how a **multi-academy trust** and its member academies are represented in the EPR ontology. The key structural features are:

1. **The trust is a named individual** — `epr:MultiAcademyTrust` carries group-level identifiers: Group ID, UKPRN, Companies House number, and incorporation date.
2. **Each member academy has an accountability relationship** to the MAT via `epro:accountableToAcademyTrust`.
3. **Each member academy has a group membership record** (`epr:GroupMembership`) with a join date, linked to the trust via `epro:memberOf`.
4. **Religious character** is an open-ended value set (SKOS concept from the vocabulary) rather than an OWL named individual. The three academies in this trust all have Church of England character.

Abbey Academies Trust was incorporated in July 2010 and has three member academies, all Church of England primary schools in the South Lincolnshire area. Bourne Abbey Church of England Primary Academy (URN 136354) is the founding member, joining at incorporation in December 2010.

---

## Structure of a MAT and its members

```mermaid
graph LR
    MAT["inst:mat-2044<br/>(epr:MultiAcademyTrust)<br/>Abbey Academies Trust"]

    A1["inst:136354<br/>(epr:AcademyConverter)<br/>Bourne Abbey CofE Primary"]
    A2["inst:140214<br/>(epr:AcademyConverter)<br/>Bourne Elsea Park CofE Primary"]
    A3["inst:146279<br/>(epr:AcademyConverter)<br/>Colsterworth CofE Primary"]

    A1 -->|accountableToAcademyTrust| MAT
    A2 -->|accountableToAcademyTrust| MAT
    A3 -->|accountableToAcademyTrust| MAT

    MAT -->|identifiedByGroupId| GID["epr:GroupId<br/>TR00261"]
    MAT -->|hasGroupCompaniesHouseNumber| CH["epr:CompaniesHouseNumber<br/>07318714"]
```

---

## Namespace prefixes

All examples use the following prefixes.

```turtle
@prefix epr:    <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/> .
@prefix epro:   <https://dfe-digital.github.io/education-provider-registry-docs/ontology/> .
@prefix rdf:    <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:   <http://www.w3.org/2000/01/rdf-schema#> .
@prefix owl:    <http://www.w3.org/2002/07/owl#> .
@prefix xsd:    <http://www.w3.org/2001/XMLSchema#> .
@prefix inst:   <https://dfe-digital.github.io/education-provider-registry-docs/establishment/> .
```

---

## Example 1 — Trust identity

The trust is a named individual (`inst:mat-2044`) of type `epr:MultiAcademyTrust`. It carries the group UID (the GIAS internal identifier), the Group ID (the trust register identifier), the UKPRN assigned to the trust organisation, the Companies House number, and the date the trust was incorporated.

```turtle
inst:mat-2044
    a epr:MultiAcademyTrust ;
    rdfs:label "Abbey Academies Trust"@en ;

    epro:hasGroupUniqueIdentifier [
        a epr:GroupUniqueIdentifier ;
        rdfs:label "2044"
    ] ;

    epro:identifiedByGroupId [
        a epr:GroupId ;
        rdfs:label "TR00261"
    ] ;

    epro:hasGroupUkprn [
        a epr:GroupUkprn ;
        rdfs:label "10058308"
    ] ;

    epro:hasGroupCompaniesHouseNumber [
        a epr:CompaniesHouseNumber ;
        rdfs:label "07318714"
    ] ;

    epro:hasGroupIncorporatedOnDate [
        a epr:GroupIncorporatedOnDate ;
        rdfs:label "2010-07-19"^^xsd:date
    ] .
```

---

## Example 2 — Member academy identity and lifecycle

Bourne Abbey Church of England Primary Academy was the founding member of the trust. Its identity structure is the same as any academy — URN, UKPRN, and the LAESTAB number scoped to Lincolnshire (LA code 925). The local authority appears here as geographic context only.

```turtle
inst:136354
    a epr:AcademyConverter ;

    epro:hasEstablishmentIdentity [
        a epr:EstablishmentIdentity ;

        epro:identifiedByUrn [
            a epr:UniqueReferenceNumber ;
            rdfs:label "136354"
        ] ;

        epro:hasUkprn [
            a epr:UkProviderReferenceNumber ;
            rdfs:label "10032221"
        ] ;

        epro:hasLocalAuthorityScopedEstablishmentNumber [
            a epr:LocalAuthorityScopedEstablishmentNumber ;
            epro:hasLocalAuthorityContext  inst:la-925 ;
            epro:hasEstablishmentNumberValue [
                a epr:EstablishmentNumber ;
                rdfs:label "3510"
            ] ;
            epro:hasIdentifierRole epr:CurrentIdentifierRole
        ]
    ] ;

    epro:hasEstablishmentLifecycle [
        a epr:EstablishmentLifecycle ;
        epro:classifiedByEstablishmentStatus epr:OpenStatus
    ] .

# Geographic local authority — not the accountable body
inst:la-925
    a epr:LocalAuthority ;
    rdfs:label "Lincolnshire"@en ;
    rdfs:comment "LA code 925"@en .
```

---

## Example 3 — Classification, accountability and religious character

The accountability relationship points to the MAT (`inst:mat-2044`). Religious character (`epr:ChurchOfEnglandCharacter`) is a SKOS concept from the open-ended vocabulary — it uses the same `epr:` namespace but is a `skos:Concept`, not an `owl:NamedIndividual`. This means it is represented differently from closed-enumeration values like `epr:PrimaryPhase`.

```turtle
inst:136354
    a epr:AcademyConverter ;

    epro:hasEstablishmentClassification [
        a epr:EstablishmentClassification ;
        epro:hasEstablishmentType          epr:AcademyConverter ;
        epro:hasEducationPhase             epr:PrimaryPhase ;
        epro:classifiedByReligiousCharacter epr:ChurchOfEnglandCharacter
    ] ;

    epro:hasAccountabilityRelationship [
        a epr:EstablishmentAccountability ;
        epro:accountableToAcademyTrust inst:mat-2044
    ] .
```

---

## Example 4 — Education, admissions and provision

Primary academy, mixed, non-selective, no boarding, no sixth form. The age range (2–11) reflects the school's early years provision.

```turtle
inst:136354
    a epr:AcademyConverter ;

    epro:hasEstablishmentLocationAndContact [
        a epr:EstablishmentLocationAndContact ;

        epro:hasMainAddress [
            a epr:MainAddress ;
            rdfs:label "Abbey Road, Bourne, PE10 9EP"
        ] ;

        epro:hasWebsite [
            a epr:Website ;
            rdfs:label "https://www.bourneabbeyprimary.co.uk/"
        ] ;

        epro:hasTelephoneNumber [
            a epr:TelephoneNumber ;
            rdfs:label "01778422163"
        ] ;

        epro:hasHeadteacherOrPrincipal [
            a epr:HeadteacherOrPrincipal ;
            rdfs:label "Mrs Catherine Harrison"@en    # anonymised
        ]
    ] ;

    epro:hasEducationAdmissionsAndProvision [
        a epr:EducationAdmissionsAndProvision ;

        epro:hasStatutoryAgeRange [
            a epr:StatutoryAgeRange ;
            rdfs:label "2 to 11"
        ] ;

        epro:classifiedByAdmissionsPolicy   epr:NonSelectiveAdmissions ;
        epro:classifiedByGenderOfEntry      epr:MixedGenderEntry ;
        epro:classifiedByBoardingProvision  epr:NoBoarders ;
        epro:classifiedBySixthFormProvision epr:NoSixthForm
    ] .
```

---

## Example 5 — Group membership

Each member academy has a `epr:GroupMembership` record carrying the date it joined the trust. A single establishment can be a member of more than one group simultaneously (for example, a federation and a trust), so membership is a separate class rather than a direct link.

The three members of Abbey Academies Trust joined at different times as the trust grew. The founding member (URN 136354) joined at trust formation in December 2010; the second academy joined in September 2014; the third in September 2018.

```turtle
# Founding member — joined at trust formation
inst:136354
    a epr:AcademyConverter ;
    epro:hasGroupMembership [
        a epr:GroupMembership ;
        epro:memberOf inst:mat-2044 ;
        epro:hasGroupMembershipDate [
            a epr:GroupMembershipDate ;
            rdfs:label "2010-12-01"^^xsd:date
        ]
    ] .

# Second member academy
inst:140214
    a epr:AcademyConverter ;
    epro:hasGroupMembership [
        a epr:GroupMembership ;
        epro:memberOf inst:mat-2044 ;
        epro:hasGroupMembershipDate [
            a epr:GroupMembershipDate ;
            rdfs:label "2014-09-01"^^xsd:date
        ]
    ] .

# Third member academy
inst:146279
    a epr:AcademyConverter ;
    epro:hasGroupMembership [
        a epr:GroupMembership ;
        epro:memberOf inst:mat-2044 ;
        epro:hasGroupMembershipDate [
            a epr:GroupMembershipDate ;
            rdfs:label "2018-09-01"^^xsd:date
        ]
    ] .
```

---

**See also:** [Community school example](../community-school/) · [Academy example](../academy/) · [Single-academy trust example](../sat/)
