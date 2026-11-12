-- PostgreSQL has no ALTER TABLE command to reorder columns. Rebuild the
-- affected tables transactionally so the internal ID is physically first.
BEGIN;

ALTER TABLE establishment.establishment DROP CONSTRAINT establishment_establishment_type_id_fkey,
    DROP CONSTRAINT establishment_education_phase_id_fkey, DROP CONSTRAINT establishment_diocese_id_fkey;
ALTER TABLE establishment.establishment_type DROP CONSTRAINT establishment_type_establishment_type_category_id_fkey;
ALTER TABLE establishment.establishment_lifecycle DROP CONSTRAINT establishment_lifecycle_establishment_status_id_fkey,
    DROP CONSTRAINT establishment_lifecycle_reason_establishment_opened_id_fkey,
    DROP CONSTRAINT establishment_lifecycle_reason_establishment_closed_id_fkey;
ALTER TABLE establishment.establishment_geography DROP CONSTRAINT establishment_geography_urban_rural_id_fkey;

ALTER TABLE establishment.diocese RENAME TO _diocese_before_reorder;
CREATE TABLE establishment.diocese (diocese_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), code text NOT NULL UNIQUE, name text NOT NULL);
INSERT INTO establishment.diocese (diocese_id,code,name) SELECT diocese_id,code,name FROM establishment._diocese_before_reorder;
DROP TABLE establishment._diocese_before_reorder;

ALTER TABLE establishment.establishment_type_category RENAME TO _type_category_before_reorder;
CREATE TABLE establishment.establishment_type_category (establishment_type_category_id integer PRIMARY KEY, name text NOT NULL UNIQUE);
INSERT INTO establishment.establishment_type_category (establishment_type_category_id,name) SELECT establishment_type_category_id,name FROM establishment._type_category_before_reorder;
DROP TABLE establishment._type_category_before_reorder;

ALTER TABLE establishment.establishment_type RENAME TO _type_before_reorder;
CREATE TABLE establishment.establishment_type (
    establishment_type_id integer PRIMARY KEY,
    code text NOT NULL UNIQUE,
    name text NOT NULL,
    establishment_type_category_id integer NOT NULL REFERENCES establishment.establishment_type_category(establishment_type_category_id),
    academy_route_id integer REFERENCES establishment.academy_route(academy_route_id),
    CONSTRAINT establishment_type_academy_mapping CHECK (
        CASE code
            WHEN '34' THEN establishment_type_category_id=10 AND academy_route_id IS NOT DISTINCT FROM 1
            WHEN '28' THEN establishment_type_category_id=10 AND academy_route_id IS NOT DISTINCT FROM 2
            WHEN '44' THEN establishment_type_category_id=10 AND academy_route_id IS NOT DISTINCT FROM 1
            WHEN '33' THEN establishment_type_category_id=10 AND academy_route_id IS NOT DISTINCT FROM 2
            WHEN '42' THEN establishment_type_category_id=10 AND academy_route_id IS NOT DISTINCT FROM 1
            WHEN '43' THEN establishment_type_category_id=10 AND academy_route_id IS NOT DISTINCT FROM 2
            WHEN '45' THEN establishment_type_category_id=10 AND academy_route_id IS NOT DISTINCT FROM 1
            WHEN '46' THEN establishment_type_category_id=10 AND academy_route_id IS NOT DISTINCT FROM 2
            WHEN '57' THEN establishment_type_category_id=10 AND academy_route_id IS NULL
            ELSE establishment_type_category_id<>10 AND academy_route_id IS NULL END));
INSERT INTO establishment.establishment_type (establishment_type_id,code,name,establishment_type_category_id,academy_route_id)
SELECT establishment_type_id,code,name,establishment_type_category_id,academy_route_id FROM establishment._type_before_reorder;
DROP TABLE establishment._type_before_reorder;

ALTER TABLE establishment.education_phase RENAME TO _education_phase_before_reorder;
CREATE TABLE establishment.education_phase (education_phase_id integer PRIMARY KEY, name text NOT NULL UNIQUE);
INSERT INTO establishment.education_phase (education_phase_id,name) SELECT education_phase_id,name FROM establishment._education_phase_before_reorder;
DROP TABLE establishment._education_phase_before_reorder;

