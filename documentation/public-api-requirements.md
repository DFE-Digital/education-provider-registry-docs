# Read API Public requirements



## 1. Purpose

These are the requirements the public API has to meet. They say what the API must do and why. They don't say how. The API specification comes later, written by the development team against these requirements.

So this document doesn't decide resource names, URLs, payload shapes, header names or paging mechanisms. Where a requirement seems to point at one design, it's there to make the requirement testable, not to choose the design.

### What's in scope

- Read API Public, as shown in the [container diagram](../../../../education-provider-registry-docs/documentation/service/container-diagram.md). It reads the published projection, the same data the public website shows.
- How the API is managed, documented, supported and changed over time.

### What's not in scope

- Read API Internal, which serves DfE systems with data that isn't published. It needs its own requirements.
- The frontend backend API.
- Any way to create or change data. The public API is read-only.
- The API specification itself.

### Who uses it

The main users are system actors and the people who build and run them. See the [personas](../../use-cases/personas.md):

- `PER-013` automated data consumer, such as a supplier's MIS or a local authority system keeping a copy in step.
- `PER-008` data engineer, building pipelines and data products.
- `PER-005` local authority data analyst, reconciling GIAS with local systems.

Today about 30 systems copy GIAS data. Most download the 60 MB daily CSV, keep about 20 of 107 fields, and work out what changed themselves. The API should make that easier, not just move the same problem behind an endpoint.

## 2. How to read this

Each requirement has an identifier, a statement, a reason and a priority.

| Priority | Meaning |
| --- | --- |
| Must | Needed for the first release that third parties can use. |
| Should | Important. Leave it out only with a recorded reason. |
| Could | Worth having if it's cheap or research shows a strong need. |
| Candidate | Needs a scope decision or user research before we commit. |

**Must** in a statement is part of the requirement, whatever its priority. A Should requirement still says "must" because, once accepted, it has to be met in full.

Targets marked **proposed** are starting points. The business analyst should confirm them through user research and with the service owner.

## 3. Find and Use an API

DfE policy says new APIs must be hosted on FaUAPI unless an exception is agreed. Two DfE teams turned the gateway down in the past, because consumers had to manage two credentials and access was decided by a team that didn't know the users. These requirements are written to avoid both problems.

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| FAU01 | The API must be hosted behind the FaUAPI gateway, not only listed in the catalogue. | DfE policy for new APIs. It gives us subscriptions, analytics and a single front door. | Must |
| FAU02 | The API must have an entry in the FaUAPI catalogue with a description, the data it offers, its licence, its status, and contact and support details. | This is how consumers find it and decide whether to use it. | Must |
| FAU03 | The catalogue entry must be published from the API's OpenAPI document, automatically, whenever that document changes. | Keeps the catalogue and the API in step. Teaching Vacancies and Register trainee teachers already do this. | Must |
| FAU04 | Consumers must need only one credential to call the API, issued through FaUAPI. | Two credentials is the main reason other DfE teams rejected the gateway. | Must |
| FAU05 | The back end must accept traffic only from FaUAPI. There must be no other public route to it. | Rate limits, analytics and access control only work if every call goes through the gateway. | Must |
| FAU06 | The GIAS team must be able to see who has subscribed and contact them. | We need to tell consumers about changes, incidents and deprecations. | Must |
| FAU07 | Requests for access to published data should be approved automatically, without a manual check by another team. | The data is already public. A slow, manual approval puts people off and was a past complaint. | Should |
| FAU08 | Consumers must be able to try the API in a non-production FaUAPI environment before using production. | Lets them build and test safely. The FaUAPI team has said they can provide a sandbox. | Must |
| FAU09 | The API must offer a health check that FaUAPI and our own monitoring can call. | FaUAPI monitors the availability of hosted APIs. | Must |
| FAU10 | The GIAS team must be able to get usage analytics from FaUAPI by consumer, operation and version. | We need evidence to plan capacity, prioritise work and retire old versions. | Must |
| FAU11 | The catalogue entry must explain how this API differs from the Academies API, and which one to use for what. | The Academies API is already listed and serves GIAS-derived data. Consumers will be confused otherwise. | Should |

## 4. Versioning and change

