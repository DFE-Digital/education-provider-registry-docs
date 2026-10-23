# ADR 0003: Authentication For Other Government Users

## Status

Open — decision pending. No authentication approach has been selected.

## Date

2026-10-23

## Context

[ADR 0002: BAU Coexistence Approach](0002-bau-coexistence-approach.md) describes separate public, sector and internal experiences. It provisionally places other government users in the sector cohort, where authentication uses DfE Sign-in. We have not established whether that identity arrangement is appropriate for these users.

For this ADR, **other government users** means people accessing the service on behalf of government organisations outside DfE. 

Disabling an employee's Entra ID account might leave an independent DfE Sign-in account active. We need to establish the actual account dependencies and how access granted for employment duties is removed when employment or responsibilities end. We are recording this as a concern to resolve, not a verified defect in the current identity services.

We also need to consider people with multiple responsibilities and an authenticated gateway that presents the services available to them. This is a related design question that includes DfE employees, beyond the other government users defined above.


## Decision Required

We need to decide how other government users authenticate to protected EPR journeys, including:

- Which users and organisations this cohort covers, and which journeys require sign-in rather than public anonymous access.
- Which identity providers and trust arrangements we will support.
- How accounts are provisioned, reviewed and disabled, and how existing sessions and service access are handled when responsibilities end.
- How authentication is separated from permission to perform particular tasks or access restricted information.
- How people with multiple responsibilities enter the service, understand which capacity they are acting in and access the appropriate journeys.
- Whether an authenticated gateway should provide a single point of entry and review of the services and responsibilities available to a user.


## Decision

**Pending. We have not selected an identity provider, federation arrangement or gateway design for this cohort.**

The multiple-responsibility approach and gateway proposal below also remain open for assessment.

## Users With Multiple Responsibilities

We will develop likely scenarios alongside user research and use them to test candidate technical designs. An initial set is:

| Scenario | What the design must address |
| --- | --- |
| A DfE employee is also a school governor | Distinguish employment duties from the independent governor responsibility, and make the capacity in which the person is acting clear. |
| A DfE employee leaves the department but remains a governor | Remove access granted for employment duties without unintentionally retaining staff access or removing legitimate governor access. |
| A government user changes job or organisation | Review and remove permissions associated with the previous role, rather than assuming that successful sign-in establishes continuing entitlement. |
| A person holds responsibilities for several establishments | Present the permitted establishments and tasks clearly, and enforce the selected scope at protected service boundaries. |

We need to assess identity association, account lifecycle, responsibility selection and audit records for these scenarios. We must not assume that matching email addresses is sufficient to associate accounts safely, or that users need a single account for every capacity.

## Authenticated Gateway Proposal

We will assess an authentication-specific portal through which a user signs in and can review the services and responsibilities available to them. The gateway would resolve their permitted entry points and provide clear routes into the relevant journeys.

The initial focus would be **DfE employees**. We need to test whether this approach is suitable for sector users; extending it to other cohorts would be a future option, not an agreed requirement.

The assessment must establish how the gateway obtains current entitlements, handles users with several responsibilities and responds when access is removed. Each protected service must continue to enforce its own authorisation; presentation of a link in the gateway is not sufficient permission to use that service. The gateway proposal does not itself decide which identity providers we trust.