ALTER TABLE establishment.establishment_status RENAME TO _status_before_reorder;
CREATE TABLE establishment.establishment_status (establishment_status_id integer PRIMARY KEY, name text NOT NULL UNIQUE);
INSERT INTO establishment.establishment_status (establishment_status_id,name) SELECT establishment_status_id,name FROM establishment._status_before_reorder;
DROP TABLE establishment._status_before_reorder;

ALTER TABLE establishment.reason_establishment_opened RENAME TO _reason_opened_before_reorder;
CREATE TABLE establishment.reason_establishment_opened (reason_establishment_opened_id integer PRIMARY KEY, code text NOT NULL UNIQUE, name text NOT NULL UNIQUE);
INSERT INTO establishment.reason_establishment_opened (reason_establishment_opened_id,code,name) SELECT reason_establishment_opened_id,code,name FROM establishment._reason_opened_before_reorder;
DROP TABLE establishment._reason_opened_before_reorder;

ALTER TABLE establishment.reason_establishment_closed RENAME TO _reason_closed_before_reorder;
CREATE TABLE establishment.reason_establishment_closed (reason_establishment_closed_id integer PRIMARY KEY, code text NOT NULL UNIQUE, name text NOT NULL UNIQUE);
INSERT INTO establishment.reason_establishment_closed (reason_establishment_closed_id,code,name) SELECT reason_establishment_closed_id,code,name FROM establishment._reason_closed_before_reorder;
DROP TABLE establishment._reason_closed_before_reorder;

ALTER TABLE establishment.urban_rural RENAME TO _urban_rural_before_reorder;
CREATE TABLE establishment.urban_rural (id integer PRIMARY KEY, code text NOT NULL UNIQUE, name text NOT NULL);
INSERT INTO establishment.urban_rural (id,code,name) SELECT id,code,name FROM establishment._urban_rural_before_reorder;
DROP TABLE establishment._urban_rural_before_reorder;

ALTER TABLE establishment.establishment_to_site RENAME TO _establishment_to_site_before_reorder;
CREATE TABLE establishment.establishment_to_site (
    establishment_to_site_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    establishment_id uuid NOT NULL REFERENCES establishment.establishment(establishment_id),
    site_id uuid NOT NULL REFERENCES establishment.site(site_id),
    is_main_site boolean NOT NULL DEFAULT false,
    UNIQUE(establishment_id,site_id));
INSERT INTO establishment.establishment_to_site (establishment_to_site_id,establishment_id,site_id,is_main_site)
SELECT establishment_to_site_id,establishment_id,site_id,is_main_site FROM establishment._establishment_to_site_before_reorder;
DROP TABLE establishment._establishment_to_site_before_reorder;
CREATE UNIQUE INDEX ux_establishment_to_site_one_main ON establishment.establishment_to_site(establishment_id) WHERE is_main_site;

ALTER TABLE establishment.establishment ADD CONSTRAINT establishment_establishment_type_id_fkey FOREIGN KEY(establishment_type_id) REFERENCES establishment.establishment_type(establishment_type_id),
    ADD CONSTRAINT establishment_education_phase_id_fkey FOREIGN KEY(education_phase_id) REFERENCES establishment.education_phase(education_phase_id),
    ADD CONSTRAINT establishment_diocese_id_fkey FOREIGN KEY(diocese_id) REFERENCES establishment.diocese(diocese_id);
ALTER TABLE establishment.establishment_lifecycle ADD CONSTRAINT establishment_lifecycle_establishment_status_id_fkey FOREIGN KEY(establishment_status_id) REFERENCES establishment.establishment_status(establishment_status_id),
    ADD CONSTRAINT establishment_lifecycle_reason_establishment_opened_id_fkey FOREIGN KEY(reason_establishment_opened_id) REFERENCES establishment.reason_establishment_opened(reason_establishment_opened_id),
    ADD CONSTRAINT establishment_lifecycle_reason_establishment_closed_id_fkey FOREIGN KEY(reason_establishment_closed_id) REFERENCES establishment.reason_establishment_closed(reason_establishment_closed_id);
ALTER TABLE establishment.establishment_geography ADD CONSTRAINT establishment_geography_urban_rural_id_fkey FOREIGN KEY(urban_rural_id) REFERENCES establishment.urban_rural(id);

COMMIT;
