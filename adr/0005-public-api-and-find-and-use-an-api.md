# ADR 0005: Public API And Find And Use An API

## Status

Open

## Date

2026-11-11

## Context

The public API serves published data to third parties. 

Two things are still open: where consumers call the API, and whether they need a key.

## Decision Required

We need to decide:

- Whether consumers call our own Front Door, or FaUAPI's gateway.
- Whether consumers need no key, our own key, or a FaUAPI key.

## Decision

**Pending. We have not selected an option.**

## Options

| # | Option | Precedent | Main advantage | Main cost |
| --- | --- | --- | --- | --- |
| 1 | Our Front Door, no key | Publish teacher training | Nothing to build, and no dependency on FaUAPI | We don't know who our consumers are. Limits are by IP address only. |
| 2 | Our Front Door, our own keys | Register early career teachers, Register trainee teachers, Teaching Vacancies | Proven. We know our consumers, with no dependency on FaUAPI. | We build key issuing, sign-up, limits and usage figures |
| 3 | Our Front Door, FaUAPI keys checked by a hook in FaUAPI | Nobody we found | FaUAPI handles sign-up and keys, without being in the request path | The hook has to be created in FaUAPI. We still build limits and usage figures. |
| 4 | FaUAPI gateway, FaUAPI keys | Document capture, Get an Identifier | FaUAPI checks keys, applies limits and records usage | If FaUAPI is down, our API is down. Our API must refuse calls that don't come through FaUAPI. |
| 5 | FaUAPI gateway, no key | Explore education statistics | The easiest for consumers. No keys for anyone to manage. | If FaUAPI is down, our API is down. Our API must refuse calls that don't come through FaUAPI. We don't know who our consumers are. |

## Notes :

**Our Front Door.** We self-host the API on Teacher Services Cloud, behind our own Azure Front Door, as we do the website. Consumers call our own hostname. Our Front Door applies the WAF and rate limit, then passes the call through the shared Teacher Services Cloud ingress to our API. FaUAPI only lists the API in its catalogue.

**FaUAPI gateway.** The API still runs on Teacher Services Cloud, but consumers call `api.education.gov.uk`. FaUAPI's gateway routes the call through the shared ingress to our API. Our Front Door isn't used for the API.


