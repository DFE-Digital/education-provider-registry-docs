BEGIN;
\ir group-address-schema.sql
\ir ../seed/seed-address-purposes.sql
\ir ../migration/group-address-evidence-schema.sql
\ir establishment-write-permissions.sql
COMMIT;