Consumers carry the cost of every breaking change. The [personas](../../use-cases/personas.md) say this clearly. So change has to be predictable and announced well in advance.

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| VER01 | Every request must say which major version of the API it wants. There must be no unversioned access. | A consumer should never be moved to a new version without choosing to. | Must |
| VER02 | We must publish a definition of a breaking change, and apply it to every release. | Consumers and developers need the same rules to judge whether a change is safe. | Must |
| VER03 | A breaking change must only be released as a new major version. | Protects existing integrations. | Must |
| VER04 | Non-breaking changes, such as a new optional field or a new operation, must be released within the current major version. Consumers must not need to change their requests to keep working. | Avoids version sprawl for changes that can't break anyone. | Must |
| VER05 | New values in a code list, such as a new establishment type, must count as non-breaking. They must be announced in advance, and the documentation must tell consumers to expect them. | GIAS adds codes regularly. Treating each as breaking would mean constant new versions. Consumers still need warning. | Must |
| VER06 | When a new major version is released, the previous one must keep running for a published notice period. Proposed: at least 6 months during beta and at least 12 months once live. | Consumers need time to plan, fund and test the move. | Must |
| VER07 | A deprecated version must say so in its responses, in a way a machine can detect, including the date it will stop working. | Automated consumers often aren't watched by a person. | Must |
| VER08 | We must tell subscribers directly about deprecations and breaking changes, as well as publishing them. | A notice on a web page alone isn't enough. | Must |
| VER09 | We must publish a changelog listing every change, with its date and whether it's breaking. | Consumers need a single place to see what changed. | Must |
| VER10 | The API's beta status must be clear in the catalogue, the documentation and the responses. | Consumers should know what they're relying on. | Must |
| VER11 | Moving from the beta web address to the live one must come with notice and a period where both work. | Beta uses its own web address. Integrations built in beta must not break when we go live. | Must |
| VER12 | Every release must have a semantic version number: major, minor and patch. Major is for breaking changes, minor for non-breaking additions, and patch for fixes that don't change the contract. The OpenAPI document and the changelog must use the same number. | One numbering scheme, used everywhere, tells consumers at a glance how big a change is. | Must |
| VER13 | Every response must say, in its headers, the full version (major, minor and patch) of the API that served it. | Consumers can log it and quote it to support. We can tell which release a consumer hit when something goes wrong. It also shows when a minor or patch release has gone out. | Must |

## 5. Pagination

Most consumers want the whole register, or a large part of it, so paging is on the main path, not an edge case.

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| PAG01 | Every operation that can return more than one record must return results in pages. No operation may return an unbounded result. | Protects the service and keeps response times predictable. | Must |
| PAG02 | Consumers must be able to choose a page size, up to a documented maximum. The default size must also be documented. | Different consumers make different trade-offs between number of calls and response size. | Must |
| PAG03 | Each page must tell the consumer how to get the next page, and make it clear when there are no more. | Consumers shouldn't have to build paging logic from guesswork. | Must |
| PAG04 | Results must come back in a stable, documented order. | Without it, paging can't be relied on. | Must |
| PAG05 | A consumer paging through a result while the data changes must not miss or see twice any record that existed throughout. | Data changes during a full sync. Missing a school silently is the worst outcome. | Must |
| PAG06 | The last page must respond as quickly as the first. | A full sync walks the whole register. Paging that slows down with depth makes that impractical. | Must |
| PAG07 | A response should say how many records match in total. | Lets consumers show progress and check that a load is complete. | Should |

## 6. Data offered

