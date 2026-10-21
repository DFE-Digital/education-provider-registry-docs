# Reviewed migration fixtures

These JSON files contain case-specific source scope, identity assumptions,
expected values and evidence notes. Loading behaviour lives in reusable SQL.

| Cases | Fixture | Shared loader |
| --- | --- | --- |
| T1-T8, T10-T15R | `t1-group-addresses.json` through `t8-group-addresses.json`, `t10-group-addresses.json` through `t15r-group-addresses.json` | `load-reviewed-group-addresses.sql` |
| T10 | `../t10-controlled-decision.json` | `load-reviewed-proprietor.sql` |
| T17 | `t17-historical-membership.json` | `load-reviewed-historical-membership.sql` |

Address fixtures declare source UID/type pairs, expected owner grouping and
purpose for each populated or blank block. T1 expects separate SAT/MAT owners;
T2 and T3 expect one continuing trust. T4 expects a federation owner with two
blank source blocks and no target address association. T5 does the same for a
children's-centre group; T6 and T12 retain two blank foundation-trust blocks.
T7 retains two blank person-sponsor blocks and maps the operating trust's
populated primary block to an administrative association. T8 has separate former
and current operator addresses; T10 and T11R map a shared MAT/sponsor entity's
one populated MAT primary block. T13 maps the Grantham trust only; T14R maps
the GRACE SCHOOLS trust only and retains the Diocese blocks as blank evidence;
T15R maps the closed SAT's populated primary block without inferring an address
end date. Business address dates remain unknown.
No contact or registered-office purpose is inferred from another block.

The supplementary [T10 registered-office observation](t10-registered-office.json)
comes directly from Companies House company 06995649, observed on 19 October
2026. Its explicitly published purpose and company number attach the address
to the existing Outwood legal entity. It supplements the BAU administrative
observation and records unknown address-use dates. It is loaded by
`migrate-t10-registered-office.ps1` and replayed by the default BAU rebuild.
The shared address path resolves legal-entity and organisation-group owners. It
can retain blank person-source blocks as evidence, but the business model has no
person-address association. A populated person block requires a separate model
and migration decision.

T10 retains approved extract values, conflicting local context, registered
party identifiers and the shared-proprietor decision. T17 retains the expected
archived federation row and accepted membership-end inference. The historical
loader supports reviewed closed-federation memberships, not every possible
historical organisation-group scenario.
Expected local-context keys use PostgreSQL's canonical lower-case column names.

Changing a fixture is a reviewed data/assumption change, not a way to bypass
source conflict checks. The catalogue checks accepted review status, evidence
and file existence before a default rebuild. Rendering adds SHA-256 integrity
so runtime mutation is rejected. This is a consistency check, not a permissions
model, signature or independent approval workflow.

Case validators remain under `migration/validate-scripts`. Existing case-named
commands remain valid; T1-T8 and T10-T15R address commands are thin wrappers around one shared workflow.
The single Establishment creation file is unchanged.
