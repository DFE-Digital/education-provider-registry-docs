---
title: Trusts, sponsors and group membership
---

[← Modelling notes](../)

# Trusts, sponsors and group membership

How the establishment model records the bodies that run, support, sponsor or act as proprietor of an establishment, and how that differs from membership of a federation or children's-centre group.

- **Worked examples:** [Oasis Academy Coulsdon / Oasis Community Learning](../../worked-examples/oasis-community-learning/) (sponsor is the academy's own trust) · [The Green School Trust](../../worked-examples/green-school-trust/) (sponsor is a diocese) · [Long Ditton](../../worked-examples/long-ditton/) (foundation trust) · [Cheltenham College](../../worked-examples/cheltenham-college/) (proprietor)
- **Ontology terms:** `est:LegalEntity`; `est:RecognisedRole`, `esto:holdsRole`, `esto:hasRoleType` (`est:AcademyTrust`, `est:FoundationTrust`, `est:UmbrellaTrust`, `est:AcademySponsor`); `est:AcademyTrustClassification`, `esto:hasAcademyTrustType` (`est:SingleAcademyTrust`, `est:MultiAcademyTrust`, `est:SecureSingleAcademyTrust`); `est:EstablishmentResponsibility`, `esto:hasResponsibility`, `esto:hasResponsibleParty`, `esto:hasResponsibilityType`; `esto:runByAcademyTrust`, `esto:sponsoredBy`, `esto:hasProprietor`; `est:GroupMembership`, `est:LeadCentreDesignation`
- **Current version:** ontology v2.0, SHACL v1.0

---

## The problem in the source data

GIAS holds trusts and sponsors as **group records**. To say that one organisation is both the multi-academy trust that runs its academies and their sponsor, GIAS holds two separate group records for the one legal entity:

| | "Multi-academy trust" record | "School sponsor" record |
|---|---|---|
| Group ID prefix | `TR` (e.g. `TR01553`) | `SP` (e.g. `SP00392`) |
| Companies House number | yes | — |
| UKPRN | yes | — |
| Incorporation date | yes | — |
| Registered address | yes | — |

Every academy then carries **two group-link rows**, often with different joined dates. The GIAS links extract has **no role column**; the only thing distinguishing the two rows is which group type each points at. GIAS also records a single-academy trust that becomes a multi-academy trust by closing one group record and opening another, so one company appears twice.

The data shows that the sponsor is usually, but not always, the academy's own trust:

- **82% of sponsor links** (7,531 of 9,206) point to a sponsor record named like the academy's own trust, and 644 of the 1,236 sponsor records link exactly the same, non-empty set of academies as a same-named trust record.
- **18% of sponsor links** are not matched to the academy's trust by name. Most name a different body: dioceses, colleges, universities, companies and three individuals. Diocese of London, for example, sponsors 28 academies spread across 13 different trusts.

## What the enterprise data model does

The DfE enterprise data model holds one `LEGAL_ENTITY` and one `ORGANISATION_GROUP`, and puts the capacity on the membership link: `ORGANISATION_GROUP_MEMBER.organisation_group_role_type_code` → `ORGANISATION_GROUP_ROLE_TYPE`, with values **Member**, **Sponsor** and **Sponsored Academy**.

This model agrees that one organisation needs one record, and that it is a legal entity. It does not use group roles for trusts or sponsorship:

- **An academy trust is not a group of schools.** It is a legal entity that runs academies. It can exist before its first academy joins, and it keeps its identity when it changes from a single-academy trust to a multi-academy trust.
- **A sponsor is often not the academy's trust.** A diocese sponsoring academies in 13 trusts is not a member of any of them, and a named individual cannot be a group member at all.
- **Roles on memberships cannot pair sponsors with academies.** If a group has several sponsors and several sponsored academies, roles on memberships do not say which sponsor sponsors which academy.

## What the establishment model does

- **A legal entity** is the company, charity, partnership or other body. It carries its own identifiers (Companies House number, UKPRN), charity status, incorporation date and registered office.
- **Recognised roles** say what a legal entity or person is, for a period: academy trust, foundation trust, umbrella trust or academy sponsor. A role does not depend on having any schools.
- **Academy trust classifications** say, for a period, whether an academy trust was a single-academy, multi-academy or secure single-academy trust. A conversion is a change of classification on the same legal entity.
- **Establishment responsibilities** say what a legal entity or person does for a particular establishment, for a period: run it as its academy trust, support it as its foundation trust, sponsor it, or act as its proprietor. When an academy changes trust, it keeps its identity: the change is a new responsibility.
- **`esto:runByAcademyTrust`, `esto:sponsoredBy` and `esto:hasProprietor`** name the present-day trust, sponsor and proprietors. A school can have more than one proprietor.
- **Group membership** is only for federations and children's-centre groups and collaborations, which are not legal entities. Lead centre is a dated designation on a children's-centre group membership.

```
inst:oasis-community-learning
    a est:LegalEntity ;
    esto:holdsRole [ a est:RecognisedRole ; esto:hasRoleType est:AcademyTrust ] ;
    esto:holdsRole [ a est:RecognisedRole ; esto:hasRoleType est:AcademySponsor ] ;
    esto:hasAcademyTrustClassification [
        a est:AcademyTrustClassification ;
        esto:hasAcademyTrustType est:MultiAcademyTrust
    ] .

inst:oasis-coulsdon
    esto:hasResponsibility [
        a est:EstablishmentResponsibility ;
        esto:hasResponsibilityType est:AcademyTrustResponsibility ;
        esto:hasResponsibleParty inst:oasis-community-learning ;
        esto:hasStartDate [ a est:PeriodStartDate ; rdf:value "2008-09-01"^^xsd:date ]
    ] ;
    esto:hasResponsibility [
        a est:EstablishmentResponsibility ;
        esto:hasResponsibilityType est:SponsorResponsibility ;
        esto:hasResponsibleParty inst:oasis-community-learning ;
        esto:hasStartDate [ a est:PeriodStartDate ; rdf:value "2010-09-01"^^xsd:date ]
    ] ;
    esto:runByAcademyTrust inst:oasis-community-learning ;
    esto:sponsoredBy inst:oasis-community-learning .
```

The same shape records a sponsor that is not the academy's trust: the sponsor responsibility simply names a different legal entity or person.

### Rules enforced in SHACL (v1.0)

| Rule | Shape | Severity |
|---|---|---|
| Only academies and free schools can be run by an academy trust or sponsored; only foundation and foundation special schools can be supported by a foundation trust | `est:EstablishmentResponsibilitiesShape` | Violation |
| A responsibility has exactly one responsible party and one type, and at most one start date and one end date | `est:EstablishmentResponsibilityShape`, `est:PeriodShape` | Violation |
| A person can only sponsor an establishment or be its proprietor | `est:EstablishmentResponsibilityShape` | Violation |
| A person can hold only the academy sponsor role | `est:PersonRoleShape` | Violation |
| Only a legal entity holding the academy trust role can have an academy trust classification | `est:ClassifiedAcademyTrustShape` | Violation |
| At most one present-day sponsor (`esto:sponsoredBy`), which is a legal entity or a person | `est:EstablishmentSponsorshipShape` | Violation |
| At most one present-day academy trust (`esto:runByAcademyTrust`), which is a legal entity | `est:RunByAcademyTrustShape` | Violation |
| The legal entity that runs an academy should hold the academy trust role | `est:RunByAcademyTrustShape` | Warning |
| Only a children's-centre group membership can carry a lead centre designation | `est:LeadCentreMembershipShape` | Violation |
| An academy on the sponsor-led route should record its sponsor | `est:SponsorLedAcademySponsorShape` | Warning |

That an end date is not before its start date cannot be expressed in SHACL Core; migration and application logic enforce it.

## History

- **v1.18** recorded sponsorship as a second group membership with the role `est:SponsoredAcademy`.
- **v1.19** replaced that with a separate `est:Sponsorship` record, but still treated academy trusts as a kind of establishment group.
- **v2.0** follows what the physical model slice learned from real GIAS data. Trusts and sponsors are legal entities holding roles, sponsorship is one kind of establishment responsibility, and academy trusts are no longer groups. The superseded terms were deleted from the ontology, vocabulary and taxonomy.

## Migration note

On load from GIAS, `TR` and `SP` group records and their links are resolved to legal entities, roles, classifications and responsibilities. GIAS group numbers (group UID and Group ID) are kept against the role or organisation group they identify. That is a GIAS and migration concern, held in the logical and physical models rather than in this conceptual model. A name match alone is not enough to merge two records into one legal entity; weaker matches go to review.

---

**See also:** [Oasis Community Learning worked example](../../worked-examples/oasis-community-learning/) · [Medlock worked example](../../worked-examples/medlock-mat/) · [Manor High School worked example](../../worked-examples/manor-high/) (a clean single-link contrast) · [Establishment ontology](../../ontology/) · [Establishment vocabulary](../../vocabulary/)