The public API publishes the same data as the public website, because both read the same projection.

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| DAT01 | The API must offer establishments, open and closed. | The core need of almost every consumer. | Must |
| DAT02 | The API must offer groups, such as trusts, federations and local authorities, and the membership of establishments in them, with the dates that membership started and ended. | Trust membership is one of the hardest things consumers work out today. | Must |
| DAT03 | Consumers must be able to get the history of an establishment's predecessors: which establishments came before it, what happened to them (such as conversion, amalgamation or split) and when. They must also be able to go the other way, from an establishment to its successors. | Consumers need to follow a school through a change of URN, and to join up records from before and after it (information specification IQ06). | Must |
| DAT04 | The API should offer sites, including additional sites of establishments with more than one. | Multi-site schools cause significant workarounds for local authority teams. | Should |
| DAT05 | Whether the API offers governance data, and which parts, is to be decided. Any personal data must have a completed data protection impact assessment before it's included. | Governance data is published today but includes people's names. It needs a deliberate decision. | Candidate |
| DAT06 | The API must only return data that is published on the public website. Data that isn't published must never be returned, whatever the credential. | The public API reads the published projection. Restricted data belongs in Read API Internal. | Must |
| DAT08 | Every coded value must come with both its code and its label. | Consumers shouldn't need a separate lookup to understand a response. | Must |
| DAT09 | Consumers must be able to get every code list, with labels and whether each code is still in use. | Consumers need to validate and map codes. | Must |
| DAT10 | Field names and meanings must follow the registry's information model, not BAU column names. | The API is a long-term contract. It mustn't lock in the legacy schema. | Must |
| DAT11 | The API must not use placeholder values, such as "Not applicable" or "99", to stand for missing information. The documentation must say what an absent field means. | Placeholders get loaded as real data and cause errors downstream. | Must |
| DAT12 | Locations should be given as latitude and longitude, as well as easting and northing. | Consumers convert coordinates themselves today. | Should |
| DAT13 | Consumers should be able to ask for a compact version of a record, holding only the most-used fields. | Nine fields serve almost everyone. Many consumers don't want the other 98. | Should |
| DAT14 | A record must include the identifiers of the records it relates to, so consumers can follow the relationship. | Consumers need to move from a school to its trust, sites and successors without searching. | Must |

## 7. Identifiers

A published identifier is a promise. Once a consumer stores it, it has to keep working.

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| IDN01 | Consumers must be able to get an establishment by its URN. | The URN is the identifier almost everyone stores. | Must |
| IDN02 | Consumers must be able to find establishments by UKPRN and by LAESTAB. | These are the other main keys consumers match on. | Must |
| IDN03 | Consumers must be able to get a group by its group UID, and find it by Companies House number where it has one. | Trusts are matched on both today. | Must |
| IDN04 | Every identifier the API publishes must stay the same for the life of the record. It must not change because of a data reload, an environment rebuild or the move off BAU. | Stored identifiers must keep working. See [site identifiers](../../claude/site-identifiers-replication-and-api-urls.md). | Must |
| IDN05 | An identifier must never be reused for a different record. | Reuse makes old references point at the wrong thing. | Must |
| IDN06 | Asking for a closed establishment must return it, showing it's closed. It must not look as if it was never there. | Consumers still hold references to closed schools. | Must |

## 8. Finding records

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| QRY01 | Consumers must be able to filter establishments by status, type, phase, local authority and group. | These are the filters consumers apply after downloading the whole file today. | Must |
| QRY02 | Consumers must be able to combine filters in one request. | Common needs, such as open academies in one local authority, cross several filters. | Must |
| QRY03 | Consumers should be able to filter by date opened and date closed. | Supports annual and termly reporting. | Should |
| QRY04 | Common categories that consumers work out themselves, such as state-funded, should be published as data and be usable as filters. | Every consumer has their own rule today, written down in different places. One published rule removes that. | Should |
| QRY05 | Consumers could search establishments by name. | Supports look-up as a user types. The website already does this. | Could |
| QRY06 | Consumers could find establishments near a location. | A known website use. Not yet shown as an API need. | Could |

## 9. Keeping a copy up to date

This is the hardest part of using GIAS data today, and the main reason consumers want an API.

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| CHG01 | Every record must show when it last changed. | Consumers need it to decide what to reload. | Must |
| CHG02 | Consumers must be able to ask for every record that has changed since a time they give. | Lets them keep a copy in step without reloading everything. | Must |
| CHG03 | Changes must include records that have closed, been withdrawn from publication or been marked as created in error. | Without this, consumers can't tell a deletion from a record that didn't change. | Must |
| CHG04 | Every response must say when the data was last refreshed. | Consumers need to know how current the data is, especially while beta loads from BAU daily. | Must |
| CHG05 | A change should say what kind of change it was, such as opened, closed, converted, renamed or changed trust. | Some changes start work in a consumer's service. They shouldn't have to compare old and new records to find out which. | Should |
| CHG06 | Telling consumers about changes as they happen, such as by webhook, is to be decided after user research. | We don't yet know whether consumers can receive notifications, or need them. | Candidate |
| CHG07 | Consumers should be able to ask whether a record has changed since they last fetched it, without downloading it again. | Saves bandwidth and our capacity. | Should |

## 10. History

