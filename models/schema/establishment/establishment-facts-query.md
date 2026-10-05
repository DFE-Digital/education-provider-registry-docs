# Establishment target facts query

This guide provides a set of queries for reviewing all migrated target facts
for one establishment. Replace `<URN>` in each query with the required
establishment URN before running it against PostgreSQL. Each section returns a
separate result set so that the facts remain easy to read.

```sql
SET search_path TO establishment;
```

## 1. Establishment, type and phase

This identifies the establishment and shows its establishment type and
education phase. It is the starting point for confirming that the correct URN
was loaded.

```sql
SELECT
    e.*,
    et.name AS establishment_type,
    ep.name AS education_phase
FROM establishment e
LEFT JOIN establishment_type et
    ON et.establishment_type_id = e.establishment_type_id
LEFT JOIN education_phase ep
    ON ep.education_phase_id = e.education_phase_id
WHERE e.urn = <URN>;
```

## 2. Geography, lifecycle, contact, sites and measures

This shows where the establishment is located, its operational lifecycle,
contact details, site information, and capacity and pupil measures.

```sql
SELECT 'geography' AS fact_area, to_jsonb(g) AS facts
FROM establishment e
JOIN establishment_geography g ON g.establishment_id = e.establishment_id
WHERE e.urn = <URN>

UNION ALL

SELECT 'lifecycle', to_jsonb(l)
FROM establishment e
JOIN establishment_lifecycle l ON l.establishment_id = e.establishment_id
WHERE e.urn = <URN>

UNION ALL

SELECT 'contact', to_jsonb(c)
FROM establishment e
JOIN establishment_contact c ON c.establishment_id = e.establishment_id
WHERE e.urn = <URN>

UNION ALL

SELECT 'site', to_jsonb(s) || jsonb_build_object('is_main_site', es.is_main_site)
FROM establishment e
JOIN establishment_to_site es ON es.establishment_id = e.establishment_id
JOIN site s ON s.site_id = es.site_id
WHERE e.urn = <URN>

UNION ALL

SELECT 'capacity_and_pupil_measures', to_jsonb(m)
FROM establishment e
JOIN capacity_and_pupil_measures m
    ON m.establishment_id = e.establishment_id
WHERE e.urn = <URN>;
```

## 3. Admissions, statutory age and specialist provision

This returns admissions and provision settings, statutory age ranges, and any
specialist, resourced or SEN-unit provision recorded for the establishment.

```sql
SELECT 'admissions_and_provision', to_jsonb(p)
FROM establishment e
JOIN education_admissions_and_provision p
    ON p.establishment_id = e.establishment_id
WHERE e.urn = <URN>

UNION ALL

SELECT 'statutory_age_range', to_jsonb(a)
FROM establishment e
JOIN education_admissions_and_provision p
    ON p.establishment_id = e.establishment_id
JOIN statutory_age_range a
    ON a.education_admissions_and_provision_id =
       p.education_admissions_and_provision_id
WHERE e.urn = <URN>

UNION ALL

SELECT 'specialist_provision', to_jsonb(s)
FROM establishment e
JOIN specialist_provision s
    ON s.establishment_id = e.establishment_id
WHERE e.urn = <URN>

UNION ALL

SELECT 'resourced_provision', to_jsonb(r)
FROM establishment e
JOIN specialist_provision s
    ON s.establishment_id = e.establishment_id
JOIN resourced_provision r
    ON r.specialist_provision_id = s.specialist_provision_id
WHERE e.urn = <URN>

UNION ALL

SELECT 'sen_unit_provision', to_jsonb(u)
FROM establishment e
JOIN specialist_provision s
    ON s.establishment_id = e.establishment_id
JOIN sen_unit_provision u
    ON u.specialist_provision_id = s.specialist_provision_id
WHERE e.urn = <URN>;
```

## 4. Establishment responsibilities

This shows which legal entity or person is responsible for the establishment,
the responsibility type, trust classification, dates, and whether each
responsibility is current.

```sql
SELECT
    e.urn,
    r.*,
    rt.name AS responsibility_type,
    at.name AS academy_trust_type,
    le.name AS legal_entity_name
FROM establishment e
JOIN establishment_responsibility r
    ON r.establishment_id = e.establishment_id
JOIN establishment_responsibility_type rt
    ON rt.responsibility_type_id = r.responsibility_type_id
LEFT JOIN academy_trust_type at
    ON at.academy_trust_type_id = r.academy_trust_type_id
LEFT JOIN legal_entity le
    ON le.legal_entity_id = r.legal_entity_id
WHERE e.urn = <URN>
ORDER BY r.start_date, r.end_date;
```

## 5. Legal entities, trust classifications and identifiers

This describes the legal entity connected to the responsibility, including
its legal-entity type, charity status, trust classification history, Companies
House or other organisation identifiers, and current classification flag.

```sql
SELECT DISTINCT
    le.*,
    let.name AS legal_entity_type,
    cs.name AS charity_status,
    atc.academy_trust_classification_id,
    atc.academy_trust_type_id,
    att.name AS academy_trust_type,
    atc.start_date AS classification_start_date,
    atc.end_date AS classification_end_date,
    atc.is_current AS classification_is_current,
    oi.value AS organisation_identifier,
    oit.name AS organisation_identifier_type
FROM establishment e
JOIN establishment_responsibility r
    ON r.establishment_id = e.establishment_id
JOIN legal_entity le
    ON le.legal_entity_id = r.legal_entity_id
LEFT JOIN legal_entity_type let
    ON let.legal_entity_type_id = le.legal_entity_type_id
LEFT JOIN charity_status cs
    ON cs.charity_status_id = le.charity_status_id
LEFT JOIN academy_trust_classification atc
    ON atc.legal_entity_id = le.legal_entity_id
LEFT JOIN academy_trust_type att
    ON att.academy_trust_type_id = atc.academy_trust_type_id
LEFT JOIN organisation_identifier oi
    ON oi.legal_entity_id = le.legal_entity_id
LEFT JOIN organisation_identifier_type oit
    ON oit.organisation_identifier_type_id =
       oi.organisation_identifier_type_id
WHERE e.urn = <URN>;
```

## 6. Migration evidence

This returns the migration-time evidence that supports the responsibility and
classification rows. It shows the source records and assertion metadata used
to explain how the target facts were derived.

```sql
SELECT 'responsibility_evidence' AS evidence_area, to_jsonb(x) AS evidence
FROM establishment e
JOIN establishment_responsibility r
    ON r.establishment_id = e.establishment_id
JOIN migration.establishment_responsibility_evidence x
    ON x.establishment_responsibility_id =
       r.establishment_responsibility_id
WHERE e.urn = <URN>

UNION ALL

SELECT 'classification_evidence', to_jsonb(x)
FROM establishment e
JOIN establishment_responsibility r
    ON r.establishment_id = e.establishment_id
JOIN academy_trust_classification c
    ON c.legal_entity_id = r.legal_entity_id
JOIN migration.academy_trust_classification_evidence x
    ON x.academy_trust_classification_id =
       c.academy_trust_classification_id
WHERE e.urn = <URN>;
```
