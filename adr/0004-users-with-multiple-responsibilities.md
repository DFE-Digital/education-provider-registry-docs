# ADR 0004: Users With Multiple Responsibilities

## Status

Open — decision pending. No approach for multiple responsibilities or authenticated gateway has been selected.

## Date

2026-10-23

## Context

[ADR 0002: BAU Coexistence Approach](0002-bau-coexistence-approach.md) describes separate public, sector and internal experiences. A person may have responsibilities that span these experiences, such as a DfE employee who is also a school governor.

We need to understand how these people enter the service, identify the capacity in which they are acting and access the appropriate journeys. We will develop likely scenarios alongside user research and use them to test candidate technical designs.

This ADR also considers an authenticated gateway that presents the services and responsibilities available to a user. 

## Decision Required

We need to decide:

- How people with multiple responsibilities enter the service and select or change the capacity in which they are acting.
- How identities and responsibilities are associated, reviewed and removed without unintentionally granting access across them.
- Whether an authenticated gateway should provide a single point of entry and review of the services and responsibilities available to a user.
- Which cohorts the approach should support initially and how it could extend to others.

## Decision

**Pending. We have not selected an identity-association approach, responsibility-selection design or authenticated gateway.**

## Scenarios To Assess

| Scenario | What the design must address |
| --- | --- |
| A DfE employee is also a school governor | Distinguish employment duties from the independent governor responsibility, and make the capacity in which the person is acting clear. |
| A DfE employee leaves the department but remains a governor | Remove access granted for employment duties without unintentionally retaining staff access or removing legitimate governor access. |
| A government user changes job or organisation | Review and remove permissions associated with the previous role, rather than assuming that successful sign-in establishes continuing entitlement. |
| A person holds responsibilities for several establishments | Present the permitted establishments and tasks clearly, and enforce the selected scope at protected service boundaries. |


## Authenticated Gateway Proposal

We will assess an authentication-specific portal through which a user signs in and can review the services and responsibilities available to them. The gateway would resolve their permitted entry points and provide clear routes into the relevant journeys.


