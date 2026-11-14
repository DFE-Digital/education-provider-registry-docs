-- Failed batches roll back in a PL/pgSQL subtransaction before being split.
-- Only singleton data failures are logged; schema/connection/resource errors abort.
-- A failed CHECK can reject several rows at once using the database's own
-- expression, when its columns map directly to the source. No DQ rules are
-- duplicated here. Other errors fall back to splitting.
CREATE FUNCTION pg_temp.reject_failed_establishment_check(urns integer[],run_id uuid,
    failed_schema text,failed_table text,failed_constraint text,error_state text,error_text text)
RETURNS integer[] LANGUAGE plpgsql AS $function$
DECLARE check_id oid; expression text; values_sql text; nulls_sql text;
    nulls_fail boolean; rejected integer[];
BEGIN
    SELECT p.oid,pg_get_expr(p.conbin,p.conrelid) INTO check_id,expression
    FROM pg_constraint p JOIN pg_class c ON c.oid=p.conrelid JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname=failed_schema AND c.relname=failed_table AND p.conname=failed_constraint AND p.contype='c';
    IF check_id IS NULL THEN RETURN '{}'::integer[]; END IF;
    IF EXISTS (
        SELECT 1 FROM pg_constraint p CROSS JOIN LATERAL unnest(p.conkey) k(attnum)
        JOIN pg_attribute a ON a.attrelid=p.conrelid AND a.attnum=k.attnum
        WHERE p.oid=check_id AND NOT EXISTS(SELECT 1 FROM pg_attribute s
            WHERE s.attrelid='establishment_seed_stage'::regclass AND s.attname=a.attname AND NOT s.attisdropped)
    ) THEN RETURN '{}'::integer[]; END IF;
    SELECT string_agg(format('s.%I::%s AS %I',a.attname,format_type(a.atttypid,a.atttypmod),a.attname),','),
           string_agg(format('NULL::%s AS %I',format_type(a.atttypid,a.atttypmod),a.attname),',')
    INTO values_sql,nulls_sql
    FROM pg_constraint p CROSS JOIN LATERAL unnest(p.conkey) k(attnum)
    JOIN pg_attribute a ON a.attrelid=p.conrelid AND a.attnum=k.attnum WHERE p.oid=check_id;
    IF values_sql IS NULL THEN RETURN '{}'::integer[]; END IF;
    BEGIN
        -- Presence checks may concern optional child rows. Leave those to the
        -- actual loader rather than reject an absent child.
        EXECUTE format('SELECT (%s) IS FALSE FROM (SELECT %s) v',expression,nulls_sql) INTO nulls_fail;
        IF nulls_fail THEN RETURN '{}'::integer[]; END IF;
        EXECUTE format('SELECT array_agg(__seed_urn__) FROM
            (SELECT s.urn AS __seed_urn__,%s FROM establishment_seed_stage s WHERE s.urn=ANY($1)) v
            WHERE (%s) IS FALSE',values_sql,expression) INTO rejected USING urns;
    EXCEPTION WHEN OTHERS THEN RETURN '{}'::integer[];
    END;
    IF coalesce(cardinality(rejected),0)>0 THEN
        INSERT INTO migration.establishment_load_error
            (migration_run_id,urn,sqlstate,error_message,error_detail,source_row)
        SELECT run_id,s.urn,error_state,error_text,
               format('Rejected by model constraint %I.%I: %s',failed_table,failed_constraint,expression),to_jsonb(s)
        FROM establishment_seed_stage s WHERE s.urn=ANY(rejected);
    END IF;
    RETURN coalesce(rejected,'{}'::integer[]);
END;
$function$;

CREATE FUNCTION pg_temp.load_development_establishments(urns integer[],run_id uuid,load_sql text)
RETURNS integer LANGUAGE plpgsql AS $function$
DECLARE
    error_state text;
    error_text text;
    error_detail text;
    midpoint integer;
    failed_schema text; failed_table text; failed_constraint text;
    rejected integer[]; remaining integer[];
BEGIN
    BEGIN
        EXECUTE replace(load_sql,'__BATCH_URNS__',array_to_string(urns,','));
        RETURN cardinality(urns);
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS error_state=RETURNED_SQLSTATE,
            error_text=MESSAGE_TEXT,error_detail=PG_EXCEPTION_DETAIL,
            failed_schema=SCHEMA_NAME,failed_table=TABLE_NAME,failed_constraint=CONSTRAINT_NAME;
        IF error_state NOT LIKE '22%' AND error_state NOT LIKE '23%' AND error_state<>'P0001' THEN
            RAISE;
        END IF;
        IF error_text='Load source-owned reference dictionaries before importing establishments' THEN
            RAISE;
        END IF;
    END;
    IF error_state='23514' THEN
        rejected:=pg_temp.reject_failed_establishment_check(urns,run_id,failed_schema,failed_table,failed_constraint,error_state,error_text);
        IF cardinality(rejected)>0 THEN
            SELECT array_agg(u) INTO remaining FROM unnest(urns) u WHERE NOT u=ANY(rejected);
            IF remaining IS NULL THEN RETURN 0; END IF;
            RETURN pg_temp.load_development_establishments(remaining,run_id,load_sql);
        END IF;
    END IF;
    IF cardinality(urns)=1 THEN
        INSERT INTO migration.establishment_load_error
            (migration_run_id,urn,sqlstate,error_message,error_detail,source_row)
        SELECT run_id,s.urn,error_state,error_text,error_detail,to_jsonb(s)
        FROM establishment_seed_stage s WHERE s.urn=urns[1];
        RETURN 0;
    END IF;
    midpoint:=cardinality(urns)/2;
    RETURN pg_temp.load_development_establishments(urns[1:midpoint],run_id,load_sql)
         + pg_temp.load_development_establishments(urns[midpoint+1:cardinality(urns)],run_id,load_sql);
END;
$function$;

DO $runner$
DECLARE batch record; accepted integer; rejected jsonb; attempted integer:=0; loaded integer:=0;
BEGIN
    FOR batch IN
        SELECT batch_number,array_agg(urn ORDER BY urn) AS urns
        FROM (SELECT urn,(row_number() OVER (ORDER BY urn)-1)/__BATCH_SIZE__ AS batch_number
              FROM establishment_seed_stage) s
        GROUP BY batch_number ORDER BY batch_number
    LOOP
        accepted:=pg_temp.load_development_establishments(batch.urns,'__RUN_ID__'::uuid,'__LOAD_SQL__');
        TRUNCATE source_establishment_fixture,source_main_site_fixture;
        attempted:=attempted+cardinality(batch.urns);
        loaded:=loaded+accepted;
        SELECT jsonb_agg(jsonb_build_object('urn',urn,'sqlstate',sqlstate,
                   'error_message',error_message,'first_seen',recorded_at)) INTO rejected
        FROM migration.establishment_load_error
        WHERE migration_run_id='__RUN_ID__'::uuid AND urn=ANY(batch.urns);
        COMMIT;
        IF rejected IS NOT NULL THEN RAISE INFO 'EPR_REJECTIONS %',rejected; END IF;
        RAISE INFO 'Establishments processed: %, loaded: %, skipped: %',attempted,loaded,attempted-loaded;
    END LOOP;
    UPDATE migration.migration_run
    SET notes=jsonb_build_object('purpose','development seed','source_candidates',__CANDIDATES__,'attempted',attempted,'loaded',loaded,'skipped',attempted-loaded,'known_bad_excluded',__KNOWN_BAD_COUNT__)::text
    WHERE migration_run_id='__RUN_ID__'::uuid;
END;
$runner$;