The registry keeps the full history of every record. How much of it the public API exposes is a decision, not a given.

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| HIS01 | The API must include closed establishments and groups. | Consumers report on past years and hold references to closed records. | Must |
| HIS02 | Current values should show the date they took effect, such as when the current name or trust membership started. | Consumers need to know whether a fact applied on a given date. | Should |
| HIS03 | Consumers could ask what a record looked like on a past date. | Researchers and analysts need it. The cost and scope need deciding first. | Candidate |
| HIS04 | Where history is offered, it should tell a real change apart from a correction. | A correction isn't an event in the world. Treating it as one gives wrong analysis (information specification IR05). | Candidate |

## 11. Bulk data

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| BLK01 | A consumer must be able to load the full set of published establishments through the API within the published rate limits in a reasonable time. Proposed: under 30 minutes. | The API has to support a first load and a periodic full check, not just single look-ups. | Must |
| BLK02 | A bulk download should be available alongside the API, with the same fields, definitions and refresh time. | Some consumers are batch-only, or can't make many calls. | Should |

## 12. Responses and errors

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| FMT01 | Responses must be JSON, encoded in UTF-8. | The common default. Expected by the GDS API standards. | Must |
| FMT02 | Dates and times must follow ISO 8601. Times must include a time zone. | Avoids ambiguity between local formats. | Must |
| FMT03 | Naming and structure must be consistent across the whole API. | Consumers learn the pattern once. | Must |
| FMT04 | Responses should support compression. | Large pages travel faster. | Should |
| ERR01 | The API must use standard HTTP status codes, and use them consistently. | Consumers' tools handle them automatically. | Must |
| ERR02 | Every error must have a consistent, machine-readable body, with a message a developer can act on. | Consumers need to handle errors in code and fix their own mistakes. | Must |
| ERR03 | An invalid request must say which part was wrong and why. | Shortens support calls. | Must |
| ERR04 | Every response must carry a reference that consumers can quote to support. | Lets us trace a problem from a support ticket to our logs. | Must |

## 13. Access and security

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| SEC01 | The API must be read-only. No call may change registry data. | The public API publishes. Changes go through Data Stewardship. | Must |
| SEC02 | The API must only be reachable over HTTPS, using a TLS version that DfE currently allows. | Basic protection of data in transit. | Must |
| SEC03 | Every consumer must have a rate limit. The limits must be published. | Protects the service for everyone. Consumers need to plan around the limits. | Must |
| SEC04 | When a consumer goes over their limit, the API must say so clearly and say when they can try again. | Lets well-behaved clients back off on their own. | Must |
| SEC05 | We must be able to block or throttle a single consumer without affecting others. | Lets us deal with abuse or a runaway client. | Must |
| SEC06 | Credentials must never be sent in a URL. | URLs end up in logs and browser history. | Must |
| SEC07 | The API must be penetration tested before public beta and after major changes. | Required for a public-facing service. | Must |
| SEC08 | The licence for reusing the data must be stated in the documentation and the catalogue. Proposed: the Open Government Licence, to be confirmed. | Consumers need to know what they're allowed to do before they can use the data. | Must |

## 14. Performance and availability

All targets here are **proposed** and need confirming with the service owner and through user research. They belong in the NFR register once agreed.

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| PRF01 | The API must meet a published availability target. Proposed: 99.5% each month, excluding announced maintenance. | Consumers build schedules and alerts around it. | Must |
| PRF02 | Getting a single record must be fast. Proposed: 95% of requests within 500 ms, measured at the gateway. | Supports look-up while a user waits. | Must |
| PRF03 | Getting a page of results must be fast. Proposed: 95% of requests within 2 seconds at the maximum page size. | Supports full syncs in a reasonable time. | Must |
| PRF04 | A change approved in the registry must appear in the API within a published time. During private beta, data must be no older than the website. | Consumers need to know how current the data is. | Must |
| PRF05 | The API must handle known busy periods, such as September and census dates. Capacity must be tested at a published multiple of normal load. Proposed: three times. | Demand peaks at the times consumers most need the data. | Must |
| PRF06 | Planned maintenance must be announced to subscribers in advance. Proposed: at least 5 working days. | Lets consumers reschedule loads. | Must |
| PRF07 | The API's current status and any incidents should be shown on a public status page. | Consumers can check whether a failure is theirs or ours. | Should |

