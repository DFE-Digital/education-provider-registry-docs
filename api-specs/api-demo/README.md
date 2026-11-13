# Published Establishment API demo

A small .NET 10 program that serves the two endpoints in the [Published Establishment API specification](../published-establishment-api-spec.md) (contract 1.0.0). It reads real data from a local `establishment_local` PostgreSQL database, built with the [local schema automation](../../models/schema/README.md).

```http
GET /v1/establishments/{URN}
GET /v1/establishments
GET /v1/establishments?status=open
GET /v1/establishments?status=closed
```

It's a demo, not production code. It runs on `http://localhost:5080` and only listens on your own machine.

## Before you start

You need:

- the [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0)
- PostgreSQL running locally on port 5432
- the `establishment_local` database, populated by one of the rebuild paths in the [local schema automation](../../models/schema/README.md)

The quickest rebuild uses the checked-in SQL. Run it from the repository root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-checked-in-sql.ps1"
```

The demo uses the same password file as the rebuild scripts, `%APPDATA%\postgresql\pgpass.conf`. If the rebuild works, the demo can connect.

## Run it

From this folder:

```powershell
.\run.ps1
```

Or, without the script:

```powershell
dotnet run --configuration Release
```

The first run downloads the PostgreSQL driver from NuGet and builds the program. Press Ctrl+C to stop.

If port 5080 is already in use, pick another:

```powershell
.\run.ps1 -Port 5090
```

## Try it

```powershell
Invoke-RestMethod http://localhost:5080/v1/establishments/137603 | ConvertTo-Json -Depth 10
Invoke-RestMethod "http://localhost:5080/v1/establishments?status=open" | ConvertTo-Json -Depth 10
curl.exe -i http://localhost:5080/v1/establishments/ABC
```

Use `curl.exe`, not `curl`. In Windows PowerShell, `curl` is an alias for `Invoke-WebRequest`.

A browser works too. Open <http://localhost:5080/v1/establishments/109613>.

The default fixture holds three schools:

| URN | School | What it shows |
| --- | --- | --- |
| 100018 | Netley Primary School & Centre for Autism | SEN types, resourced provision and an SEN unit |
| 109613 | Milton Ernest CofE Primary School | Faith context and a maintaining council with a start date |
| 137603 | Ridgewood School | An academy |

The fixture data is partly obfuscated. That's why some addresses say "obfuscated" and phone numbers say "111111".

## Settings

Settings live in `appsettings.json`. You can override any of them with an environment variable.

| Setting | Default | Environment variable |
| --- | --- | --- |
| Address | `http://localhost:5080` | `Urls` |
| Database | `establishment_local` on `127.0.0.1:5432` as `postgres` | `ConnectionStrings__Registry` |
| Rate limit | 120 requests a minute for each caller | `RateLimit__PermitLimit`, `RateLimit__WindowSeconds` |

For example, to point at a different database:

```powershell
$env:ConnectionStrings__Registry = 'Host=127.0.0.1;Port=5432;Database=establishment_test;Username=postgres'
.\run.ps1
```

There's no password in the settings. The database driver reads it from `%APPDATA%\postgresql\pgpass.conf`.

Every connection is read-only. The connection string turns on `default_transaction_read_only`, and every request also runs `SET TRANSACTION READ ONLY`. It still logs in as `postgres`, though. A real service would use a read-only role.

## What the demo follows from the contract

- **Exact paths.** Lowercase segments only. A trailing slash returns 404.
- **Validation.** Requests are checked in the contract's order: path, method, body, query, then URN.
- **Errors.** Every error is RFC 9457 problem details with `code`, `requestId` and, for validation errors, `errors`.
- **Negotiation.** `Accept` and `Accept-Encoding` support quality values. You get gzip when you ask for it, and a 406 when nothing you accept is available.
- **ETags.** SHA-256 of the exact bytes sent, after gzip, as Base64url. `If-None-Match` uses weak comparison and accepts `*`. A match returns 304.
- **Headers.** `API-Version`, `API-Status`, `X-Request-ID` and `Data-Last-Refreshed-At` go on every response, including 429s.
- **One consistent view.** Each request reads in one repeatable-read transaction.
- **Representation.** Nulls, empty strings, empty objects and empty arrays are left out. Zero and false are kept. Codes keep their leading zeroes.
- **Ordering.** Collections are sorted by URN, and sites put the main site first. SEN names are sorted. History arrays are sorted by start date (unknown dates last), then name.
- **Rate limiting.** Over the limit, you get a 429 with `Retry-After`.
- **Outages.** If the database is down, you get a 503 `publication-unavailable`. Unexpected failures return a 500 with no internal detail.

The ETags won't match the examples in the specification. The data is different, and the demo sends compact JSON rather than the indented JSON in the examples.

## Choices the specification doesn't settle

We had to make some calls the contract leaves open. Each one is easy to change.

| Question | What the demo does |
| --- | --- |
| What counts as "published"? | The schema has no published flag. Any establishment with status Open or Closed is published. |
| Where does `Data-Last-Refreshed-At` come from? | The latest completed run in `migration.migration_run`. With no completed run, every request returns 503 `publication-unavailable`. |
| Is a federation membership current? | Membership has no current flag. It's current when it hasn't ended and the federation hasn't closed. Trusts, sponsors and councils use the `is_current` flag. |
| Which LA code goes on `maintainingLocalAuthority`? | The council's LA code for the overlapping period, but only when exactly one code matches. |
| Should relationships be filtered by category? | No. The demo publishes whatever relationships the data holds. For example, special school 100018 gets its maintaining council. |
| What about individual sponsors? | They're left out. The schema has no name for a person yet, and `name` is required. |
| What happens to `HEAD`? | It returns 405, because the contract says GET only. |
| What if a required fact is missing? | The request returns 503 `publication-incomplete`, for both the detail and the collection. |

## Fields the schema can't fill yet

The schema doesn't hold these yet, so they never appear:

- `establishmentLeadership` (headteacher)
- `numberOfMales`, `numberOfFemales` and `percentagePupilsEligibleForFreeSchoolMeals`
- `osGridReference` and `address.country` on sites
- `alternativeProvisionCharacteristics`
- `inspectorateName` and the inspection dates. Only the report link is there.
- `history.previousLA` and `history.predecessors`

The code for academy trusts, sponsors, federations and foundation trusts is written. But the default fixture has none of those for the three schools, so it hasn't run against real rows yet. That's why Ridgewood (137603) has no `academyTrust`. When a fixture includes them, check those properties first.

## Files

| File | What it does |
| --- | --- |
| `Program.cs` | Startup, common headers, request log and rate limiting |
| `EstablishmentEndpoints.cs` | Path matching, request validation and the two endpoints |
| `EstablishmentStore.cs` | The SQL and the mapping from database rows to API JSON |
| `Responses.cs` | Problem details, content negotiation, gzip, ETags and 304s |
| `appsettings.json` | Address, connection string and rate limit |
| `run.ps1` | Starts the demo |
