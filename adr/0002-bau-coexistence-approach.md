# ADR 0002: BAU Coexistence Approach

## Status

Approved

## Date

2026-10-19

## Context

The technology plan  was produced before the domain-driven design process. Its earlier coexistence direction was to retain a single front door and introduce new functionality through journey-level routing between BAU and the transformed service, following a strangler approach. The legacy coexistence and rollout plan explores single-hostname routing and also records unresolved service-design and transition decisions.

The subsequent DDD work has changed the basis of the design. Public discovery, sector data-maintenance journeys and internal stewardship have different user needs, information access and identity requirements. Organising the user experience around the legacy/new implementation split does not adequately express those differences.

The current design provides anonymous public access, with no sign-in requirement. Education sector users authenticate through DfE Sign-in, while internal DfE users authenticate through Microsoft Entra ID.

Other government users are currently grouped with the sector cohort. This is a provisional grouping based on the current understanding of user needs.

## Decision

Replace the single-front-door strangler routing approach as the organising model for the user experience. Provide distinct public, sector and internal experiences, each designed around that cohort's needs and authentication requirements.

The experiences are:

- **Public:** an anonymous interface for finding, viewing and sharing published information. Public users are not required to sign in.
- **Sector:** a tailored interface for permitted data access and change-request journeys, authenticated through DfE Sign-in.
- **Internal:** a tailored staff interface for stewardship, review, approval and administration as appropriate to the user's responsibilities, authenticated through Microsoft Entra ID.

Other government users remain in the sector cohort for now. Revisit that grouping if research identifies needs, access requirements or workflows that justify a different experience or identity arrangement.


This decision supersedes the earlier technology-plan direction for a single user-facing entry point routing between legacy and new functionality. Incremental delivery and managed BAU coexistence can continue through explicit transition plans for each cohort and journey. Detailed hostnames, deployment arrangements, cutover dates and legacy retirement plans remain implementation and delivery decisions.

## Options Considered

| Option | Assessment | Decision |
| --- | --- | --- |
| Retain a single front door with strangler routing | Preserves a familiar entry point and supports gradual replacement. It makes the legacy/new routing split central to the experience and complicates the distinct journey, identity and session requirements. Not selected as the target user-experience model. | Rejected |
| Use one shared interface with conditional journeys for all cohorts | Could reuse more presentation code, but concentrates different navigation, authentication and task requirements in one interface. Not selected as the organising model. | Rejected |
| Provide separate public, sector and internal experiences | Aligns interfaces and identity boundaries with user needs while reusing shared domain capabilities. Selected. | Accepted |


## Consequences

### Positive

- Public users retain a focused anonymous experience.
- Sector and internal workflows can be designed around their respective tasks and responsibilities.
- Identity boundaries are explicit and use the providers shown in the current HLD.
- User experiences can evolve around cohort needs while sharing the DDD-defined business capabilities.

### Negative

- Multiple interfaces increase design, accessibility, testing, release and operational work.
- Users with more than one role may need clear signposting between experiences.
- Support and account-access processes must accommodate different identity arrangements.
- Further research may require changes to the placement of other government users.

### Mitigations

- Research and test journeys with each cohort, including other government users and people with multiple roles.
- Reuse design-system patterns and appropriate components while keeping cohort journeys tailored to their needs.
- Enforce authorisation at protected service boundaries and test permissions across identity and cohort boundaries.
- Define signposting, support ownership, communications, fallback and retirement arrangements for each cohort's transition.