## 15. Documentation and onboarding

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| DOC01 | The API must have an OpenAPI document that matches the running API. Automated tests must check that it does. | It's the contract, and it feeds the FaUAPI catalogue. A wrong contract is worse than none. | Must |
| DOC02 | There must be a getting started guide covering access, the first call, paging and errors. | Consumers need to get from first look to a working call without help. | Must |
| DOC03 | There must be a guide to keeping a copy up to date: first load, changes since, deletions and full checks. | This is the main use. Getting it wrong means silently wrong data. | Must |
| DOC04 | Every field and code must have a published definition, linked to the registry's data dictionary. | Misunderstood fields are a common source of errors today. | Must |
| DOC05 | There must be a mapping from the fields in today's CSV download to their equivalents in the API. | Most consumers are moving from the CSV. The mapping is their migration plan. | Must |
| DOC06 | There should be worked examples for common needs, such as following a conversion or listing a trust's schools. | The hard cases are where consumers go wrong. | Should |
| DOC07 | Documentation must meet the public sector accessibility regulations (WCAG 2.2 AA). | A legal duty for public sector websites. | Must |
| DOC08 | A developer new to the API should be able to make a successful call within 30 minutes of finding it (proposed). | A measure of whether onboarding works. | Should |
| DOC09 | The sandbox must hold realistic data that covers the hard cases, such as conversions, closures, multi-site schools and trust moves. | Consumers can only test what the sandbox lets them see. | Should |

## 16. Support and operations

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| SUP01 | Consumers must have a published support route, with published support hours and response times. | They need to know where to go when something breaks. | Must |
| SUP02 | Support requests that come through FaUAPI must reach the GIAS team. | The FaUAPI support address is shared across DfE. | Must |
| SUP03 | Consumers must be able to report a data quality problem, and it must reach the team that can fix the data. | Consumers are often first to spot wrong data. | Must |
| SUP04 | We must tell subscribers about incidents that affect them, while they're happening and when they're resolved. | Automated consumers fail silently otherwise. | Must |
| SUP05 | The API must be monitored, with alerts for errors, slow responses, unusual usage and stale data. | We should know about a problem before consumers tell us. | Must |

## 17. Moving from today's routes

| ID | Requirement | Why | Priority |
| --- | --- | --- | --- |
| MIG01 | The CSV download and the SOAP web service must keep running until an agreed retirement date. The API must not replace them at launch. | Consumers need time to move. Some will move only once the API is proven. | Must |
| MIG02 | Retiring an existing route must follow the same notice rules as a breaking change (VER06 and VER08). | It's a breaking change for the people who use it. | Must |
| MIG03 | We should know who uses each existing route, so we can tell them when the API is ready and when the old route will close. | Most of today's consumers are invisible to us. | Should |

## 18. Open questions for the business analyst

These need answers before the requirements can be approved. The [user research guide](../../claude/public-api-user-research-questions.md) covers most of them.

| Question | Affects |
| --- | --- |
| Who are the first consumers, and is the API open to anyone or to approved organisations only? (Tech plan Q04.) | FAU07, SEC03, all priorities |
| Is a FaUAPI subscription key acceptable for open data, or do some consumers need anonymous access? | FAU04, FAU07 |
| Which parts of governance data, if any, should the public API offer? | DAT05 |
| Do consumers need history, or only the current picture with effective dates? | HIS02 to HIS04 |
| Do consumers need to be told about changes as they happen, and can their systems receive notifications? | CHG06 |
| What notice periods do consumers need for breaking changes and retirements? | VER06, MIG02 |
| What availability, speed and freshness do consumers actually need? | PRF01 to PRF04 |
| Can breaking changes happen during beta with shorter notice, and how short? | VER06, VER10 |
| Is the Open Government Licence right for all the data we publish? | SEC08 |
| How should this API and the Academies API relate in the catalogue? | FAU11 |
| How does FaUAPI subscription approval work, and can it be automatic for this API? | FAU07 |
| Which OpenAPI version does FaUAPI import? | FAU03, DOC01 |

## 19. Next steps

1. Test these requirements in user research, using the discussion guide. Record which findings support, change or remove each one.
2. Confirm the proposed targets with the service owner and add them to the NFR register.
3. Take the FaUAPI requirements (section 3) to the FaUAPI team to check they're achievable.
4. Hand the agreed set to the development team, who will write the API specification against it.
5. Architecture decisions that come out of this, such as hosting and the versioning policy, go to Robert Rees and Scott Dawson for approval.
