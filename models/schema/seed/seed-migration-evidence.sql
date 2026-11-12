--
-- PostgreSQL database dump
--

\restrict nr6Z5Dc8RCVPxhdFUf2n4NFqsQqT80aoUt29Jqt7NqHQM45KjlNRheZcr7CDTs8

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
	('395cdb11-3d1e-4809-a61a-5d58a641be0d', 'establishment-rebuild', 'GIAS BAU', 'gias_bau_test_local', '2026-11-12', '2026-11-12 14:36:03.042587+00', '2026-11-12 14:36:18.765222+00', 'completed', 'establishment-party-responsibility-v2', NULL);


--
-- Data for Name: source_snapshot; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: source_record; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: academy_trust_classification_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: council_reorganisation; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: council_reorganisation_lineage; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: council_replay_observation; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: establishment_party_role_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: establishment_responsibility_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: group_address_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: identity_resolution; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: maintenance_derivation; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: maintenance_source_observation; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: organisation_group_address_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: organisation_group_member_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: person_address_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: proprietor_review; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- Data for Name: proprietor_fact_evidence; Type: TABLE DATA; Schema: migration; Owner: -
--



--
-- PostgreSQL database dump complete
--

\unrestrict nr6Z5Dc8RCVPxhdFUf2n4NFqsQqT80aoUt29Jqt7NqHQM45KjlNRheZcr7CDTs8

