DO $$
DECLARE owner_id uuid;
BEGIN
    SELECT i.legal_entity_id INTO STRICT owner_id
    FROM establishment.organisation_identifier i
    JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
    WHERE t.name='Companies House number' AND i.value='06995649' AND i.is_current;
    IF NOT EXISTS (
        SELECT 1 FROM establishment.legal_entity_address l
        JOIN establishment.address a USING(address_id)
        JOIN establishment.address_purpose p USING(address_purpose_id)
        JOIN migration.group_address_evidence ev USING(legal_entity_address_id)
        JOIN migration.source_record r USING(source_record_id)
        JOIN migration.source_snapshot s USING(source_snapshot_id)
        WHERE l.legal_entity_id=owner_id AND p.code='registered' AND l.is_current
          AND l.start_date IS NULL AND l.end_date IS NULL
          AND a.address_line_1='Potovens Lane' AND a.address_line_2='Outwood'
          AND a.address_line_3 IS NULL AND a.town='Wakefield'
          AND a.county='West Yorkshire' AND a.postcode='WF1 2PF'
          AND ev.source_address_block='registered_office'
          AND ev.mapping_decision='companies-house-registered-office'
          AND ev.raw_source_values->>'companyNumber'='06995649'
          AND ev.raw_source_values->>'sourceField'='registered_office_address'
          AND s.source_system='Companies House' AND s.snapshot_date=DATE '2026-10-19'
          AND s.extract_name='https://find-and-update.company-information.service.gov.uk/company/06995649'
          AND r.source_table='company_profile' AND r.source_group_id IS NULL
    ) THEN RAISE EXCEPTION 'Outwood registered office or Companies House provenance is missing'; END IF;
    IF NOT EXISTS (
        SELECT 1 FROM establishment.legal_entity_address l
        JOIN establishment.address a USING(address_id)
        JOIN establishment.address_purpose p USING(address_purpose_id)
        WHERE l.legal_entity_id=owner_id AND p.code='administrative' AND l.is_current
          AND a.address_line_1='Potovens Lane' AND a.address_line_2='Outwood'
          AND a.address_line_3='obfuscated' AND a.county IS NULL
          AND a.town='Wakefield' AND a.postcode='WF1 2PF'
    ) THEN RAISE EXCEPTION 'BAU administrative address was changed by registered-office migration'; END IF;
END $$;

SELECT e.name,p.name AS purpose,a.address_line_1,a.address_line_2,a.address_line_3,
       a.town,a.county,a.postcode,l.start_date,l.end_date,l.is_current,
       s.source_system,s.snapshot_date AS observed_on,s.extract_name AS source_url
FROM establishment.legal_entity_address l
JOIN establishment.legal_entity e USING(legal_entity_id)
JOIN establishment.address a USING(address_id)
JOIN establishment.address_purpose p USING(address_purpose_id)
LEFT JOIN migration.group_address_evidence ev USING(legal_entity_address_id)
LEFT JOIN migration.source_record r USING(source_record_id)
LEFT JOIN migration.source_snapshot s USING(source_snapshot_id)
WHERE p.code='registered'
  AND EXISTS (
      SELECT 1 FROM establishment.organisation_identifier i
      JOIN establishment.organisation_identifier_type t USING(organisation_identifier_type_id)
      WHERE i.legal_entity_id=l.legal_entity_id AND t.name='Companies House number'
        AND i.value='06995649' AND i.is_current
  );
