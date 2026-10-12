-- Non-owning DML roles. Owners/superusers remain trusted administrators.
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='epr_establishment_writer') THEN
        CREATE ROLE epr_establishment_writer NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='epr_establishment_corrector') THEN
        CREATE ROLE epr_establishment_corrector NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
    END IF;
END $$;
DO $$ BEGIN
    IF EXISTS(SELECT 1 FROM pg_roles WHERE rolname IN ('epr_establishment_writer','epr_establishment_corrector')
              AND (rolsuper OR rolcreaterole OR rolcreatedb OR rolreplication OR rolbypassrls OR rolcanlogin))
       OR EXISTS(SELECT 1 FROM pg_auth_members m JOIN pg_roles r ON r.oid=m.member
                 WHERE r.rolname IN ('epr_establishment_writer','epr_establishment_corrector'))
       OR EXISTS(SELECT 1 FROM pg_namespace n JOIN pg_roles r ON r.oid=n.nspowner
                 WHERE n.nspname='establishment' AND r.rolname IN ('epr_establishment_writer','epr_establishment_corrector'))
       OR EXISTS(SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace JOIN pg_roles r ON r.oid=c.relowner
                 WHERE n.nspname='establishment' AND r.rolname IN ('epr_establishment_writer','epr_establishment_corrector')) THEN
        RAISE EXCEPTION 'EPR permission roles must be unprivileged non-owning NOLOGIN roles without inherited memberships';
    END IF;
END $$;
CREATE TABLE IF NOT EXISTS establishment.data_correction_audit (
    data_correction_audit_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name text NOT NULL CHECK(table_name IN ('organisation_identifier','organisation_group')),
    record_id uuid NOT NULL,
    before_value jsonb NOT NULL,
    after_value jsonb NOT NULL,
    reason text NOT NULL CHECK(btrim(reason)<>''),
    performed_by name NOT NULL,
    active_role text NOT NULL,
    performed_at timestamptz NOT NULL DEFAULT now()
);
-- Correction operators cannot edit the tables directly or delete identifiers.
CREATE OR REPLACE FUNCTION establishment.correct_protected_data(
    p_table text,p_id uuid,p_changes jsonb,p_reason text
) RETURNS uuid LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, pg_temp AS $$
DECLARE old_row jsonb; new_row jsonb; audit_id uuid; new_type integer;
BEGIN
    IF p_reason IS NULL OR btrim(p_reason)='' OR p_changes IS NULL
       OR jsonb_typeof(p_changes)<>'object' OR p_changes='{}'::jsonb THEN
        RAISE EXCEPTION 'A correction requires explicit changes and a review reason' USING ERRCODE='23514';
    END IF;
    IF p_table='organisation_identifier' THEN
        IF EXISTS(SELECT 1 FROM jsonb_object_keys(p_changes) k
                  WHERE k NOT IN ('legal_entity_id','organisation_identifier_type_id','value')) THEN
            RAISE EXCEPTION 'Unsupported identifier correction field' USING ERRCODE='23514';
        END IF;
        SELECT to_jsonb(i) INTO STRICT old_row FROM establishment.organisation_identifier i
        WHERE organisation_identifier_id=p_id FOR UPDATE;
        UPDATE establishment.organisation_identifier i SET
            legal_entity_id=CASE WHEN p_changes ? 'legal_entity_id' THEN (p_changes->>'legal_entity_id')::uuid ELSE i.legal_entity_id END,
            organisation_identifier_type_id=CASE WHEN p_changes ? 'organisation_identifier_type_id' THEN (p_changes->>'organisation_identifier_type_id')::integer ELSE i.organisation_identifier_type_id END,
            value=CASE WHEN p_changes ? 'value' THEN p_changes->>'value' ELSE i.value END
        WHERE organisation_identifier_id=p_id RETURNING to_jsonb(i) INTO new_row;
    ELSIF p_table='organisation_group' THEN
        IF p_changes - 'organisation_group_type_id'<>'{}'::jsonb OR NOT(p_changes ? 'organisation_group_type_id') THEN
            RAISE EXCEPTION 'Only group type may be corrected here' USING ERRCODE='23514';
        END IF;
        SELECT to_jsonb(g) INTO STRICT old_row FROM establishment.organisation_group g
        WHERE organisation_group_id=p_id FOR UPDATE;
        new_type:=(p_changes->>'organisation_group_type_id')::integer;
        IF EXISTS(SELECT 1 FROM establishment.organisation_group_member_lead_period WHERE organisation_group_id=p_id)
           AND NOT EXISTS(SELECT 1 FROM establishment.organisation_group_type
                          WHERE organisation_group_type_id=new_type AND name='Children''s-centre group') THEN
            RAISE EXCEPTION 'A group with lead periods must remain a childrens-centre group' USING ERRCODE='23514';
        END IF;
        UPDATE establishment.organisation_group g SET organisation_group_type_id=new_type
        WHERE organisation_group_id=p_id RETURNING to_jsonb(g) INTO new_row;
    ELSE
        RAISE EXCEPTION 'Unsupported correction table' USING ERRCODE='23514';
    END IF;
    IF old_row=new_row THEN RAISE EXCEPTION 'Correction must change the record' USING ERRCODE='23514'; END IF;
    INSERT INTO establishment.data_correction_audit(table_name,record_id,before_value,after_value,reason,performed_by,active_role)
    VALUES(p_table,p_id,old_row,new_row,p_reason,session_user,current_setting('role'))
    RETURNING data_correction_audit_id INTO audit_id;
    RETURN audit_id;
