-- Read-only audit of classification/geography reference lists and their links.
-- Raises an error if Unknown or Not applicable has been modelled as a value.
DO $$
DECLARE
    ref record;
    link record;
    invalid_count bigint;
    total_links bigint;
    absence_pattern text := '^(unknown|not applicable( \(.*\))?|does not apply|not known)$';
BEGIN
    FOR ref IN
        SELECT c.oid, c.relname
        FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
        WHERE n.nspname='establishment' AND c.relkind='r'
          AND c.relname IN (
              'education_phase','gender_of_entry_type','admissions_policy',
              'boarding_provision','nursery_provision','sixth_form_provision',
              'specialist_provision_type','further_education_type',
              'section_41_approval_status','religious_character','religious_ethos',
              'diocese','government_office_region','district_administrative',
              'administrative_ward','parliamentary_constituency','lsoa','msoa',
              'urban_rural')
    LOOP
        total_links := 0;
        FOR link IN
            SELECT con.conrelid::regclass AS owner_table,
                   a.attname AS owner_column, b.attname AS reference_column
            FROM pg_constraint con
            JOIN pg_attribute a ON a.attrelid=con.conrelid AND a.attnum=con.conkey[1]
            JOIN pg_attribute b ON b.attrelid=con.confrelid AND b.attnum=con.confkey[1]
            WHERE con.contype='f' AND con.confrelid=ref.oid
        LOOP
            EXECUTE format(
                'SELECT count(*) FROM %s e JOIN establishment.%I r ON e.%I=r.%I WHERE r.name ~* $1',
                link.owner_table,ref.relname,link.owner_column,link.reference_column)
                INTO invalid_count USING absence_pattern;
            total_links := total_links + invalid_count;
        END LOOP;
        EXECUTE format('SELECT count(*) FROM establishment.%I WHERE name ~* $1',ref.relname)
            INTO invalid_count USING absence_pattern;
        IF invalid_count > 0 OR total_links > 0 THEN
            RAISE EXCEPTION '%: % placeholder rows, % placeholder links',
                ref.relname,invalid_count,total_links;
        END IF;
    END LOOP;
END $$;

SELECT 'PASS: no Unknown or Not applicable reference rows or links' AS result;
