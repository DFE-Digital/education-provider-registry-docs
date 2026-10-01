--
-- PostgreSQL database dump
--

\restrict KfPxPi7HJFZxllg4qKIRbgvpqdYtHKdqvOjMQeP24d7IzqigeFDYoOp5cBQRpU0

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
	('fb095b64-c83d-42e8-99b5-ad0a9af5698b', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 15:28:18.82714+01', '2026-10-01 15:28:18.82714+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('19d6a142-1e92-4ffc-984c-0ac66f2af99b', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 15:28:19.131941+01', '2026-10-01 15:28:19.131941+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('a2fb8380-44eb-46e3-bfc5-da984158375f', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 15:28:19.413536+01', '2026-10-01 15:28:19.413536+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('8503f2bb-6774-49c2-b06e-df3cd6d1bca7', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 15:28:19.762477+01', '2026-10-01 15:28:19.762477+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('7813bf83-61c2-4140-84d8-4bff57a956ba', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 15:28:20.046618+01', '2026-10-01 15:28:20.046618+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('daa10df9-4cea-4850-909d-cd60ba2c04c3', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 15:28:20.401321+01', '2026-10-01 15:28:20.401321+01', 'completed', 'academy-trust-responsibility-v1', NULL);


--
-- Data for Name: source_snapshot; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_snapshot (source_snapshot_id, migration_run_id, source_system, source_database, snapshot_date, extract_name, created_at) VALUES
	('58c7e620-e5ab-4cae-8da6-2da4059941d1', 'fb095b64-c83d-42e8-99b5-ad0a9af5698b', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 15:28:18.82714+01'),
	('7dbdc0bc-3d0c-4ff8-abf4-342872354ad7', '19d6a142-1e92-4ffc-984c-0ac66f2af99b', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 15:28:19.131941+01'),
	('fb1e945d-c83e-47de-856d-ac0decdc34eb', 'a2fb8380-44eb-46e3-bfc5-da984158375f', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 15:28:19.413536+01'),
	('04508329-d351-4ab8-90b5-ec22c1d3d3d0', '8503f2bb-6774-49c2-b06e-df3cd6d1bca7', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 15:28:19.762477+01'),
	('a51b62ab-0911-4ccc-a707-72e44d923db4', '7813bf83-61c2-4140-84d8-4bff57a956ba', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 15:28:20.046618+01'),
	('881978ff-a6b1-4b2d-a7d5-ac95e3dc0035', 'daa10df9-4cea-4850-909d-cd60ba2c04c3', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 15:28:20.401321+01');


--
-- Data for Name: source_record; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_record (source_record_id, source_snapshot_id, source_table, source_key, source_group_id, source_urn, source_row_hash) VALUES
	('e6f97825-b866-43a7-9c1d-26d0a9d3f9dd', '58c7e620-e5ab-4cae-8da6-2da4059941d1', 'dbo.EstablishmentGroup/GroupLink', '2777:136102', '2777', 136102, NULL),
	('2f663ea4-ce34-4573-9fa8-90cf2bb08384', '7dbdc0bc-3d0c-4ff8-abf4-342872354ad7', 'dbo.EstablishmentGroup/GroupLink', '2779:136102', '2779', 136102, NULL),
	('bef5a531-d672-4abb-aae1-634d54ef4fad', 'fb1e945d-c83e-47de-856d-ac0decdc34eb', 'dbo.EstablishmentGroup/GroupLink', '4949:136102', '4949', 136102, NULL),
	('932023f5-3b47-4b8b-9d3c-e3d07b4755bb', '04508329-d351-4ab8-90b5-ec22c1d3d3d0', 'dbo.EstablishmentGroup/GroupLink', '23869:134314', '23869', 134314, NULL),
	('2d905b93-1cfc-49a6-abb2-c978b8040294', 'a51b62ab-0911-4ccc-a707-72e44d923db4', 'dbo.EstablishmentGroup/GroupLink', '4737:134314', '4737', 134314, NULL),
	('f7c88f85-576b-4b0f-be60-6546c1331f79', '881978ff-a6b1-4b2d-a7d5-ac95e3dc0035', 'dbo.EstablishmentGroup/GroupLink', '2914:134314', '2914', 134314, NULL);


--
-- Data for Name: establishment_party_role_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_party_role_evidence (evidence_id, establishment_party_role_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('de6b15c3-8069-4302-a5b3-e1323f7fa1eb', '766717db-7aaa-4c54-938b-298c903e8fb1', 'e6f97825-b866-43a7-9c1d-26d0a9d3f9dd', NULL, NULL, NULL, 'accepted', NULL),
	('8d0e949d-218e-437e-904e-a02602004657', '766717db-7aaa-4c54-938b-298c903e8fb1', '2f663ea4-ce34-4573-9fa8-90cf2bb08384', NULL, NULL, NULL, 'accepted', NULL),
	('34f24703-d894-4882-8cf8-765b91a86c4b', 'f97ea03c-c053-4ec5-914d-90e6d7e7f0a5', 'bef5a531-d672-4abb-aae1-634d54ef4fad', NULL, NULL, NULL, 'accepted', NULL),
	('e2a303c3-bc0d-4379-9974-378e512bdd9e', '023fa782-aa07-40c1-8100-8761c28a3e9c', '932023f5-3b47-4b8b-9d3c-e3d07b4755bb', NULL, NULL, NULL, 'accepted', NULL);


--
-- Data for Name: establishment_responsibility_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_responsibility_evidence (evidence_id, establishment_responsibility_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('9a9755d2-aae8-4148-bbaf-9425a5a66d02', '3f158594-5513-459b-91a1-4334f53236e1', 'e6f97825-b866-43a7-9c1d-26d0a9d3f9dd', NULL, NULL, NULL, 'accepted', NULL),
	('6b9647df-7050-48a4-b664-0ab1f9019f66', 'bb8ed067-4cbd-4d95-914f-4c420503e3a4', '2f663ea4-ce34-4573-9fa8-90cf2bb08384', NULL, NULL, NULL, 'accepted', NULL),
	('30e2e729-b62e-42ce-8ecd-294927d23e6f', '85817847-84ff-4d2f-aeb0-4e18a7b74a8d', 'bef5a531-d672-4abb-aae1-634d54ef4fad', NULL, NULL, NULL, 'accepted', NULL),
	('61b7d74d-cfbf-433f-8188-1acfb8e64eb6', '4de808bc-9be4-45f1-ad79-a58c8fbe5bba', '932023f5-3b47-4b8b-9d3c-e3d07b4755bb', NULL, NULL, NULL, 'accepted', NULL);


--
-- Data for Name: identity_resolution; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: organisation_group_member_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- PostgreSQL database dump complete
--

\unrestrict KfPxPi7HJFZxllg4qKIRbgvpqdYtHKdqvOjMQeP24d7IzqigeFDYoOp5cBQRpU0

