# ADR 0003: Authentication For Other Government Users

## Status

Open — decision pending. No authentication approach has been selected.

## Date

2026-10-23

## Context

[ADR 0002: BAU Coexistence Approach](0002-bau-coexistence-approach.md) describes separate public, sector and internal experiences. It provisionally places other government users in the sector cohort, where authentication uses DfE Sign-in. We have not established whether that identity arrangement is appropriate for these users.

For this ADR, **other government users** means people accessing the service on behalf of government organisations outside DfE.

Disabling an employee's Entra ID account might leave an independent DfE Sign-in account active. We need to establish the actual account dependencies and how access granted for employment duties is removed when employment or responsibilities end. We are recording this as a concern to resolve, not a verified defect in the current identity services.




## Decision Required

We need to decide how other government users authenticate to protected EPR journeys, including:

- Which users and organisations this cohort covers, and which journeys require sign-in rather than public anonymous access.
- Which identity providers and trust arrangements we will support.
- How accounts are provisioned, reviewed and disabled, and how existing sessions and service access are handled when responsibilities end.
- How authentication is separated from permission to perform particular tasks or access restricted information.


## Decision

**Pending. We have not selected an identity provider or federation arrangement for this cohort.**

