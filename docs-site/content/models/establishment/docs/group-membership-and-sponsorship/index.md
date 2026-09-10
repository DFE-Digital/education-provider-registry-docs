---
title: Group membership and sponsorship
---

[← Modelling notes](../)

# Group membership and sponsorship

How the establishment model records an establishment's membership of a trust, federation or children's-centre group, and how the sponsor relationship fits alongside it.

- **Worked example:** [Oasis Academy Coulsdon / Oasis Community Learning](../../worked-examples/oasis-community-learning/)
- **Ontology terms:** `est:GroupMembership`, `esto:hasMembership`, `esto:memberOf`, `esto:hasGroupMembershipDate`, `esto:hasGroupMembershipRole`, `est:GroupMembershipRoleType` (`est:Member`, `est:SponsoredAcademy`, `est:Sponsor`), `esto:sponsoredBy`
- **Added:** ontology v1.18, SHACL v0.9 (`est:GroupMembershipShape`)

---

## The problem in the source data

GIAS cannot record one organisation acting in two capacities against a single group. To say that an organisation is both the **accountable multi-academy trust** for its academies and their **approved sponsor**, GIAS holds two separate group records for the one legal entity:

| | "Multi-academy trust" record | "School sponsor" record |
|---|---|---|
| Group ID prefix | `TR` (e.g. `TR01553`) | `SP` (e.g. `SP00392`) |
| Companies House number | yes | — |
| UKPRN | yes | — |
| Incorporation date | yes | — |
| Registered address | yes | — |

Every academy then carries **two group-link rows** to that organisation, often with different joined dates — one into the trust, one as a sponsored academy. The GIAS links extract has **no role column**: the only thing distinguishing the two rows is which group type each points at.

The `SP` record is a thin shadow. It holds none of the legal-entity identifiers, and is frequently created years after the academies it links to.

## What the enterprise data model does

The DfE enterprise data model gets this right. It holds one `LEGAL_ENTITY` and one `ORGANISATION_GROUP`, and puts the capacity on the membership link itself: `ORGANISATION_GROUP_MEMBER.organisation_group_role_type_code` → `ORGANISATION_GROUP_ROLE_TYPE`, with values **Member**, **Sponsor** and **Sponsored Academy**.

## What the establishment model does

One `est:EstablishmentGroup` for the organisation. The `SP`-prefixed record is **not** given a second instance. Its group-link row becomes a second `est:GroupMembership` against the same group, carrying a role:

```
inst:oasis-coulsdon
    esto:hasMembership [
        a est:GroupMembership ;
        esto:memberOf inst:oasis-community-learning ;
        esto:hasGroupMembershipRole est:Member ;
        esto:hasGroupMembershipDate [ a est:GroupMembershipDate ; rdf:value "2008-09-01"^^xsd:date ]
    ] ;
    esto:hasMembership [
        a est:GroupMembership ;
        esto:memberOf inst:oasis-community-learning ;
        esto:hasGroupMembershipRole est:SponsoredAcademy ;
        esto:hasGroupMembershipDate [ a est:GroupMembershipDate ; rdf:value "2010-09-01"^^xsd:date ]
    ] ;
    esto:sponsoredBy inst:oasis-community-learning .
```

`esto:hasGroupMembershipRole` is optional (`0..1`). When it is absent, an ordinary membership (`est:Member`) is implied. `est:GroupMembershipShape` allows more than one `est:GroupMembership` between the same establishment and the same group — it does not cap them.

### `est:GroupMembershipRoleType` values

| Value | `rdfs:label` | EDM value | Use |
|---|---|---|---|
| `est:Member` | Member | Member | An ordinary member — an academy converter in its MAT, a school in a federation. The default. |
| `est:SponsoredAcademy` | Sponsored Academy | Sponsored Academy | The establishment is in the group as a sponsored academy under an Academies Act 2010 sponsor arrangement. Replaces the GIAS `SP` group-link row. |
| `est:Sponsor` | Sponsor | Sponsor | The member is the sponsoring organisation itself. Carried for parity with the enterprise data model; **not yet assertable** — it describes an *organisation's* membership of a group, and `esto:hasMembership` currently has `est:Establishment` as its subject (see [gap 2.G2](https://github.com/DFE-Digital/education-provider-registry-docs)). |

## `esto:hasGroupMembershipRole` versus `esto:sponsoredBy`

These are complementary, not duplicates:

- **`esto:hasGroupMembershipRole`** — how *this establishment* sits in *this group*. Scoped to one membership of one group.
- **`esto:sponsoredBy`** — *who* the DfE-approved sponsor organisation is. It is a direct establishment-to-organisation property, and the sponsor need not be a group at all: at [The Green School Trust](../../worked-examples/green-school-trust/) the sponsor is a diocese, which has no `est:EstablishmentGroup` instance.

An academy sponsored by its own trust carries both — `esto:sponsoredBy` naming the trust, and a `est:SponsoredAcademy`-role membership of it.

## Migration note

On load from GIAS:

- The `TR`-prefixed group record becomes the `est:EstablishmentGroup` instance, carrying the Companies House number, UKPRN, incorporation date and registered address.
- The `SP`-prefixed group record is **not** migrated as a group. Each of its group-link rows becomes a `est:GroupMembership` with `esto:hasGroupMembershipRole est:SponsoredAcademy` against the corresponding `TR` group, keeping its own joined date.
- The establishment also gets `esto:sponsoredBy` pointing at that same group instance.

---

**See also:** [Oasis Community Learning worked example](../../worked-examples/oasis-community-learning/) · [Manor High School worked example](../../worked-examples/manor-high/) (a clean single-link contrast) · [Establishment ontology](../../ontology/) · [Establishment vocabulary](../../vocabulary/)
