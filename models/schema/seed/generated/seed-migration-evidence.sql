--
-- PostgreSQL database dump
--

\restrict 5eLGZZyocbO3UVCoPNlcfLdIq6aOLZot2RO78KXZs5mbfNgeiFhVXdJCKQVIKFo

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
	('92c138f5-25da-4d05-b30d-1a7dcdfa2316', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 17:47:05.604861+01', '2026-10-01 17:47:05.604861+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('d29c542d-f5a7-486a-ae71-632a41b76a03', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 17:47:05.932128+01', '2026-10-01 17:47:05.932128+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('37f24415-756d-41ca-9344-1be0c7274ca4', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 17:47:06.320665+01', '2026-10-01 17:47:06.320665+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('d42878a0-86ba-4323-a9d5-d5f0aa3e4916', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 17:47:06.595463+01', '2026-10-01 17:47:06.595463+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('8a9165db-e6a6-44c7-a9f7-641aa3c1ecda', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 17:47:07.03091+01', '2026-10-01 17:47:07.03091+01', 'completed', 'academy-trust-responsibility-v1', NULL),
	('aeae4e17-cf37-4a37-bc97-be96bc6562bc', 'mini-migration', 'GIAS BAU', 'local BAU SQL Server', NULL, '2026-10-01 17:47:07.371282+01', '2026-10-01 17:47:07.371282+01', 'completed', 'academy-trust-responsibility-v1', NULL);


--
-- Data for Name: source_snapshot; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_snapshot (source_snapshot_id, migration_run_id, source_system, source_database, snapshot_date, extract_name, created_at) VALUES
	('0b5dfe6e-de24-458f-a346-b8121bf5dd73', '92c138f5-25da-4d05-b30d-1a7dcdfa2316', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 17:47:05.604861+01'),
	('e1b49211-83f6-44a1-b821-05974d242c85', 'd29c542d-f5a7-486a-ae71-632a41b76a03', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 17:47:05.932128+01'),
	('b668b05f-1788-4419-aaee-0b4484aa1fa1', '37f24415-756d-41ca-9344-1be0c7274ca4', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 17:47:06.320665+01'),
	('f54f4d3d-809d-437a-b884-07bdd6f93bd1', 'd42878a0-86ba-4323-a9d5-d5f0aa3e4916', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 17:47:06.595463+01'),
	('8726ffce-06e8-4a04-bd51-ea80a887e015', '8a9165db-e6a6-44c7-a9f7-641aa3c1ecda', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 17:47:07.03091+01'),
	('7142e8e0-aaf0-428c-b880-1a7084c42e86', 'aeae4e17-cf37-4a37-bc97-be96bc6562bc', 'GIAS BAU', 'local BAU SQL Server', NULL, 'academy-trust-responsibility-fixture', '2026-10-01 17:47:07.371282+01');


--
-- Data for Name: source_record; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.source_record (source_record_id, source_snapshot_id, source_table, source_key, source_group_id, source_urn, source_row_hash) VALUES
	('3025c1e6-13db-489f-bc6d-f3ebb04a3921', '0b5dfe6e-de24-458f-a346-b8121bf5dd73', 'dbo.EstablishmentGroup/GroupLink', '2777:136102', '2777', 136102, NULL),
	('a25d10cd-ad0d-4d5c-871c-2c9690b65099', 'e1b49211-83f6-44a1-b821-05974d242c85', 'dbo.EstablishmentGroup/GroupLink', '2779:136102', '2779', 136102, NULL),
	('155a5282-6684-435c-a6b9-7b510a3df753', 'b668b05f-1788-4419-aaee-0b4484aa1fa1', 'dbo.EstablishmentGroup/GroupLink', '4949:136102', '4949', 136102, NULL),
	('1686a2cf-e6a0-4cce-9a90-22a73aa724eb', 'f54f4d3d-809d-437a-b884-07bdd6f93bd1', 'dbo.EstablishmentGroup/GroupLink', '23869:134314', '23869', 134314, NULL),
	('5782e63f-ca3c-47df-a526-5f0f2ce89468', '8726ffce-06e8-4a04-bd51-ea80a887e015', 'dbo.EstablishmentGroup/GroupLink', '4737:134314', '4737', 134314, NULL),
	('5f6a17fa-3583-4488-8f93-16b2346150ca', '7142e8e0-aaf0-428c-b880-1a7084c42e86', 'dbo.EstablishmentGroup/GroupLink', '2914:134314', '2914', 134314, NULL);


--
-- Data for Name: establishment_party_role_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_party_role_evidence (evidence_id, establishment_party_role_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('fedcf633-8d44-4951-b5e7-031b9c126b6e', 'f34b48f4-0210-44c2-a313-74586ede811a', '3025c1e6-13db-489f-bc6d-f3ebb04a3921', NULL, NULL, NULL, 'accepted', NULL),
	('f458679b-50a1-4d3c-aa34-83ac11f4f483', 'f34b48f4-0210-44c2-a313-74586ede811a', 'a25d10cd-ad0d-4d5c-871c-2c9690b65099', NULL, NULL, NULL, 'accepted', NULL),
	('71f4f89e-2cd8-414c-a012-3e69c05b6dd9', 'd1ad4a5a-5824-4011-bf02-25ebcee020e7', '155a5282-6684-435c-a6b9-7b510a3df753', NULL, NULL, NULL, 'accepted', NULL),
	('9bb8f216-e6f3-49c9-a148-7a88f9ca0b14', 'a377f958-4a33-4851-9fc5-349e29872091', '1686a2cf-e6a0-4cce-9a90-22a73aa724eb', NULL, NULL, NULL, 'accepted', NULL);


--
-- Data for Name: establishment_responsibility_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--

INSERT INTO migration.establishment_responsibility_evidence (evidence_id, establishment_responsibility_id, source_record_id, first_observed_date, end_date_basis, inference_rule, review_status, notes) VALUES
	('5995189c-3d20-4706-b806-64a69d705451', '81fafaee-c861-47fa-8cca-70801b2088cb', '3025c1e6-13db-489f-bc6d-f3ebb04a3921', NULL, NULL, NULL, 'accepted', NULL),
	('9e347edd-08ca-4618-83e5-8ae64d357f56', 'df579ae4-451b-4329-b6e8-50df5a8ff40e', 'a25d10cd-ad0d-4d5c-871c-2c9690b65099', NULL, NULL, NULL, 'accepted', NULL),
	('329d87d9-2376-433c-9cba-9074abe9aced', '24738d17-a285-484e-ac3d-c041c333354b', '155a5282-6684-435c-a6b9-7b510a3df753', NULL, NULL, NULL, 'accepted', NULL),
	('fb6ef1fa-f7ce-4398-8b58-b9af4edeb835', '9d82949d-c7ff-4db0-ad6f-ac47f4356b67', '1686a2cf-e6a0-4cce-9a90-22a73aa724eb', NULL, NULL, NULL, 'accepted', NULL);


--
-- Data for Name: identity_resolution; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: organisation_group_member_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- PostgreSQL database dump complete
--

\unrestrict 5eLGZZyocbO3UVCoPNlcfLdIq6aOLZot2RO78KXZs5mbfNgeiFhVXdJCKQVIKFo