END $$;
REVOKE ALL ON FUNCTION establishment.correct_protected_data(text,uuid,jsonb,text) FROM PUBLIC,epr_establishment_writer;
REVOKE ALL ON ALL TABLES IN SCHEMA establishment FROM PUBLIC,epr_establishment_writer,epr_establishment_corrector;
REVOKE ALL(organisation_identifier_id,legal_entity_id,organisation_identifier_type_id,value,is_current)
    ON establishment.organisation_identifier FROM PUBLIC,epr_establishment_writer,epr_establishment_corrector;
REVOKE ALL(organisation_group_id,name,organisation_group_type_id,local_authority_id,open_date,close_date)
    ON establishment.organisation_group FROM PUBLIC,epr_establishment_writer,epr_establishment_corrector;
REVOKE ALL ON SCHEMA establishment FROM PUBLIC,epr_establishment_writer,epr_establishment_corrector;
GRANT USAGE ON SCHEMA establishment TO epr_establishment_writer,epr_establishment_corrector;
GRANT SELECT ON ALL TABLES IN SCHEMA establishment TO epr_establishment_writer;
GRANT INSERT,UPDATE,DELETE ON establishment.establishment,establishment.establishment_geography,
    establishment.establishment_contact,establishment.establishment_lifecycle,
    establishment.address,establishment.site,establishment.establishment_to_site,
    establishment.capacity_and_pupil_measures,establishment.education_admissions_and_provision,
    establishment.statutory_age_range,establishment.specialist_provision,
    establishment.resourced_provision,establishment.sen_unit_provision,
    establishment.legal_entity,establishment.person,establishment.establishment_party_role,
    establishment.academy_trust_classification,establishment.establishment_responsibility,
    establishment.organisation_group_member,establishment.organisation_group_member_lead_period,
    establishment.group_identifier TO epr_establishment_writer;
GRANT INSERT ON establishment.organisation_identifier TO epr_establishment_writer;
GRANT UPDATE(is_current) ON establishment.organisation_identifier TO epr_establishment_writer;
GRANT INSERT,DELETE ON establishment.organisation_group TO epr_establishment_writer;
GRANT UPDATE(name,local_authority_id,open_date,close_date) ON establishment.organisation_group TO epr_establishment_writer;
GRANT SELECT ON establishment.data_correction_audit TO epr_establishment_corrector;
GRANT EXECUTE ON FUNCTION establishment.correct_protected_data(text,uuid,jsonb,text) TO epr_establishment_corrector;
