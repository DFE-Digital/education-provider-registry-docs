# Software inventory: Education Provider Registry

| Field | Details |
| --- | --- |
| Snapshot date | 26 November 2026 |
| Next review due | 26 May 2027 (six months), or sooner after a major platform change |
| Built from | The manifest files in each repo's default branch (see [How we built this](#how-we-built-this)) |

## Repos in scope

We use the short names in the right-hand column throughout this document. 

| Repo | What it does | Commit inventoried | Short name |
| --- | --- |---|---|
| [education-provider-registry-core](https://github.com/DFE-Digital/education-provider-registry-core) | Shared query library, published as NuGet packages for the website and API | `5d453ea` (2026-11-26) | core |
| [education-provider-registry-data](https://github.com/DFE-Digital/education-provider-registry-data) | Database schema, data generator, database model package, infrastructure for the data store | `3f4675d` (2026-11-26) | data |
| [education-provider-registry-public-API](https://github.com/DFE-Digital/education-provider-registry-public-API) | Public API application and its infrastructure | `72d446e` (2026-11-25) | api |
| [education-provider-registry-web](https://github.com/DFE-Digital/education-provider-registry-web) | Public website (ASP.NET Core MVC) and its infrastructure | `bc42087` (2026-11-26) | web |


## How to read the tables

- **Install date** is the date the item first appeared in that repo's git history, used here as a proxy for initial use. It is not a verified deployment date. Where an item is in several repos, we give the earliest date.
- **Repos** uses the short names from the table above.
- **Deployment**:
  - *Runtime* means it ships inside a container image that runs in production.
  - *Build* means it is used to build an artefact but doesn't ship in it.
  - *Test* means it is used only by automated tests.
  - *CI* means it runs on GitHub-hosted runners.
  - *Managed* means a cloud service we provision with Terraform.
- **Licence.** Identifies the terms under which each software component is supplied,
- **Security updates.** "Dependabot" means a weekly Dependabot check runs in at least one of the repos that use the item. "Manual" means someone has to bump the version.


## 1. Platforms, runtimes and languages

| Title | Publisher | Version | Repos | Install date | Purpose | Deployment | Licence | Security updates |
| --- | --- |---| --- | --- |---| --- | --- |---|
| .NET SDK | Microsoft | 10.0.400 (`global.json`) | core, data, api, web | 2026-05-27 | Builds all .NET code | Build, CI | MIT | LTS, supported to Nov 2028. Dependabot `dotnet-sdk` (minor only) in core and web |
| ASP.NET Core runtime | Microsoft | 10.0 (`aspnet:10.0` image) | api, web | 2026-05-29 | Runs the website and the API | Runtime | MIT | LTS to Nov 2028. Picked up when the image is rebuilt |
| Node.js | OpenJS Foundation | 22 (web build) | web | 2026-05-29 | Builds front-end assets for the website | Build, CI | MIT | 22 is LTS to Apr 2027. Manual |

## 2. Container base images

All our images are pushed to GitHub Container Registry (`ghcr.io/dfe-digital/education-provider-registry-*`).

| Title | Publisher | Version | Repos | Install date | Purpose | Deployment | Licence | Security updates |
| --- | --- |---| --- | --- |---| --- | --- |---|
| `mcr.microsoft.com/dotnet/aspnet` | Microsoft | `10.0-noble-chiseled@sha256:a5532f…` (api). `10.0` (web) | api, web | 2026-05-29 | Runtime base image for the API and the website | Runtime | MIT and Ubuntu packages | Rebuild to pick up patches. api's digest needs a manual bump |
| `mcr.microsoft.com/dotnet/sdk` | Microsoft | 10.0 | data, api, web | 2026-05-29 | Build stage. data's database model generator image | Build | MIT | Floating tag |
| `node` | Docker Official Images | `22-bookworm-slim@sha256:d943bf…` | web | 2026-05-29 | Builds the website's CSS and JavaScript assets | Build | MIT and Debian packages | Manual digest bump |
| `nginx/nginx-unprivileged` | NGINX (F5) | 1.30.7-alpine3.24 | data, api, web | 2026-11-19 | Serves the maintenance page | Runtime (during maintenance only) | BSD-2 | Manual |
| `postgres` | PostgreSQL Global Development Group | 17 | data | 2026-06-09 | Local and CI database image with schema scripts (`…-data-postgres`) | Build, Test | PostgreSQL Licence | Supported to Nov 2029. Floating minor version |
| `postgresql-client` (apt) | PostgreSQL Global Development Group | Debian repo version | data | 2026-10-14 | Used by the data generator image to talk to the database | Build | PostgreSQL Licence | Picked up when the image is rebuilt |

## 3. Application libraries that ship to production (NuGet)

These packages are inside the website and API containers.

| Title | Publisher | Version | Repos | Install date | Purpose | Licence | Security updates |
| --- | --- |---| --- | --- |---| --- | --- |
| Microsoft.EntityFrameworkCore (+ Relational, Design) | Microsoft | 10.0.15 (core, web). 10.0.9 (data) | core, data, web | 2026-06-24 | Database access (object-relational mapper) | MIT | Dependabot (core, web). Manual (data) |
| Npgsql.EntityFrameworkCore.PostgreSQL | Npgsql | 10.0.2 (core, data). 10.0.3 (web) | core, data, web | 2026-06-24 | PostgreSQL provider for Entity Framework Core | PostgreSQL Licence | Dependabot (core, web) |
| Microsoft.Extensions.* (Configuration, DI, Hosting, Logging, Options) | Microsoft | 10.0.15 | core | 2026-05-27 | Configuration, dependency injection, logging | MIT | Dependabot |
| Microsoft.AspNetCore.OpenApi | Microsoft | 10.0.15 | api | 2026-06-08 | Generates the API's OpenAPI document | MIT | Manual |
| Asp.Versioning.Mvc | .NET Foundation | 10.2.1 | api | 2026-11-23 | API versioning | MIT | Manual |
| Microsoft.VisualStudio.Azure.Containers.Tools.Targets | Microsoft | **1.24.1-preview.1** | web | 2026-05-29 | Visual Studio container tooling (see item 6 above) | Microsoft software licence | Dependabot |
| DfE.Core.Libraries.CleanArchitecture, .CrossCutting, .DesignPatterns | DfE (DFE-Digital) | 1.0.44 | core | 2026-05-27 | Shared DfE architecture and cross-cutting code | DfE internal | Manual. From GitHub Packages |
| DfE.EducationProviderRegistry.Data.DatabaseModels | DfE (this service, data repo) | 1.0.136 | core | 2026-06-29 | Generated database model classes | MIT (repo licence) | Manual. From GitHub Packages |
| DfE.EducationProviderRegistry.Core.Query | DfE (this service, core repo) | 0.0.55 (api). 0.0.61 (web) | api, web | 2026-06-01 | Shared query layer for the website and the API | MIT (repo licence) | Manual. From GitHub Packages |

## 4. Front-end packages that ship to production (npm)

Locked versions come from `src/DfE.EducationProviderRegistry.Web.Mvc/package-lock.json`. The container build runs `npm ci --ignore-scripts`.

| Title | Publisher | Locked version | Repos | Install date | Purpose | Licence | Security updates |
| --- | --- |---| --- | --- |---| --- | --- |
| govuk-frontend | Government Digital Service | 6.1.0 | web | 2026-05-29 | GOV.UK Design System styles, components and assets | MIT | Manual (Dependabot doesn't cover npm) |
| dfe-frontend | DfE | 2.0.1 | web | 2026-07-09 | DfE design system extensions | MIT | Manual |
| @ministryofjustice/frontend | Ministry of Justice | 9.0.0 | web | 2026-06-03 | MOJ Pattern Library components | MIT | Manual |
| @x-govuk/govuk-prototype-components | X-GOVUK community | 6.0.0 | web | 2026-07-09 | Extra GOV.UK-style components | MIT | Manual |
| accessible-autocomplete | Government Digital Service (Alphagov) | 3.0.1 | web | 2026-07-09 | Accessible type-ahead search | MIT | Manual |
| sass (Dart Sass) | Sass team | 1.103.1 | web | 2026-05-29 | Compiles SCSS to CSS | MIT | Build only. Manual |
| copyfiles | Open source (calvinmetcalf) | 2.4.1 | web | 2026-05-29 | Copies assets into `wwwroot` | MIT | Build only. Manual |

## 5. Test and code-quality libraries (not deployed)

These run only in CI and on developer machines.

| Title | Publisher | Version | Repos | Install date | Purpose | Licence |
| --- | --- |---| --- | --- |---|---|
| xunit.v3.mtp-v2, xunit.v3.assert | xUnit.net (.NET Foundation) | 3.2.2 | core, api, web | 2026-06-01 | Test framework | Apache-2.0 |
| Microsoft.Testing.Extensions.CodeCoverage | Microsoft | 18.8.0 | core, api, web | 2026-06-17 | Code coverage collection | Microsoft software licence (free) |
| coverlet.msbuild | Coverlet (.NET Foundation) | 10.0.1 | core, api, web | 2026-06-17 | Code coverage | MIT |
| Moq | Devlooped | 4.20.72 (core, api). 4.21.0 (web) | core, api, web | 2026-06-07 | Mocking | BSD-3 |
| Bogus | Brian Chavez | 35.6.5 | core, api, web | 2026-06-17 | Fake test data | MIT |
| Dapper | Stack Exchange | 2.1.79 | core | 2026-07-15 | Test database seeding | Apache-2.0 |
| EFCore.BulkExtensions.PostgreSql | borisdj | 10.0.1 | core | 2026-07-15 | Bulk inserts for the test database (see item 8 above) | **Dual licence. Commercial terms may apply** |
| Microsoft.EntityFrameworkCore.InMemory | Microsoft | 10.0.9 | core | 2026-07-02 | In-memory database for unit tests | MIT |
| Microsoft.AspNetCore.Mvc.Testing | Microsoft | 10.0.15 | api, web | 2026-07-07 | In-process web host for integration tests | MIT |
| Microsoft.AspNetCore.Mvc.Razor.RuntimeCompilation | Microsoft | 10.0.15 | web | 2026-07-06 | View component tests | MIT |
| Xunit.DependencyInjection (+ .Logging) | pengweiqhca | 11.3.0 (core, web). 11.2.1 (api). Logging 11.0.0 | core, api, web | 2026-06-03 | Dependency injection in tests | MIT |
| MartinCostello.Logging.XUnit.v3 | Martin Costello | 0.7.1 | core | 2026-06-03 | Test log output | Apache-2.0 |
| DfE.Core.Libraries.Testing, .IntegrationTests, .IntegrationTests.Containers, .IntegrationTests.Database.Postgres | DfE | 1.0.44 (core, api). 1.0.43 (web) | core, api, web | 2026-06-23 | Shared DfE test helpers, including Testcontainers | DfE internal |
| DfE.EducationProviderRegistry.Core.Query.Contracts.TestDoubles, .Test.Database | DfE (core repo) | 0.0.57 (api). 0.0.61 (web) | api, web | 2026-09-15 | Test doubles and a seeded test database | MIT (repo licence) |
| AngleSharp | AngleSharp | 1.11.0 | web | 2026-08-26 | HTML parsing in tests | MIT |
| Selenium.WebDriver, Selenium.Support | Software Freedom Conservancy | 4.51.0 | web | 2026-07-21 | Browser automation for UI tests | Apache-2.0 |
| DotNetSeleniumExtras.PageObjects | Open source community | 3.11.0 | web | 2026-07-21 | Page object support | Apache-2.0 |
| Deque.AxeCore.Selenium | Deque Systems | 4.14.0 | web | 2026-07-21 | Automated accessibility checks | MPL-2.0 |
| Verify.XunitV3 | Simon Cropp | 31.20.0 | web | 2026-07-06 | Snapshot testing | MIT |
| FluentValidation | Jeremy Skinner | 12.2.0 | web | 2026-11-10 | Validation in shared test code | Apache-2.0 |
| dotnet-coverage (tool) | Microsoft | 18.7.0 | core | 2026-06-07 | Coverage collection in CI | Microsoft software licence (free) |
| dotnet-sonarscanner (tool) | SonarSource | 11.2.1 | core, api, web | 2026-06-15 | Sends analysis to SonarQube Cloud | LGPL-3.0 |
| dotnet-reportgenerator-globaltool (tool) | Daniel Palme | 5.5.10 | core, api, web | 2026-06-15 | Coverage reports | Apache-2.0 |
| dotnet-ef (tool) | Microsoft | 10.0.9 | data | 2026-06-24 | Scaffolds the database model package from the schema | MIT |

## 6. Infrastructure as code

| Title | Publisher | Version | Repos | Install date | Purpose | Licence | Security updates |
| --- | --- |---| --- | --- |---| --- | --- |
| Terraform CLI | HashiCorp | 1.14.5 (pinned in `.tool-versions` and `required_version`) | data, api, web | 2026-06-23 | Provisions Azure and Kubernetes resources | BUSL-1.1 (internal use is allowed) | Manual |
| hashicorp/azurerm provider | HashiCorp | 4.61.0 | data, api, web | 2026-06-23 | Azure resources | MPL-2.0 | Manual (lock file) |
| hashicorp/kubernetes provider | HashiCorp | 2.32.0 | data, api, web | 2026-06-23 | Kubernetes resources | MPL-2.0 | Manual |
| hashicorp/azuread provider | HashiCorp | 3.10.0 | api | 2026-11-05 | Entra ID objects for Azure SQL | MPL-2.0 | Manual |
| hashicorp/random provider | HashiCorp | 3.9.0 (data). 3.9.1 (api) | data, api | 2026-06-23 | Random values | MPL-2.0 | Manual |
| hashicorp/time provider | HashiCorp | 0.14.0 | web | 2026-06-23 | Time-based resources | MPL-2.0 | Manual |
| eppo/environment provider | Eppo | 1.3.5 | data, api, web | 2026-06-23 | Reads environment variables in Terraform | MPL-2.0 | Manual |
| StatusCakeDev/statuscake provider | StatusCake | Set by terraform-modules | web | 2026-06-23 | Uptime checks | MPL-2.0 | Through terraform-modules |
| DFE-Digital/terraform-modules | DfE Teacher Services | `stable` (production), `testing` (pre-production, test, development), `main` (review). **data test uses a feature branch** | data, api, web | 2026-06-23 | Shared AKS, Postgres, Redis, SQL, secrets, domains and monitoring modules | MIT | Branch-tracked. Not pinned to a version |
| DFE-Digital/tra-shared-services ARM templates | DfE | 1.1.17 | data, api, web | 2026-06-23 | Creates resource groups and monitoring resources | MIT | Manual |
| konduit.sh | DfE Teacher Services (teacher-services-cloud) | `main` (unpinned) | data, api, web | 2026-06-23 | Tunnels to databases for maintenance tasks | MIT | Unpinned |

## 7. CI/CD actions (GitHub Actions)

| Title | Publisher | Version | Repos | Install date | Purpose | Security updates |
| --- | --- |---| --- | --- |---|---|
| actions/checkout | GitHub | v4 (api, web). v6 (data). v7 (core, data) | core, data, api, web | 2026-05-28 | Checks out code | Dependabot (core, web) |
| actions/setup-dotnet | GitHub | v5 (data). v6 (core, api, web) | core, data, api, web | 2026-05-28 | Installs .NET | Dependabot (core, web) |
| actions/setup-node | GitHub | v4 | web | 2026-06-30 | Installs Node | Dependabot (web) |
| actions/upload-artifact, download-artifact | GitHub | v7, v8 | core, api, web | 2026-05-28 | Passes build outputs between jobs | Dependabot (core, web) |
| azure/login | Microsoft | v3 | data, web | 2026-06-23 | Signs in to Azure with OIDC | Dependabot (web) |
| gittools/actions/gitversion (setup, execute) | GitTools | SHA `7417b10…` | core | 2026-05-28 | Works out semantic package versions | Dependabot |
| DFE-Digital/github-actions/sonarscan-dotnet | DfE | SHA-pinned (3 different SHAs) | core, api, web | 2026-06-15 | SonarQube Cloud scan | Dependabot (core, web) |
| DFE-Digital/github-actions (build-docker-image, deploy-to-aks, deploy-domains-env, deploy-domains-infra, validate-infra, maintenance, delete-review-app, backup-postgres, restore-postgres-backup, restore-deleted-postgres, ptr-postgres, send-to-teams-channel) | DfE Teacher Services | **`@master`** (web has one call pinned by SHA) | data, api, web | 2026-06-23 | Build, deploy, database backup and restore, notifications | Unpinned (see item 2 above) |





## How we built this



Clone the default branch of each of the four in-scope repositories and read these files. 

- `global.json` and `dotnet-tools.json` (.NET SDK and tools)
- `Directory.Packages.props` and `*.csproj` (NuGet packages)
- `package.json` and `package-lock.json` (npm packages)
- `Dockerfile*` (base images)
- `.tool-versions`, `terraform.tf`, `.terraform.lock.hcl` and `global_config/*.sh` (Terraform and providers)
- `Makefile` (fetched scripts and templates)
- `.github/workflows/*.yml` (actions)
- `.github/dependabot.yml` (update checks)
- `terraform/application/*.tf` (managed services)

To populate each "Install date", we searched each repo's full history with `git log -S <name>` and recorded the earliest appearance as a proxy for initial use.

The inventory lists the packages we reference directly. It does not list transitive dependencies, such as the 89 npm packages in web's lock file or the NuGet dependency tree. 


