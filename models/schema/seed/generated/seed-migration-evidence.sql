--
-- PostgreSQL database dump
--

\restrict vV7SIPHqe3IP8oF7QewK6ZPWSv1Huzw5mu8ScOAhh1Gg8K0h3daMKbDEb57cGxD

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: migration_run; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.migration_run (migration_run_id, run_type, source_system, source_database, source_snapshot_date, started_at, completed_at, status, transform_version, notes) VALUES
	('71bc6206-d612-4cd5-8e71-c539a229ff62', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 13:55:09.050033+01', '2026-10-01 13:55:09.050033+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('9682160b-525e-4bf8-9297-bb0cc1341ed7', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 13:55:09.394582+01', '2026-10-01 13:55:09.394582+01', 'completed', 'academy-trust-responsibility-v1', NULL);


--
-- Data for Name: source_snapshot; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_snapshot (source_snapshot_id, migration_run_id, source_system, source_database, snapshot_date, extract_name, created_at) VALUES
	('45df864d-759b-408a-81d2-5396bdbcf5b3', '71bc6206-d612-4cd5-8e71-c539a229ff62', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 13:55:09.050033+01'),
	('d535a3b4-948a-4880-9a97-bd4c2375b82f', '9682160b-525e-4bf8-9297-bb0cc1341ed7', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 13:55:09.394582+01');


--
-- Data for Name: source_record; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_record (source_record_id, source_snapshot_id, source_table, source_key, source_group_id, source_urn, source_row_hash) VALUES
	('15f4b27d-759d-49e3-b291-138fdfd46433', '45df864d-759b-408a-81d2-5396bdbcf5b3', 'dbo.EstablishmentGroup/GroupLink', '2777:136102', '2777', 136102, NULL),
	('b3a787e2-dfd3-495e-9da6-e6568e11fa32', 'd535a3b4-948a-4880-9a97-bd4c2375b82f', 'dbo.EstablishmentGroup/GroupLink', '4949:136102', '4949', 136102, NULL);


--
-- Data for Name: establishment_party_role_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_party_role_evidence (evidence_id, establishment_party_role_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('13c090ad-63f5-42af-85a1-a3dc41c19a7c', '72ae27b3-7348-48e5-95cb-41511933ae9e', '15f4b27d-759d-49e3-b291-138fdfd46433', NULL, NULL, NULL, 'accepted', NULL),
	('52d329ab-0d5e-4fe0-8649-64b23c659a4d', 'a449ab36-1a30-436d-87c5-23840ab58383', 'b3a787e2-dfd3-495e-9da6-e6568e11fa32', NULL, NULL, NULL, 'accepted', NULL);


--
-- Data for Name: establishment_responsibility_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_responsibility_evidence (evidence_id, establishment_responsibility_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('4e7c34f5-f2c7-4169-8c4b-b7fe72f082f0', '4ad44a7e-fde9-43dc-ad39-cc0a93c4140e', '15f4b27d-759d-49e3-b291-138fdfd46433', NULL, NULL, NULL, 'accepted', NULL),
	('edeb1edd-ed1c-406b-b019-39ed17ec7f71', 'f29945d6-05c5-49f7-a507-b5eb293282b2', 'b3a787e2-dfd3-495e-9da6-e6568e11fa32', NULL, NULL, NULL, 'accepted', NULL);


--
-- Data for Name: identity_resolution; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: organisation_group_member_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- PostgreSQL database dump complete
--

\unrestrict vV7SIPHqe3IP8oF7QewK6ZPWSv1Huzw5mu8ScOAhh1Gg8K0h3daMKbDEb57cGxD

