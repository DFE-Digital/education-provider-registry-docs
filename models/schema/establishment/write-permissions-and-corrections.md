# Establishment write permissions and corrections

The schema has two custom triggers: `check_group_member_lead_period` and
`check_membership_lead_boundaries`. They protect known lead/membership date
boundaries and current eligibility across related rows. The child trigger also
checks that the group is a children's-centre group. Unique, exclusion and foreign
key constraints continue to protect current leads, dated overlaps and membership
ownership.

## Ordinary writes

`epr_establishment_writer` is a non-owning NOLOGIN role. Grant it to a dedicated
application DML login, not a schema owner or superuser. Do not give that login
other roles or direct grants that restore the forbidden permissions.

- Organisation identifiers: SELECT, INSERT and UPDATE of `is_current` only.
- Organisation groups: SELECT, INSERT, DELETE and UPDATE of name, authority and
  opening/closing dates, not group ID or group type.
- Other business tables: SELECT, INSERT, UPDATE and DELETE.
- Reference tables: SELECT only. No schema CREATE or table TRUNCATE permission.
- Correction audit: SELECT only; no direct audit writes or correction execution.

The role does not grant migration-schema writes. Rebuild/export operations remain
trusted administrative tasks using the existing local `postgres` connection.
Any future non-owning migration account must receive separately reviewed evidence
permissions and must respect the same protected-column policy.

```sql
-- Run as a trusted administrator, using your actual application login.
GRANT epr_establishment_writer TO your_application_login;
```

No login, password or role membership is automatically created. The policy applies
to writers using this role; it cannot restrict PostgreSQL owners or superusers.
Do not use the local modelling account as the application's runtime account.

## Reviewed corrections

Grant `epr_establishment_corrector` only to a separate authorised correction login.
It has no direct business-table write privileges. Use the restricted
`establishment.correct_protected_data(table, id, changes, reason)` function.

```sql
BEGIN;
SET LOCAL ROLE epr_establishment_corrector;
SELECT establishment.correct_protected_data(
    'organisation_identifier',
    '<identifier UUID>'::uuid,
    '{"legal_entity_id":"<reviewed legal-entity UUID>"}'::jsonb,
    'Approved identity correction, decision reference ...'
);
COMMIT;
```

Allowed identifier fields are `legal_entity_id`, `organisation_identifier_type_id`
and `value`. For `organisation_group`, only `organisation_group_type_id` is allowed.
Every correction requires a nonblank review reason and a real change. Identifiers
cannot be deleted through this function. A group with lead periods cannot be
changed to a non-children's-centre type. Existing uniqueness and foreign keys still
apply. Corrections lock the target row and record before/after values, authenticated
session user, active role, reason and time in `data_correction_audit`, in the same
transaction. The function has a fixed search path and no PUBLIC execution grant.

This is an audit trail for authorised database corrections, not an independently
approved workflow or a tamper-proof log against trusted administrators.

## Existing targets and verification

Run `upgrade-two-trigger-policy.sql` as the trusted schema administrator. It applies
the permission policy before dropping the two superseded triggers, inside one
transaction. It does not rebuild or delete test-case data. Fresh rebuilds include
the policy automatically. Applying the policy requires permission to create the
two roles, unless an administrator has already provisioned them.

The full test suite runs `validate-write-permissions.sql`. Real SET ROLE probes
check permitted retirement/ordinary writes, rejected identity/group-type changes,
rejected DELETE/TRUNCATE and reference changes, denied writer corrections, required
review reason, correction auditing, and preserved group-type eligibility. All
synthetic business and audit rows roll back. Audit rows are included in fixture
exports so reviewed corrections survive checked-in replay.
