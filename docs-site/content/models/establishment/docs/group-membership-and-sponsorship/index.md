---
title: Group membership and sponsorship
---

[← Modelling notes](../)

# Group membership and sponsorship

How the establishment model records an establishment's membership of a trust, federation or children's-centre group, and how sponsorship is recorded separately from it.

- **Worked examples:** [Oasis Academy Coulsdon / Oasis Community Learning](../../worked-examples/oasis-community-learning/) (sponsor is the academy's own trust) · [The Green School Trust](../../worked-examples/green-school-trust/) (sponsor is a diocese)
- **Ontology terms:** `est:GroupMembership`, `esto:hasMembership`, `esto:memberOf`, `esto:hasGroupMembershipDate`, `esto:hasGroupMembershipRole` (`est:Member`); `est:Sponsorship`, `esto:hasSponsorship`, `esto:hasSponsor`, `esto:hasSponsorshipStartDate`, `esto:hasSponsorshipEndDate`, `esto:sponsoredBy`
- **Current version:** ontology v1.19, SHACL v0.10 (`est:GroupMembershipShape`, `est:EstablishmentSponsorshipShape`, `est:SponsorshipShape`, `est:SponsorPartyShape`, `est:SponsorLedAcademySponsorShape`)

---

## The problem in the source data

GIAS cannot record one organisation acting in two capacities against a single group. To say that an organisation is both the **accountable multi-academy trust** for its academies and their **sponsor**, GIAS holds two separate group records for the one legal entity:

| | "Multi-academy trust" record | "School sponsor" record |
|---|---|---|
| Group ID prefix | `TR` (e.g. `TR01553`) | `SP` (e.g. `SP00392`) |
| Companies House number | yes | — |
| UKPRN | yes | — |
| Incorporation date | yes | — |
| Registered address | yes | — |

Every academy then carries **two group-link rows**, often with different joined dates: one into the trust, one to the sponsor record. The GIAS links extract has **no role column**; the only thing distinguishing the two rows is which group type each points at.

The data shows that the sponsor record is usually, but not always, the trust itself:

- **82% of sponsor links** (7,531 of 9,206) point to a sponsor record named like the academy's own trust, and 827 of the 1,236 sponsor records link exactly the same academies as a same-named trust record.
- **18% of sponsor links** name a different body: dioceses, colleges, universities, companies and about ten named individuals. Diocese of London, for example, sponsors 28 academies spread across 13 different trusts.

## What the enterprise data model does

The DfE enterprise data model holds one `LEGAL_ENTITY` and one `ORGANISATION_GROUP`, and puts the capacity on the membership link: `ORGANISATION_GROUP_MEMBER.organisation_group_role_type_code` → `ORGANISATION_GROUP_ROLE_TYPE`, with values **Member**, **Sponsor** and **Sponsored Academy**.

This model agrees that one organisation needs one record. It does not use group roles for sponsorship, for two reasons:

- **A sponsor is often not the academy's group.** A diocese sponsoring academies in 13 trusts is not a member of any of them, and a named individual cannot be a group member at all.
- **Roles cannot pair sponsors with academies.** If a group has several sponsors and several sponsored academies, roles on memberships do not say which sponsor sponsors which academy.

## What the establishment model does

- **Group membership** records only membership: one `est:GroupMembership` per establishment per group, with `est:Member` as the only role.
- **Sponsorship** is its own dated record, `est:Sponsorship`, naming exactly one sponsor through `esto:hasSponsor`. The sponsor can be the academy's own trust, another organisation, or a person.
- **`esto:sponsoredBy`** is a current-value shortcut to the sponsor of the current sponsorship (the one with no end date). Where both are recorded they must agree.

```
inst:oasis-coulsdon
    esto:hasMembership [
        a est:GroupMembership ;
        esto:memberOf inst:oasis-community-learning ;
        esto:hasGroupMembershipRole est:Member ;
        esto:hasGroupMembershipDate [ a est:GroupMembershipDate ; rdf:value "2008-09-01"^^xsd:date ]
    ] ;
    esto:hasSponsorship [
        a est:Sponsorship ;
        esto:hasSponsor inst:oasis-community-learning ;
        esto:hasSponsorshipStartDate [ a est:SponsorshipStartDate ; rdf:value "2010-09-01"^^xsd:date ]
    ] ;
    esto:sponsoredBy inst:oasis-community-learning .
```

The same shape records a sponsor that is not the academy's trust: the only difference is the `esto:hasSponsor` value.

### Rules enforced in SHACL (v0.10)

| Rule | Shape | Severity |
|---|---|---|
| Only academies and free schools (including UTCs and studio schools) can have a sponsor | `est:EstablishmentSponsorshipShape` | Violation |
| At most one current sponsor (`esto:sponsoredBy`) | `est:EstablishmentSponsorshipShape` | Violation |
| A sponsor is an organisation or a person, never an establishment, a federation, or a children's centre group or collaboration. Academy trusts are allowed. | `est:SponsorPartyShape` | Violation |
| A sponsorship has exactly one sponsor, and at most one start date and one end date, each an `xsd:date` | `est:SponsorshipShape` | Violation |
| A group membership's role, if recorded, is `est:Member` | `est:GroupMembershipShape` | Violation |
| An academy on the sponsor-led route should record its sponsor | `est:SponsorLedAcademySponsorShape` | Warning |

That a sponsorship's end date is not before its start date cannot be expressed in SHACL Core; migration and application logic enforce it.

## History

Ontology v1.18 recorded sponsorship as a second group membership with the role `est:SponsoredAcademy`, alongside `esto:sponsoredBy`. That stated the same fact twice with nothing keeping the two in step, never named the sponsor, and could not represent a sponsor other than the academy's trust. The third role, `est:Sponsor`, could never be asserted correctly, because a membership's subject is always an establishment. Both were removed from the ontology in v1.19 and survive only as retired vocabulary entries. v1.19 also widened the range of `esto:sponsoredBy` to include `est:Person`.

## Migration note

On load from GIAS:

- The `TR`-prefixed group record becomes the `est:EstablishmentGroup` instance, carrying the Companies House number, UKPRN, incorporation date and registered address.
- The `SP`-prefixed group record is **not** migrated as a group. Its sponsor is resolved to the trust's instance where it is the same organisation, and otherwise to its own organisation or person.
- Each `SP` group-link row becomes an `est:Sponsorship` of the academy, naming that sponsor, with the link's joined date as its start date.
- The establishment also gets `esto:sponsoredBy`, pointing at the sponsor of its current sponsorship.

---

**See also:** [Oasis Community Learning worked example](../../worked-examples/oasis-community-learning/) · [Medlock worked example](../../worked-examples/medlock-mat/) · [Manor High School worked example](../../worked-examples/manor-high/) (a clean single-link contrast) · [Establishment ontology](../../ontology/) · [Establishment vocabulary](../../vocabulary/)
