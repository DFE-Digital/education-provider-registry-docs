--
-- PostgreSQL database dump
--

\restrict LffoXpXwQYo7FdFMejRAdDnYrVuWWmoMOuxutdZKzRQHwunIzfAYuvsgMASGOQn

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
-- Data for Name: legal_entity; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.legal_entity (legal_entity_id, name, legal_entity_type_id, charity_status_id, incorporation_date, dissolution_date) VALUES
	('e1a6327a-d009-4188-9e1b-7024a720b88f', 'City of London Corporation', 9, NULL, NULL, NULL),
	('b086cfb6-8e69-41bd-aabb-7c8280e0303c', 'London Borough of Camden', 9, NULL, NULL, NULL),
	('b59eda0d-f6e0-4ad9-8b0b-ac627e4025aa', 'Royal Borough of Greenwich', 9, NULL, NULL, NULL),
	('81c75ae1-8301-4525-a050-6955bdfa4779', 'London Borough of Hackney', 9, NULL, NULL, NULL),
	('287bdf12-6aef-4594-a075-78925c23bba6', 'London Borough of Hammersmith & Fulham', 9, NULL, NULL, NULL),
	('541af47a-2e3e-4d54-a5d7-6cea57348f64', 'London Borough of Islington', 9, NULL, NULL, NULL),
	('1a64cadb-fa10-49fe-bb99-3d2bfcfa0eee', 'Royal Borough of Kensington and Chelsea', 9, NULL, NULL, NULL),
	('f968439b-71db-4cb2-b232-1e7dbd92ecd1', 'London Borough of Lambeth', 9, NULL, NULL, NULL),
	('ae59b13a-8127-4417-83e4-9f7b677bf46f', 'London Borough of Lewisham', 9, NULL, NULL, NULL),
	('ee74e081-08c0-4a4b-b835-a777a0bf3da2', 'London Borough of Southwark', 9, NULL, NULL, NULL),
	('05bbf16c-664d-43de-82d9-127106fb01bf', 'London Borough of Tower Hamlets', 9, NULL, NULL, NULL),
	('fba0b2b9-b081-4a9a-9998-1f288138b0f4', 'London Borough of Wandsworth', 9, NULL, NULL, NULL),
	('a4f836d5-158f-4643-8ad1-55820a6d02f3', 'City of Westminster', 9, NULL, NULL, NULL),
	('2a01be7d-4171-45f3-982d-e6f4c7fb6d08', 'London Borough of Barking and Dagenham', 9, NULL, NULL, NULL),
	('b418bcfb-b7a1-4e06-8fc8-abefb368e2a8', 'London Borough of Barnet', 9, NULL, NULL, NULL),
	('c0f0dc1e-240a-44e0-a0d1-85557ea41bd4', 'London Borough of Bexley', 9, NULL, NULL, NULL),
	('a36e0503-0257-49c0-b2fe-fede9f990140', 'London Borough of Brent', 9, NULL, NULL, NULL),
	('d292b5da-c2c8-439f-943a-b77519e48a06', 'London Borough of Bromley', 9, NULL, NULL, NULL),
	('5a851616-ec93-498a-aed8-b9052dd78b2f', 'London Borough of Croydon', 9, NULL, NULL, NULL),
	('3b1ce9a8-2ab4-4215-a778-b95a5938afd5', 'London Borough of Ealing', 9, NULL, NULL, NULL),
	('af753f8e-2a47-466d-8fa2-1489b8ad9823', 'London Borough of Enfield', 9, NULL, NULL, NULL),
	('d34624f7-95b5-4629-acf9-7aa95160f7ba', 'London Borough of Haringey', 9, NULL, NULL, NULL),
	('97310377-f4c9-45cd-9acc-22f14a165640', 'London Borough of Harrow', 9, NULL, NULL, NULL),
	('682b27b6-fc2e-4734-ba33-ab96083bad02', 'London Borough of Havering', 9, NULL, NULL, NULL),
	('87b6ead5-d37e-48e1-a944-25b3364a3b13', 'London Borough of Hillingdon', 9, NULL, NULL, NULL),
	('d6d73dea-10eb-4b24-9cd9-e2ac8ade8e11', 'London Borough of Hounslow', 9, NULL, NULL, NULL),
	('f019d94a-2daa-4c8d-a45f-bf9e70cc0401', 'Royal Borough of Kingston upon Thames', 9, NULL, NULL, NULL),
	('6df12011-91bc-4df4-95cd-57f7a691cae9', 'London Borough of Merton', 9, NULL, NULL, NULL),
	('e55fed18-fbb5-4218-a6e2-46fefd8999a9', 'London Borough of Newham', 9, NULL, NULL, NULL),
	('97561530-a844-49d5-b345-235c69c66ae4', 'London Borough of Redbridge', 9, NULL, NULL, NULL),
	('90ddde1c-9c1c-4705-8495-c38da5c137f5', 'London Borough of Richmond upon Thames', 9, NULL, NULL, NULL),
	('eb5b0b5c-a949-4f27-87e2-47c2b20c2ab7', 'London Borough of Sutton', 9, NULL, NULL, NULL),
	('d2d454cd-322a-4885-adf8-5f5b1971c476', 'London Borough of Waltham Forest', 9, NULL, NULL, NULL),
	('942acd8c-ef18-4af1-8d40-0dadd1eadf5b', 'Birmingham City Council', 9, NULL, NULL, NULL),
	('85561b92-9620-44b2-9f12-8a272704daa9', 'Coventry City Council', 9, NULL, NULL, NULL),
	('bdb3bf08-b740-4014-bb5c-70f05595b43b', 'Dudley Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('bc6bda39-2166-4720-b426-7cf7e96085c4', 'Sandwell Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('ff00d301-1407-441c-8ec5-65271bf391ba', 'Solihull Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('04878a1d-d789-4d14-befd-70cbd533c7b3', 'Walsall Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('0e11f0eb-5761-406f-b9c8-fd01a4316870', 'City of Wolverhampton Council', 9, NULL, NULL, NULL),
	('fa3df49f-fa1f-4032-b8ec-d0f263dbee59', 'Knowsley Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('41193d0a-bf29-494a-aaaf-05ac1ede2322', 'Liverpool City Council', 9, NULL, NULL, NULL),
	('33006a16-04f2-41a2-af19-d8a2876d6f04', 'St Helens Council', 9, NULL, NULL, NULL),
	('b4e1b686-613c-4013-8c3e-39ccebc94d37', 'Sefton Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('e740c0fb-4283-437f-bda2-52aafd1a7e6a', 'Wirral Borough Council', 9, NULL, NULL, NULL),
	('e374c4f2-c99b-49a4-9449-ea94ecde7601', 'Bolton Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('49707b1a-f355-43aa-a184-e2fce887d9c9', 'Bury Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('56835c41-66a2-4764-b14b-92bb66468d42', 'Manchester City Council', 9, NULL, NULL, NULL),
	('017b9add-c648-49b7-a4c7-65f7de7c6c25', 'Oldham Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('c87b6099-8be6-45c7-9d5c-433bcea32525', 'Rochdale Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('446693e4-33a8-411d-8979-0d79932e7bc4', 'Salford City Council', 9, NULL, NULL, NULL),
	('5ae43dea-8870-4d5e-ad96-f5b307ad787a', 'Stockport Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('077d3abb-b97a-4cba-8774-a5858ee13eba', 'Tameside Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('b4503845-d24f-4dbc-a6b9-751293682f6f', 'Trafford Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('cda5f0fb-4753-4518-928e-0e5a0eff3271', 'Wigan Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('b502aae0-349b-404c-9752-c36e48ad9818', 'Barnsley Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('03e9b947-740c-413f-8245-823e7cc3b19b', 'Doncaster Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('a9f081bf-24a9-45f0-90e9-8ae9b823214e', 'Rotherham Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('2db035a6-7e30-42b0-b20e-94964aec2dee', 'Sheffield City Council', 9, NULL, NULL, NULL),
	('5013072c-6e76-4a09-af30-90af79265c26', 'City of Bradford Metropolitan District Council', 9, NULL, NULL, NULL),
	('e5f200f3-b862-4aab-8bc0-3adc87d75171', 'Calderdale Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('fc67db5d-45ed-4644-a507-a40ecd9994b2', 'Kirklees Council', 9, NULL, NULL, NULL),
	('a7feafff-a347-4c85-8656-169875a689ad', 'Leeds City Council', 9, NULL, NULL, NULL),
	('9b0fb1fb-1c56-4457-8af3-df326b9f98e6', 'Wakefield Metropolitan District Council', 9, NULL, NULL, NULL),
	('06c0ed0d-3e50-44af-87fd-974211357055', 'Gateshead Metropolitan Borough Council', 9, NULL, NULL, NULL),
	('c8c3ec0b-e506-4584-83b4-8bc4dc3ff171', 'Newcastle City Council', 9, NULL, NULL, NULL),
	('5034f523-bde4-4997-b61f-30853654a477', 'North Tyneside Council', 9, NULL, NULL, NULL),
	('a6ec94a0-0cea-404e-ba9a-09c01b9f11e8', 'South Tyneside Council', 9, NULL, NULL, NULL),
	('89b5e4f6-95eb-4a8f-854c-17c91059db2d', 'Sunderland City Council', 9, NULL, NULL, NULL),
	('673cbcfa-6f5b-4fab-b24c-7cf3009e88fc', 'Council of the Isles of Scilly', 9, NULL, NULL, NULL),
	('db6491ce-a480-46c0-ae1a-f91303f671e8', 'Isle of Anglesey County Council', 9, NULL, NULL, NULL),
	('dea03165-a419-45c1-bbe8-894ab6602408', 'Gwynedd Council', 9, NULL, NULL, NULL),
	('f1006fd8-7b85-42c7-bdca-469cc97fcba4', 'Conwy County Borough Council', 9, NULL, NULL, NULL),
	('3309c091-6209-4bd2-81f3-e953e66624cb', 'Denbighshire County Council', 9, NULL, NULL, NULL),
	('f719db8a-a59c-4839-9eb8-4113ec0f5d0c', 'Flintshire County Council', 9, NULL, NULL, NULL),
	('e0400e07-fa7f-46c5-bf78-d5bb2475f3ac', 'Wrexham County Borough Council', 9, NULL, NULL, NULL),
	('332c38fc-04d0-4f39-bc8e-b0f72c76bd43', 'Powys County Council', 9, NULL, NULL, NULL),
	('187c7041-14d8-4051-a649-d77ff5b10904', 'Ceredigion County Council', 9, NULL, NULL, NULL),
	('5ff98f3d-075e-4f15-a044-479c7d59d299', 'Pembrokeshire County Council', 9, NULL, NULL, NULL),
	('44258f9e-c5ca-4f47-826e-ea4448dc7b39', 'Carmarthenshire County Council', 9, NULL, NULL, NULL),
	('7c636518-736e-4660-a6bf-38cfcf2c9f39', 'Swansea Council', 9, NULL, NULL, NULL),
	('a03546d3-1adf-445e-b96e-9a25fc2b92f9', 'Neath Port Talbot County Borough Council', 9, NULL, NULL, NULL),
	('4dfd7688-147b-47b3-b883-e41426f22414', 'Bridgend County Borough Council', 9, NULL, NULL, NULL),
	('8b0462a5-9181-4529-8769-aca7ba890465', 'Vale of Glamorgan Council', 9, NULL, NULL, NULL),
	('cc3e154a-d2cb-4d25-9c3a-707887952b9b', 'Rhondda Cynon Taf County Borough Council', 9, NULL, NULL, NULL),
	('4f8da841-6ab3-46e6-a645-0847978e78e2', 'Merthyr Tydfil County Borough Council', 9, NULL, NULL, NULL),
	('e1de73cc-6c38-46d9-b9b9-0121f2a0bdf7', 'Caerphilly County Borough Council', 9, NULL, NULL, NULL),
	('2d4707c3-cf6a-4990-8606-bf1c614e1339', 'Blaenau Gwent County Borough Council', 9, NULL, NULL, NULL),
	('980fb43b-e022-4c74-974f-491a624704e5', 'Torfaen County Borough Council', 9, NULL, NULL, NULL),
	('0e8b54ba-0e91-4a63-8f9d-15a3720a4263', 'Monmouthshire County Council', 9, NULL, NULL, NULL),
	('cc753e92-609b-4670-b990-9e54bd98759a', 'Newport City Council', 9, NULL, NULL, NULL),
	('3f20db79-36c9-4313-a9af-1420703adb73', 'County Council of the City and County of Cardiff', 9, NULL, NULL, NULL),
	('2753d56d-7daa-4111-bc63-f5b7470035bb', 'Bath and North East Somerset Council', 9, NULL, NULL, NULL),
	('deaf4026-684d-452c-b80c-ed5a9db7ade2', 'Bristol City Council', 9, NULL, NULL, NULL),
	('51fadc3a-a181-43de-b550-52aa96da3e9c', 'North Somerset Council', 9, NULL, NULL, NULL),
	('c155281c-f98b-41bc-bb1a-1c2d8b044491', 'South Gloucestershire Council', 9, NULL, NULL, NULL),
	('e7bf23da-dfb1-464a-843c-24a483893614', 'Hartlepool Borough Council', 9, NULL, NULL, NULL),
	('7fd1ea14-0082-4dc3-b57b-b0b18b83776d', 'Middlesbrough Borough Council', 9, NULL, NULL, NULL),
	('4c5b6bf7-ffb5-4cf9-ac1f-874721ea2a03', 'Redcar and Cleveland Borough Council', 9, NULL, NULL, NULL),
	('a2e945f6-5f41-45b0-830b-f8c31901f5f5', 'Stockton-on-Tees Borough Council', 9, NULL, NULL, NULL),
	('77a62ab9-ad2a-4a1e-9afe-4ffd731a0439', 'Hull City Council', 9, NULL, NULL, NULL),
	('fa59d5bd-98f6-4a50-8082-2e7151bb13b8', 'East Riding of Yorkshire Council', 9, NULL, NULL, NULL),
	('26eeaff9-c310-43db-ad82-4c0bfda460b8', 'North East Lincolnshire Council', 9, NULL, NULL, NULL),
	('c2911c7b-31b4-44d7-8eab-2c65fcec2d92', 'North Lincolnshire Council', 9, NULL, NULL, NULL),
	('fb889851-0b87-4fce-b606-bf250ef492a3', 'City of York Council', 9, NULL, NULL, NULL),
	('2cc7068d-e2c1-4f89-bcf7-d254640fccce', 'Luton Borough Council', 9, NULL, NULL, NULL),
	('3802ccd1-0803-4817-bfc8-5188ccbf06e2', 'Bedford Borough Council', 9, NULL, NULL, NULL),
	('6fa0fa20-9beb-447f-bb7e-c55064758477', 'Central Bedfordshire Council', 9, NULL, NULL, NULL),
	('e4636164-5024-41ae-a628-fdda61a7ce3f', 'Buckinghamshire Council', 9, NULL, NULL, NULL),
	('67b5f616-39fe-4b31-b116-924192c6859c', 'Milton Keynes City Council', 9, NULL, NULL, NULL),
	('0604190a-2422-4c72-90b7-5684714a59ac', 'Derby City Council', 9, NULL, NULL, NULL),
	('b522b97d-8d52-4b79-bf36-bf671af9336a', 'Borough of Poole', 9, NULL, NULL, '2019-04-01'),
	('2f9a996e-ad57-4f99-8f3e-2ce482a1927f', 'Bournemouth Borough Council', 9, NULL, NULL, '2019-04-01'),
	('d5606470-d7c8-4ba5-9756-7a9895ebc1fd', 'Dorset Council', 9, NULL, NULL, NULL),
	('339df911-4d26-4c96-9952-39e09d8d3e16', 'Bournemouth, Christchurch and Poole Council', 9, NULL, NULL, NULL),
	('bbeb4921-d158-41b8-bc3f-cb69e816e97a', 'Darlington Borough Council', 9, NULL, NULL, NULL),
	('b28aa95b-78f3-43b0-88cb-eb3059f8d6e9', 'Brighton and Hove City Council', 9, NULL, NULL, NULL),
	('025bb820-d1f3-4453-86b8-9f38b5215eee', 'Portsmouth City Council', 9, NULL, NULL, NULL),
	('93ae56c8-97e3-4329-aa89-fb1aeb55b97d', 'Southampton City Council', 9, NULL, NULL, NULL),
	('975790b4-4ee9-4441-a221-0542a7643960', 'Leicester City Council', 9, NULL, NULL, NULL),
	('cc9bd538-c4e9-4d85-bf7b-71f1df6edc23', 'Rutland County Council', 9, NULL, NULL, NULL),
	('78ccc4b3-472c-4e62-9d53-9bded5d55fe3', 'Stoke-on-Trent City Council', 9, NULL, NULL, NULL),
	('b1de0c81-1379-4d63-809d-ff0776e9290a', 'Swindon Borough Council', 9, NULL, NULL, NULL),
	('f23d827d-4352-4a1e-ae6c-29d10933bec9', 'Bracknell Forest Council', 9, NULL, NULL, NULL),
	('9b0cbf0f-1631-4130-a947-614ee98dc9e0', 'Royal Borough of Windsor and Maidenhead', 9, NULL, NULL, NULL),
	('b36730b2-e5cb-4c99-8f59-735407239472', 'West Berkshire Council', 9, NULL, NULL, NULL),
	('fab48b2f-1c2e-4ced-a086-c500ac4df2d5', 'Reading Borough Council', 9, NULL, NULL, NULL),
	('cdd84a97-ddf2-4fbb-a7f2-d18b16870e62', 'Slough Borough Council', 9, NULL, NULL, NULL),
	('2ac7c2b6-53da-440a-a313-41c78eb35ad6', 'Wokingham Borough Council', 9, NULL, NULL, NULL),
	('b952d053-4fe3-4a17-bb21-8c1578788b48', 'Peterborough City Council', 9, NULL, NULL, NULL),
	('de79e58e-3465-45fa-8168-5f9f1ad00232', 'Halton Borough Council', 9, NULL, NULL, NULL),
	('2252b68e-9ecd-4199-bd4f-ba1961a25fc5', 'Warrington Borough Council', 9, NULL, NULL, NULL),
	('5827756d-86e3-4de5-8469-3f283f7720c4', 'Plymouth City Council', 9, NULL, NULL, NULL),
	('ef858f6b-3d2d-4d2a-a458-6e855b6aca27', 'Torbay Council', 9, NULL, NULL, NULL),
	('b360b238-6c52-4832-9043-6233078322b2', 'Southend-on-Sea Borough Council', 9, NULL, NULL, NULL),
	('324b4c97-a6f7-42b1-a0bb-691448804347', 'Thurrock Council', 9, NULL, NULL, NULL),
	('4dfdecda-ac8c-4253-abce-0354105dcd9a', 'Herefordshire Council', 9, NULL, NULL, NULL),
	('49d316d6-6cc0-45f3-a869-8380cea33cf5', 'Worcestershire County Council', 9, NULL, NULL, NULL),
	('705c1c08-2b8d-48fb-9fae-52ee96575424', 'Medway Council', 9, NULL, NULL, NULL),
	('bc6f073b-9831-466b-8488-b97fbf19f2b4', 'Blackburn with Darwen Borough Council', 9, NULL, NULL, NULL),
	('f8e65d35-b2db-4c0c-9f32-9069cf5525d0', 'Blackpool Borough Council', 9, NULL, NULL, NULL),
	('1f7e5cff-981d-4a19-b175-7976651532a0', 'Nottingham City Council', 9, NULL, NULL, NULL),
	('4c61a1bf-474a-4530-9e9b-783f74eef813', 'Telford & Wrekin Council', 9, NULL, NULL, NULL),
	('6f9bc24c-f6ca-4cbe-9946-8eeb13fc4884', 'Cheshire East Council', 9, NULL, NULL, NULL),
	('c6224d1d-e1dd-44f2-b9b4-79c6b57aab94', 'Cheshire West and Chester Council', 9, NULL, NULL, NULL),
	('f8cd82a7-4c45-483b-9ba6-75d46fff8ab6', 'Avon County Council', 9, NULL, NULL, '1996-04-01'),
	('f36d53bd-7d85-4040-af96-d22cff0ef708', 'Bedfordshire County Council', 9, NULL, NULL, '2009-04-01'),
	('ea046f10-de23-4dda-b3bf-2ca12e876bf2', 'Berkshire County Council', 9, NULL, NULL, '1998-04-01'),
	('5b5721c4-9f88-44cb-9302-e6130e8ed6e6', 'Buckinghamshire County Council', 9, NULL, NULL, '2020-04-01'),
	('bad2d713-bd8e-4c56-9435-ac404e51109a', 'Cambridgeshire County Council', 9, NULL, NULL, NULL),
	('fcf0f52a-1c8a-4090-a361-bcebfe4f6986', 'Cheshire County Council', 9, NULL, NULL, '2009-04-01'),
	('3944a193-a6f9-4a9a-aad6-219c83ff71ff', 'Cleveland County Council', 9, NULL, NULL, '1996-04-01'),
	('6c429195-ac5d-4622-843c-fe13aedbc0e0', 'Cornwall Council', 9, NULL, NULL, NULL),
	('052e2cf5-ebd4-4a10-af22-01dd41afe5c7', 'Cumbria County Council', 9, NULL, NULL, '2023-04-01'),
	('00081acf-dd3a-41c1-90d9-6be0dda47be2', 'Derbyshire County Council', 9, NULL, NULL, NULL),
	('5fe408d9-fb14-4acf-999d-f8caa9098401', 'Devon County Council', 9, NULL, NULL, NULL),
	('1b00df3e-1b56-4574-9bf9-cfd920c1e468', 'Dorset County Council', 9, NULL, NULL, '2019-04-01'),
	('9bc31c3b-a426-4c3b-aa93-9857e76a029c', 'Durham County Council', 9, NULL, NULL, NULL),
	('22743a4f-933c-4f60-ba3b-514714ce8752', 'East Sussex County Council', 9, NULL, NULL, NULL),
	('d58456a8-eb8a-4d44-bd48-9611fff6b332', 'Essex County Council', 9, NULL, NULL, NULL),
	('c0bab65a-1dda-451f-9012-638ae1078ebe', 'Gloucestershire County Council', 9, NULL, NULL, NULL),
	('e05aa0c3-07e2-45bd-a9ee-fd2e1e7ec3e2', 'Hampshire County Council', 9, NULL, NULL, NULL),
	('dc82f36a-c010-405b-ac23-985fc21c7cb3', 'Hereford and Worcester County Council', 9, NULL, NULL, '1998-04-01'),
	('df867651-16f1-4266-91f9-4509f3a9ac50', 'Hertfordshire County Council', 9, NULL, NULL, NULL),
	('97939759-3e3b-4c4a-a2b4-9ff9ebbc145c', 'Humberside County Council', 9, NULL, NULL, '1996-04-01'),
	('35d541a2-f11c-4778-99e8-4d779bd9da62', 'Isle of Wight Council', 9, NULL, NULL, NULL),
	('4eb78548-efa5-4688-85e2-0d3a01ecd786', 'Kent County Council', 9, NULL, NULL, NULL),
	('bbd501c2-2def-4e0c-b22a-ceb523d5ab56', 'Lancashire County Council', 9, NULL, NULL, NULL),
	('39ef0d98-239c-4f8f-9b5a-d8678df8c398', 'Leicestershire County Council', 9, NULL, NULL, NULL),
	('6b2e2c44-71c7-4ab6-800c-7202af3a9df3', 'Lincolnshire County Council', 9, NULL, NULL, NULL),
	('a95ba826-f1eb-4c64-80a2-9f147d9a4a7f', 'Norfolk County Council', 9, NULL, NULL, NULL),
	('53c392d9-9d44-4c5d-bf03-b2c39df95953', 'North Yorkshire Council', 9, NULL, NULL, NULL),
	('b05840c4-c612-478c-8243-56cc8542886f', 'Northamptonshire County Council', 9, NULL, NULL, '2021-04-01'),
	('de51de93-8ce1-49e2-8740-929dcc6cfccf', 'Northumberland County Council', 9, NULL, NULL, NULL),
	('5fb139ce-a696-4ac2-ba3a-445b361c206a', 'Nottinghamshire County Council', 9, NULL, NULL, NULL),
	('ba306a61-57b7-401a-891a-21302c0debf9', 'Oxfordshire County Council', 9, NULL, NULL, NULL),
	('64f34b7e-3413-4bcf-817a-c8024a243b32', 'Shropshire Council', 9, NULL, NULL, NULL),
	('fbd8faf4-3dbe-4410-81c0-ce0891128d5a', 'Somerset Council', 9, NULL, NULL, NULL),
	('dc951090-305e-42e5-aaa3-5ebccd8ef9f7', 'Staffordshire County Council', 9, NULL, NULL, NULL),
	('1a88dac3-1035-481a-89e9-a53036c47a51', 'Suffolk County Council', 9, NULL, NULL, NULL),
	('30783fab-3dcc-4091-b26a-af8907c0dfd1', 'Surrey County Council', 9, NULL, NULL, NULL),
	('a1e1223a-8442-424c-8b9f-59714899a9b0', 'Warwickshire County Council', 9, NULL, NULL, NULL),
	('cf576508-e284-4938-9c4d-ea3439e92f75', 'West Sussex County Council', 9, NULL, NULL, NULL),
	('5ef4014b-53b5-4283-95d9-02a053ecee56', 'Wiltshire Council', 9, NULL, NULL, NULL),
	('058cc7ab-9391-4aa6-9ba4-93a8cd4e378b', 'North Northamptonshire Council', 9, NULL, NULL, NULL),
	('0e0e4de8-f04e-428a-ab29-ef1bc67cb376', 'West Northamptonshire Council', 9, NULL, NULL, NULL),
	('1c20b22f-1f5c-41d6-a3ff-3696e4522a15', 'Cumberland Council', 9, NULL, NULL, NULL),
	('41272cc4-45fc-499e-bf6c-ffe78ce50b9b', 'Westmorland and Furness Council', 9, NULL, NULL, NULL);


--
-- Data for Name: academy_trust_classification; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: address; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.address (address_id, address_line_1, address_line_2, address_line_3, town, county, postcode) VALUES
	('9d058e43-e447-4ea4-9a48-01c1873f28de', 'obfuscated', NULL, NULL, 'obfuscated', '099', 'NW1 3EX'),
	('7ad6af72-6fbf-4e5c-b06a-83ca3b52ddda', 'obfuscated', 'Milton Ernest', NULL, 'obfuscated', '001', 'MK44 1RF'),
	('a7f9a693-24f9-476a-b94e-0d3a34653298', 'obfuscated', 'Scawsby', NULL, 'obfuscated', '031', 'DN5 7UB');


--
-- Data for Name: establishment; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment (establishment_id, urn, ukprn, establishment_number, name, establishment_type_id, ofsted_link, education_phase_id, further_education_type_id, section_41_approval_status_id, religious_character_id, religious_ethos_id, diocese_id) VALUES
	('7ba6d27f-657c-4108-af37-1485a9a4f719', 100018, 10069172, 2436, 'Netley Primary School & Centre for Autism', 1, 'https://reports.ofsted.gov.uk/search?q=100018', 2, NULL, NULL, NULL, NULL, NULL),
	('dd896e10-d633-45a0-9e84-8ee8c02cccfe', 109613, 10075753, 3023, 'Milton Ernest CofE Primary School', 3, 'https://reports.ofsted.gov.uk/search?q=109613', 2, NULL, NULL, 1, NULL, 'b702a76d-948e-a580-6ffa-366c146b59bd'),
	('0a03bb54-e374-405f-a9fe-bdf57b922b6d', 137603, 10035482, 4033, 'Ridgewood School', 24, 'https://reports.ofsted.gov.uk/search?q=137603', 4, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: capacity_and_pupil_measures; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.capacity_and_pupil_measures (capacity_and_pupil_measures_id, establishment_id, school_capacity, pupil_count, free_school_meal_measure, census_date) VALUES
	('03d6581f-297c-47c6-ab01-886243ecb2d7', '7ba6d27f-657c-4108-af37-1485a9a4f719', 65801, 383, 224, '2026-01-15'),
	('0e52d851-4a4f-456b-880d-810ca7e63426', 'dd896e10-d633-45a0-9e84-8ee8c02cccfe', 63964, 67, 5, '2026-01-15'),
	('002bf884-8ecd-4b55-b5fe-da8b965fe9ee', '0a03bb54-e374-405f-a9fe-bdf57b922b6d', 1512, 1425, 250, '2026-01-15');


--
-- Data for Name: education_admissions_and_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.education_admissions_and_provision (education_admissions_and_provision_id, establishment_id, gender_of_entry_type_id, admissions_policy_id, boarding_provision_id, nursery_provision_id, sixth_form_provision_id, has_special_classes) VALUES
	('023e4af3-ba20-41f7-b874-06ef3284c106', '7ba6d27f-657c-4108-af37-1485a9a4f719', 3, NULL, 1, 1, 2, true),
	('94576653-e7ac-4900-a917-07b8bd43746a', 'dd896e10-d633-45a0-9e84-8ee8c02cccfe', 3, NULL, 1, 2, 2, false),
	('386e52d3-b4fd-403d-a888-ff0febc463c3', '0a03bb54-e374-405f-a9fe-bdf57b922b6d', 3, 1, 1, NULL, 1, true);


--
-- Data for Name: establishment_contact; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_contact (establishment_contact_id, establishment_id, website, telephone_number) VALUES
	('99bf3d07-85b8-4ddf-84a8-2e833fcc071e', '7ba6d27f-657c-4108-af37-1485a9a4f719', 'www.netley.camden.sch.uk/', '111111'),
	('d2f157b4-e13a-4e5f-83e3-8047b8201832', 'dd896e10-d633-45a0-9e84-8ee8c02cccfe', 'www.ewmeschools.org.uk', '111111'),
	('88b26e76-65d0-4696-b90f-6123ae8f1cb4', '0a03bb54-e374-405f-a9fe-bdf57b922b6d', 'http://www.ridgewoodschool.co.uk', '111111');


--
-- Data for Name: establishment_geography; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_geography (establishment_geography_id, establishment_id, local_authority_area_id, government_office_region_id, district_administrative_id, administrative_ward_id, parliamentary_constituency_id, lsoa_id, msoa_id, urban_rural_id) VALUES
	('7b77d2db-4801-45bd-92d3-68ca426ab0ee', '7ba6d27f-657c-4108-af37-1485a9a4f719', '28dbd3a3-9f71-495d-8ed9-d75bf19ff95b', 'b46ffca9-7ef4-4a21-9c02-c7e399a9f684', '0c74622f-16de-4792-a07c-d2f0ccdcc366', '1a1b0d8d-f35d-415a-8d24-fce69ebae63c', '1c49ceef-0d08-4d40-9f48-f7bfeef05096', '9eeac2f6-3f58-4a8a-9101-ddf03c4ea2e3', '0acf90e6-4c36-4cec-a25c-cef40f6359aa', 25),
	('9e02ec1e-409a-49dc-92b5-43155644a33d', 'dd896e10-d633-45a0-9e84-8ee8c02cccfe', 'd56e8587-3e82-48dd-9852-bd2ea24c0739', '002a45eb-77e3-4d99-8c6b-9ecbaf1c5e1b', 'ed0971ae-e3b6-45f4-b23b-89c264ee1dc8', '5330f1fd-9443-47f7-858e-74642febee76', '7de3ca10-d639-443e-81a6-9db8bf438277', '7d7984d1-09d4-4fcf-bcdd-c69d956c9a5d', 'dca3bac2-d3fd-416c-8612-063d9fa48fb5', 23),
	('1fce7581-78e2-494a-a25b-f1ac42c95a7f', '0a03bb54-e374-405f-a9fe-bdf57b922b6d', '5baf3133-0d00-4826-a163-280e2e5215e6', 'd25452ac-b3fb-4dbf-a29f-c0b0c5d89be8', 'ba74b1b2-0811-44af-92eb-2b37675d21b5', 'df2826ca-bcfc-44ff-a665-b5435ac33925', '1423caac-e8d8-4124-858d-82aa331a2ea1', 'be35c08a-aecd-4ac5-b39f-e344527d3a2b', 'f6ad6f75-cc8b-439c-b9ce-c3f139fe2886', 25);


--
-- Data for Name: establishment_lifecycle; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_lifecycle (establishment_lifecycle_id, establishment_id, establishment_status_id, open_date, close_date, reason_establishment_opened_id, reason_establishment_closed_id, last_changed_date) VALUES
	('5667abe4-728b-4937-ad18-e14dfbaba55b', '7ba6d27f-657c-4108-af37-1485a9a4f719', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('8f3484ca-3c62-482f-b871-8effc57d1e30', 'dd896e10-d633-45a0-9e84-8ee8c02cccfe', 1, NULL, NULL, NULL, NULL, '2026-06-23'),
	('3955395f-ffe5-4079-aba1-142d320828b0', '0a03bb54-e374-405f-a9fe-bdf57b922b6d', 1, '2011-11-01', NULL, 10, NULL, '2026-06-23');


--
-- Data for Name: person; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: establishment_party_role; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: establishment_responsibility; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: establishment_sen; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_sen (establishment_sen_id, establishment_id, sen_id) VALUES
	('3d25b198-4b1a-40cd-8b92-65e2c76995c0', '7ba6d27f-657c-4108-af37-1485a9a4f719', 4);


--
-- Data for Name: site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.site (site_id, address_id, site_name, uprn) VALUES
	('75653dca-81f6-4666-8c81-63ee83ec9ec8', '9d058e43-e447-4ea4-9a48-01c1873f28de', NULL, 5172210),
	('f6df935b-cab1-48f9-8f9c-8e7c6c75698b', '7ad6af72-6fbf-4e5c-b06a-83ca3b52ddda', NULL, 100081212588),
	('18568a2b-5411-4c48-b334-adf31aebee02', 'a7f9a693-24f9-476a-b94e-0d3a34653298', NULL, 10006581609);


--
-- Data for Name: establishment_to_site; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.establishment_to_site (establishment_to_site_id, establishment_id, site_id, is_main_site) VALUES
	('ad33f220-faac-438d-9510-df75ce0dd026', '7ba6d27f-657c-4108-af37-1485a9a4f719', '75653dca-81f6-4666-8c81-63ee83ec9ec8', true),
	('8d6232a2-94c6-42bb-aef5-aa8cc0488039', 'dd896e10-d633-45a0-9e84-8ee8c02cccfe', 'f6df935b-cab1-48f9-8f9c-8e7c6c75698b', true),
	('822fbc0a-4e05-4e80-ae86-043cee45c1a6', '0a03bb54-e374-405f-a9fe-bdf57b922b6d', '18568a2b-5411-4c48-b334-adf31aebee02', true);


--
-- Data for Name: organisation_group; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: group_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: legal_entity_address; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: legal_entity_partner; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: legal_entity_sole_trader; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: local_authority_area_council_period; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.local_authority_area_council_period (local_authority_area_council_period_id, local_authority_area_id, legal_entity_id, start_date, end_date, is_current) VALUES
	('22188ad3-5b9e-41e4-8c69-384d892075e6', '297f246b-c4be-4d83-b38e-801e95cd72be', 'e1a6327a-d009-4188-9e1b-7024a720b88f', NULL, NULL, true),
	('9e68bebb-561d-45b5-9404-0c7aa1ae2075', '28dbd3a3-9f71-495d-8ed9-d75bf19ff95b', 'b086cfb6-8e69-41bd-aabb-7c8280e0303c', NULL, NULL, true),
	('7c33384f-61a2-4f35-ac6a-fd4e3395be55', '95684217-d28d-4094-81a6-14a276a8738a', 'b59eda0d-f6e0-4ad9-8b0b-ac627e4025aa', NULL, NULL, true),
	('14177ffc-bb4b-4977-bfa9-baf11f4474c6', '64930f11-0703-4c20-9fcf-c0769c204655', '81c75ae1-8301-4525-a050-6955bdfa4779', NULL, NULL, true),
	('469279e6-c539-45c9-9629-507667ddc8fb', '86e53f34-4016-45ab-8a66-faf6a149ed2d', '287bdf12-6aef-4594-a075-78925c23bba6', NULL, NULL, true),
	('eb7d56e8-a6a2-4b0d-b096-733d749ae302', 'c7df72e0-cee2-4f8c-9c41-122ee9c4f95f', '541af47a-2e3e-4d54-a5d7-6cea57348f64', NULL, NULL, true),
	('3e614576-cd6d-42d1-abe0-c578b7de799f', 'c7ef36dd-fd76-4563-9d31-014447af8c16', '1a64cadb-fa10-49fe-bb99-3d2bfcfa0eee', NULL, NULL, true),
	('31192324-3797-4260-bc32-136bfc85a95a', '5bb95f7f-3b0c-424a-829a-8c6adf97330a', 'f968439b-71db-4cb2-b232-1e7dbd92ecd1', NULL, NULL, true),
	('e4390ff3-3247-46c6-b4bb-f15b8cfbcbe2', '0d7aa581-e954-480e-82a8-603c44c3d834', 'ae59b13a-8127-4417-83e4-9f7b677bf46f', NULL, NULL, true),
	('5678925e-3e64-4ed4-9141-5feb3a3b8424', 'ddac8f27-16bf-4419-8f59-0cbbbf09c929', 'ee74e081-08c0-4a4b-b835-a777a0bf3da2', NULL, NULL, true),
	('4a589292-ea90-4c7d-a346-0fdfd170af7e', 'ff905c18-8842-4ad4-b097-c6f15d6cc037', '05bbf16c-664d-43de-82d9-127106fb01bf', NULL, NULL, true),
	('1e87890c-55e6-412e-a247-51a41821e582', '0260a86b-a82e-46ea-80ce-ab5ee559a275', 'fba0b2b9-b081-4a9a-9998-1f288138b0f4', NULL, NULL, true),
	('c443a31d-cc09-4651-999c-03ffd8ddcafa', '0333fd63-23aa-4f25-9cfa-c0737ce1ff23', 'a4f836d5-158f-4643-8ad1-55820a6d02f3', NULL, NULL, true),
	('4e754ac0-b8bd-4e63-8a85-dbe77b682ff9', '12c33324-71df-44af-9603-24c32618ec48', '2a01be7d-4171-45f3-982d-e6f4c7fb6d08', NULL, NULL, true),
	('262ee09c-094a-48d1-b692-88806f6e0ece', '4fc9f892-7eb2-4498-b0a3-282bdfe78abf', 'b418bcfb-b7a1-4e06-8fc8-abefb368e2a8', NULL, NULL, true),
	('efd5e4d5-83cd-483c-80d2-e77de4b35d1a', '11b8abc2-9f8e-46a1-b9fd-82461e86cc1a', 'c0f0dc1e-240a-44e0-a0d1-85557ea41bd4', NULL, NULL, true),
	('d58aaaa8-f5c4-4331-9e45-8638d2b44051', '4200bf2f-0485-49e6-8dcc-987ab8993964', 'a36e0503-0257-49c0-b2fe-fede9f990140', NULL, NULL, true),
	('28f5227b-7b68-4ec9-b822-b215e0cb5f60', '274b262c-7c52-426b-8b90-99d43f82b71c', 'd292b5da-c2c8-439f-943a-b77519e48a06', NULL, NULL, true),
	('dc2b2db1-f55e-48ed-8d48-a522ac4b7563', 'f6981dbf-2923-46b5-8192-86c263df3202', '5a851616-ec93-498a-aed8-b9052dd78b2f', NULL, NULL, true),
	('c1ddfcec-96d0-489c-a30a-134e65bc21ea', 'a50124b2-93ff-4c67-b4ac-8ce44a6c5c6f', '3b1ce9a8-2ab4-4215-a778-b95a5938afd5', NULL, NULL, true),
	('08b4a0ab-49b8-4807-918f-00427be54afb', '9e42c107-87f1-4181-8686-b72757330b2a', 'af753f8e-2a47-466d-8fa2-1489b8ad9823', NULL, NULL, true),
	('d5cecb12-fff1-4435-a08f-200592751b62', '488b0b24-3dcc-4887-ab9a-5597b7e4e017', 'd34624f7-95b5-4629-acf9-7aa95160f7ba', NULL, NULL, true),
	('9c7e1427-1a32-4d56-8425-debb21ddc5fb', '34ebc980-14e2-4312-a001-62a4c63cca7d', '97310377-f4c9-45cd-9acc-22f14a165640', NULL, NULL, true),
	('87d808b0-7ae0-41bd-8a62-15167a0f5a15', 'f5bcbc88-af40-4d97-aa21-7e1626a8fbd4', '682b27b6-fc2e-4734-ba33-ab96083bad02', NULL, NULL, true),
	('f8c2f78d-35a2-4af7-8ce4-8ffe543ebf32', '544bcbd9-755d-4961-a6ae-3b420a743550', '87b6ead5-d37e-48e1-a944-25b3364a3b13', NULL, NULL, true),
	('a92b12ce-cc1c-4166-a7b0-b05873cb6882', '22022604-e6ff-4dd9-94bc-18394bfadbd7', 'd6d73dea-10eb-4b24-9cd9-e2ac8ade8e11', NULL, NULL, true),
	('3f67a566-78f8-4317-936f-afcb8a9f74e9', '02d4138f-9676-4117-8796-9af46e1913f8', 'f019d94a-2daa-4c8d-a45f-bf9e70cc0401', NULL, NULL, true),
	('70421737-5242-4cd6-ba58-437ae162d24f', '9adc9496-2a92-41e8-9e6b-1d909f466598', '6df12011-91bc-4df4-95cd-57f7a691cae9', NULL, NULL, true),
	('9a27eabf-8fc0-47c3-8cc6-c876b87b5a9f', '3522dafa-e903-4be1-9d32-ef0efab1f5be', 'e55fed18-fbb5-4218-a6e2-46fefd8999a9', NULL, NULL, true),
	('90b2a825-08dc-4286-9f27-c51025a8e460', '6a310340-543a-4026-a4ce-aef3ab0a4f95', '97561530-a844-49d5-b345-235c69c66ae4', NULL, NULL, true),
	('17c34561-0785-44c8-9bdf-a56936b579f6', 'ed0d395b-d5e3-40ac-b5b7-44fec3b1ac26', '90ddde1c-9c1c-4705-8495-c38da5c137f5', NULL, NULL, true),
	('2496caf0-0485-495d-a9a8-ecebfdd7081d', 'ed4ab17d-811a-4afc-8059-519c8d8e6ef7', 'eb5b0b5c-a949-4f27-87e2-47c2b20c2ab7', NULL, NULL, true),
	('8fe6b81f-1e2a-4fc1-8f99-4f01aa521b01', 'c9ddcf36-c8e4-43f0-a971-d1fb6d265081', 'd2d454cd-322a-4885-adf8-5f5b1971c476', NULL, NULL, true),
	('6d7be1de-e582-4379-82b3-52a651b7ca5f', 'd1e1bf4a-a56b-4ebf-8968-2e789878851a', '942acd8c-ef18-4af1-8d40-0dadd1eadf5b', NULL, NULL, true),
	('4f185830-9aef-4b43-8415-713b306d9853', '57110768-0fca-4ac3-a912-0f4fa36e3916', '85561b92-9620-44b2-9f12-8a272704daa9', NULL, NULL, true),
	('b045b40c-f5a3-4259-add7-29203da70b36', '50c32ca4-c250-4d2c-884d-294e1a902033', 'bdb3bf08-b740-4014-bb5c-70f05595b43b', NULL, NULL, true),
	('712f9348-68b6-42c9-a81f-0139d6f9445f', '4bd2654a-0f1f-4b52-9f1d-988d0ab5d7d9', 'bc6bda39-2166-4720-b426-7cf7e96085c4', NULL, NULL, true),
	('eb90577b-fb22-49ad-88ab-450e5b57d4e7', 'f6762993-273f-40d2-a3bc-a34d60d0f1a1', 'ff00d301-1407-441c-8ec5-65271bf391ba', NULL, NULL, true),
	('cf8e81d8-500f-457f-9eac-fdbb3c9b6a97', 'aeb6b1cd-736d-45f2-87bc-515ca86320f6', '04878a1d-d789-4d14-befd-70cbd533c7b3', NULL, NULL, true),
	('202617f6-fffe-4975-b5b0-65b79a20144e', 'b4b6da9d-a2ce-4765-949d-ec5521cdfe53', '0e11f0eb-5761-406f-b9c8-fd01a4316870', NULL, NULL, true),
	('fb3c91af-d4c2-456b-b126-69ce8ec03111', 'a0a735c9-1a80-4ea9-aee9-88310a581204', 'fa3df49f-fa1f-4032-b8ec-d0f263dbee59', NULL, NULL, true),
	('26e9b014-9d16-468f-a0a5-8096f4cb7422', '6fa42e94-a832-4e37-8f51-57413d5ef13d', '41193d0a-bf29-494a-aaaf-05ac1ede2322', NULL, NULL, true),
	('b4cd29cf-805e-4ac3-8ff9-fbfc7e23a0b9', 'bbc67a9f-1d2c-46bc-9b86-6b63c8929185', '33006a16-04f2-41a2-af19-d8a2876d6f04', NULL, NULL, true),
	('5f3810c3-5e7c-4125-bdc7-d010d49bbea9', '57371cb7-f395-4f31-be3a-28402db10127', 'b4e1b686-613c-4013-8c3e-39ccebc94d37', NULL, NULL, true),
	('648d019e-c24f-4d58-9f42-79a0dd1cd961', '49ee5141-f7a6-42dd-b92f-2caa2f4c4605', 'e740c0fb-4283-437f-bda2-52aafd1a7e6a', NULL, NULL, true),
	('1a5c3bda-103c-4f5e-8e68-6ac487ad3377', '14992e23-2b88-44be-97da-ffb6b53ce708', 'e374c4f2-c99b-49a4-9449-ea94ecde7601', NULL, NULL, true),
	('e84bc2bc-f8c2-40a4-80eb-befcf7def6c9', 'f2826687-ca95-408e-b7d1-409c814eed3d', '49707b1a-f355-43aa-a184-e2fce887d9c9', NULL, NULL, true),
	('59ef7cc9-edfc-4102-af49-3bbdc828fcc7', '2a554866-d171-4e7b-91d0-69afe4990e06', '56835c41-66a2-4764-b14b-92bb66468d42', NULL, NULL, true),
	('2752aff9-a48a-4da4-949c-cedb0c55a26a', '8875c587-cda4-4311-857b-7c1d5d04a649', '017b9add-c648-49b7-a4c7-65f7de7c6c25', NULL, NULL, true),
	('44d8139c-192c-41b7-b88a-969a3b67b22a', 'df01645a-8307-4c80-b429-b92882a500db', 'c87b6099-8be6-45c7-9d5c-433bcea32525', NULL, NULL, true),
	('b9549963-6ac0-4eef-a420-1a7f2cf0c986', '5dc61a6a-f00b-4af2-84f5-32fef04aaac5', '446693e4-33a8-411d-8979-0d79932e7bc4', NULL, NULL, true),
	('d96696c2-c6eb-48ad-be85-19c26aa058e9', '37351aa6-5854-4c82-a1ed-d94d396dd304', '5ae43dea-8870-4d5e-ad96-f5b307ad787a', NULL, NULL, true),
	('e91ac3ba-50fc-4274-8392-df2137cea1ef', 'ff9656af-2777-48d5-b6c9-a313e9e8382b', '077d3abb-b97a-4cba-8774-a5858ee13eba', NULL, NULL, true),
	('f818203a-743a-460f-8d73-721ff6a36c68', '3e289993-559f-4f3b-a1e7-3346ff15f1d9', 'b4503845-d24f-4dbc-a6b9-751293682f6f', NULL, NULL, true),
	('ece0f094-d7ac-4c34-97ff-85329f4de924', 'f30ac3c5-fcb1-49ad-882e-da42d87744cd', 'cda5f0fb-4753-4518-928e-0e5a0eff3271', NULL, NULL, true),
	('e25fc786-37bd-4c4b-8227-667a41ff7e0c', '4bf0cee2-cd52-4c2f-8457-8fef463d354b', 'b502aae0-349b-404c-9752-c36e48ad9818', NULL, NULL, true),
	('fd662202-1bbc-45b7-8a5b-0c14701e840a', '5baf3133-0d00-4826-a163-280e2e5215e6', '03e9b947-740c-413f-8245-823e7cc3b19b', NULL, NULL, true),
	('59d67913-b1af-46ef-81ce-d4c7909a5f28', '10e98c4e-6d27-4f5a-9ce8-1be06dcf4265', 'a9f081bf-24a9-45f0-90e9-8ae9b823214e', NULL, NULL, true),
	('c804fab4-f837-4759-b69e-44a03b3e4450', 'bb95a859-46bf-4dd0-998d-9eceeda8e1dc', '2db035a6-7e30-42b0-b20e-94964aec2dee', NULL, NULL, true),
	('f3745ff4-f373-4aae-bcb6-c6fe7d58aec5', '46bc7637-4b7a-40df-a9ef-76130e1a0e2b', '5013072c-6e76-4a09-af30-90af79265c26', NULL, NULL, true),
	('0ce205fe-5ac1-4951-9852-5b25357cfba5', 'dbda6019-bfe1-45e6-a353-dfdcc9051489', 'e5f200f3-b862-4aab-8bc0-3adc87d75171', NULL, NULL, true),
	('46d7f2c5-307a-4ac0-93d2-bbd9a0f7e254', '606ae271-0650-400d-8279-f46ff4506b28', 'fc67db5d-45ed-4644-a507-a40ecd9994b2', NULL, NULL, true),
	('b892c36d-a317-4257-8708-ede11bfa8bc2', '33b596a1-c3c4-4b05-ad04-3bcfb1714f6d', 'a7feafff-a347-4c85-8656-169875a689ad', NULL, NULL, true),
	('103b2f56-c476-4143-b4d3-d7784d6ed825', '81566084-29ae-4a69-b333-7b463f5476d6', '9b0fb1fb-1c56-4457-8af3-df326b9f98e6', NULL, NULL, true),
	('a7ca4080-1a2e-44df-b4a5-be4199f67148', '40698ab0-1996-427c-a6d0-8462b543bb2c', '06c0ed0d-3e50-44af-87fd-974211357055', NULL, NULL, true),
	('37ecaabe-c743-480f-a051-6650e380cfe5', '26daf124-c912-4ca8-8b2f-695887118e53', 'c8c3ec0b-e506-4584-83b4-8bc4dc3ff171', NULL, NULL, true),
	('4de74482-85a3-440c-9c2b-dd50fc09d777', 'ff5dc766-b8e8-467a-a3a4-65bb5f0a59b8', '5034f523-bde4-4997-b61f-30853654a477', NULL, NULL, true),
	('353c36cc-201e-4e5b-9f7a-d1446d65ae51', 'fc5fc93e-7cb3-4266-a24a-a5f94f51bd59', 'a6ec94a0-0cea-404e-ba9a-09c01b9f11e8', NULL, NULL, true),
	('019c049e-2f13-4cf1-9f31-64935bccf3f3', 'ccc05b43-4b3f-4cf1-9449-e419a1014743', '89b5e4f6-95eb-4a8f-854c-17c91059db2d', NULL, NULL, true),
	('32326126-8b2a-4830-b849-d71121f9a26a', '5ab6788b-8469-42af-ab99-40fe0a76a5ca', '673cbcfa-6f5b-4fab-b24c-7cf3009e88fc', NULL, NULL, true),
	('2888063b-d150-45e6-a55b-754acd5d6ad4', '72ffd6f0-6401-4c8a-8288-18048f4ff65e', 'db6491ce-a480-46c0-ae1a-f91303f671e8', NULL, NULL, true),
	('2e14e92a-bd33-475b-bc7d-42221e532d79', '758518fe-7031-4b40-8b6d-b4baf11b8fd3', 'dea03165-a419-45c1-bbe8-894ab6602408', NULL, NULL, true),
	('92ce3418-db11-4135-a7d5-c8d64ba4bea9', '2d6b8a55-19c1-4605-9a53-2421d87554e4', 'f1006fd8-7b85-42c7-bdca-469cc97fcba4', NULL, NULL, true),
	('f95bc2d4-57f9-42e8-8161-4641697e0a2d', '749a781d-d71b-47c4-82ae-428a971804b3', '3309c091-6209-4bd2-81f3-e953e66624cb', NULL, NULL, true),
	('b3d3d143-80d2-42b8-b3ca-795c6c1d670a', 'e565b79e-9d64-4331-98b1-9e47ed3d85c8', 'f719db8a-a59c-4839-9eb8-4113ec0f5d0c', NULL, NULL, true),
	('6f872a7f-8826-40ac-84a6-9ffef846b2d2', 'd2766132-8f55-4caa-81c8-5aa5be25777d', 'e0400e07-fa7f-46c5-bf78-d5bb2475f3ac', NULL, NULL, true),
	('8e8400fa-64dd-414e-8969-92f639ba30b9', 'ae9c0667-6065-4fed-9dc1-ccf0d3cef18a', '332c38fc-04d0-4f39-bc8e-b0f72c76bd43', NULL, NULL, true),
	('63495093-d848-437b-b1df-7da017a80c15', 'afc0b46b-0419-44e4-b2f3-edff9ecdb53e', '187c7041-14d8-4051-a649-d77ff5b10904', NULL, NULL, true),
	('f270b8b7-2eac-4641-8e8b-69f1b3307cdf', '1f4c9001-c615-4912-a559-8ee5cac4b844', '5ff98f3d-075e-4f15-a044-479c7d59d299', NULL, NULL, true),
	('f426e9a9-baeb-4e1e-8a5c-de51c3f1bc05', '898e6884-a0fb-4b0d-af98-8048b2cfd2b2', '44258f9e-c5ca-4f47-826e-ea4448dc7b39', NULL, NULL, true),
	('0c260aed-fb0c-43a0-b68d-6ed812008ce9', '2fcb8c7c-f74b-4e52-b1c8-496eb3244f86', '7c636518-736e-4660-a6bf-38cfcf2c9f39', NULL, NULL, true),
	('f88deb59-12e4-4a3d-98fd-45aae1854712', '753a419b-a8fa-411a-ba3f-dd8f490f8e0f', 'a03546d3-1adf-445e-b96e-9a25fc2b92f9', NULL, NULL, true),
	('3bb3b2ad-e689-406b-9213-5761dec5cb35', '72a8560b-3e0d-4fd8-8cb4-70732b079e35', '4dfd7688-147b-47b3-b883-e41426f22414', NULL, NULL, true),
	('6f997d49-9fe3-4ca3-9766-231075c9ddf4', 'e0a67e95-f7fa-4563-a80e-aaeff564d5f6', '8b0462a5-9181-4529-8769-aca7ba890465', NULL, NULL, true),
	('92de4e00-1b2e-470f-8044-878d7454be08', 'eaae39b4-ffeb-417b-a398-0bd7129fa58f', 'cc3e154a-d2cb-4d25-9c3a-707887952b9b', NULL, NULL, true),
	('a7066660-a749-438f-ba7a-87fbdd3c5e2c', 'c3a241e1-755f-4147-a207-9d12ebdd1767', '4f8da841-6ab3-46e6-a645-0847978e78e2', NULL, NULL, true),
	('9aff9f4e-fbfc-445a-bc2e-6c01ecde4f08', '8e277b70-084c-45a9-a40e-8ce71df0fc78', 'e1de73cc-6c38-46d9-b9b9-0121f2a0bdf7', NULL, NULL, true),
	('93cb8783-9c95-41a0-9ded-f449e6e30280', 'dcc762d7-16af-468b-afae-70068ee94f18', '2d4707c3-cf6a-4990-8606-bf1c614e1339', NULL, NULL, true),
	('b4792b2f-fe25-48e6-bb2f-4d1a2251338e', 'bc8baa0a-9561-40b8-b78d-f76b57f7975e', '980fb43b-e022-4c74-974f-491a624704e5', NULL, NULL, true),
	('30458455-f09a-44e6-bbaa-09b366913204', '8e13fb7f-c58d-4674-bb2d-1a1d0e4ca94a', '0e8b54ba-0e91-4a63-8f9d-15a3720a4263', NULL, NULL, true),
	('0985e368-6f73-4fa2-86e8-23828dcd127e', 'df0ffbd6-1d75-4718-bca3-2f138d8622a3', 'cc753e92-609b-4670-b990-9e54bd98759a', NULL, NULL, true),
	('8f32ee7c-f167-45df-b092-53c6d407847d', '63437b45-4364-4698-a4ba-0bd6f9878155', '3f20db79-36c9-4313-a9af-1420703adb73', NULL, NULL, true),
	('d353f342-21b4-4a00-bf05-e4966f316341', '43cbd80d-af51-4e42-a39f-719222726359', '2753d56d-7daa-4111-bc63-f5b7470035bb', NULL, NULL, true),
	('b9a41bc9-ffc2-41d2-8742-fdfd925a06a0', '19bac563-e045-44e5-b2ac-ccda47da3266', 'deaf4026-684d-452c-b80c-ed5a9db7ade2', NULL, NULL, true),
	('2fc9755d-e1ab-4133-a2af-50abdeb45a77', 'f1809ef7-e0f3-44ae-8bdf-62cea675cc02', '51fadc3a-a181-43de-b550-52aa96da3e9c', NULL, NULL, true),
	('2c5d646e-fe30-4163-a478-45f6dc2a54e3', 'bed19c43-0948-40a4-bfcb-bd381e70a64f', 'c155281c-f98b-41bc-bb1a-1c2d8b044491', NULL, NULL, true),
	('e592c4cb-ab4f-40e8-ac35-448a9cfb9fd4', '465e12fd-1006-467f-b205-440249fc3fdc', 'e7bf23da-dfb1-464a-843c-24a483893614', NULL, NULL, true),
	('9d366fd4-1c26-4e23-af92-cf8a68995a59', 'd9aa31f7-6b69-4840-b614-c7f74787f02e', '7fd1ea14-0082-4dc3-b57b-b0b18b83776d', NULL, NULL, true),
	('376f577b-3932-44c4-b324-2538a701d487', '25bed40b-8451-4384-98e9-cce4aaac570c', '4c5b6bf7-ffb5-4cf9-ac1f-874721ea2a03', NULL, NULL, true),
	('27353d83-6fcf-4966-9747-309b9b97876a', 'c3a933e4-7141-45e4-8ca8-165bd230b95e', 'a2e945f6-5f41-45b0-830b-f8c31901f5f5', NULL, NULL, true),
	('6440ca32-e188-41a4-9ffc-8aa393e85452', '7016c418-0fae-435d-8285-67bd56a200c1', '77a62ab9-ad2a-4a1e-9afe-4ffd731a0439', NULL, NULL, true),
	('cbda95ec-69bf-43c0-87ac-6bf5064f8b4e', '2f929371-fedf-4d76-9e3d-1d3d701e3e09', 'fa59d5bd-98f6-4a50-8082-2e7151bb13b8', NULL, NULL, true),
	('55df8a39-8458-40ad-bac4-9a927044aa6c', '39af1b03-f076-421c-ab77-3e980bc661b2', '26eeaff9-c310-43db-ad82-4c0bfda460b8', NULL, NULL, true),
	('2b4c0cf4-042c-466d-8823-1c3741ecfb54', '8532e3bb-e7b6-4b9b-9bc8-7b0e29bb4d56', 'c2911c7b-31b4-44d7-8eab-2c65fcec2d92', NULL, NULL, true),
	('b7083685-1255-43fb-ad3a-2f01b3a431b9', '4001cf16-ffdd-44cd-bc17-d295b052d255', '53c392d9-9d44-4c5d-bf03-b2c39df95953', NULL, NULL, true),
	('6810a09e-5fc5-40c1-a7ca-05aaf0cabbdd', '5fe556aa-c979-4b1c-b9ed-88fd59947060', 'fb889851-0b87-4fce-b606-bf250ef492a3', NULL, NULL, true),
	('a8d3d3ec-2cb0-450e-9848-57df1b406d62', '4866b1bd-11ca-41b9-9985-cdf970ab8e45', 'f36d53bd-7d85-4040-af96-d22cff0ef708', NULL, '2009-04-01', false),
	('e5000980-c3ee-4f54-a53b-2c3e657271c4', 'beff101f-2000-42bb-8e07-2bdcb261ce7e', '2cc7068d-e2c1-4f89-bcf7-d254640fccce', NULL, NULL, true),
	('09fdab57-6bdc-4b76-be44-6996a39246b3', 'd56e8587-3e82-48dd-9852-bd2ea24c0739', '3802ccd1-0803-4817-bfc8-5188ccbf06e2', '2009-04-01', NULL, true),
	('b39a1c36-9634-4034-9903-e91fad345b9b', 'f3602bc2-9045-4a52-9970-59595c21b050', '6fa0fa20-9beb-447f-bb7e-c55064758477', NULL, NULL, true),
	('78773f8b-e30e-47b5-91ef-6feaa2ffd634', 'c34ea13e-46fe-4b4d-a312-33b0dc00efcb', '5b5721c4-9f88-44cb-9302-e6130e8ed6e6', NULL, '2020-04-01', false),
	('eff9595a-f7e0-4a7c-aca3-b6232f2e02ed', 'c34ea13e-46fe-4b4d-a312-33b0dc00efcb', 'e4636164-5024-41ae-a628-fdda61a7ce3f', '2020-04-01', NULL, true),
	('1cde2a1b-e6a8-4665-b471-a4b7aec68c43', '3b74badf-617e-49ef-8d63-aabfee725780', '67b5f616-39fe-4b31-b116-924192c6859c', NULL, NULL, true),
	('548470ac-50d4-4f0c-975f-6c9275798cdb', 'e852e809-1f39-4fc7-ad35-8f91bae968fe', '00081acf-dd3a-41c1-90d9-6be0dda47be2', NULL, NULL, true),
	('57868f69-4141-409b-8c4c-2b5384f1a1de', '3820ff26-ac6f-400c-9e17-d5616883d219', '0604190a-2422-4c72-90b7-5684714a59ac', NULL, NULL, true),
	('11da55b4-9e64-4f21-8a17-528b83e6fa9a', 'ef39c728-fa62-4bfc-8a4d-47da39533e00', '1b00df3e-1b56-4574-9bf9-cfd920c1e468', NULL, '2019-04-01', false),
	('a1b800b0-c7e9-4fd3-bb64-8b1e3f57fb62', '9fbff034-20f6-4fd7-ac9c-23723b259109', 'b522b97d-8d52-4b79-bf36-bf671af9336a', NULL, '2019-04-01', false),
	('c1b62fc8-9836-4181-8d2b-ababf08a46e6', 'd1bf3470-0b26-4315-ba56-9dbd967a71aa', '2f9a996e-ad57-4f99-8f3e-2ce482a1927f', NULL, '2019-04-01', false),
	('2333dc42-f745-4892-b72c-bae0883ed4d3', 'c70af166-55a3-4e23-b478-c0e35a777c07', 'd5606470-d7c8-4ba5-9756-7a9895ebc1fd', '2019-04-01', NULL, true),
	('1dd7edc3-3734-490d-8c5f-2305b7c2b840', '9fe7b63b-41ca-4d1d-b9c6-819ff6f1abba', '339df911-4d26-4c96-9952-39e09d8d3e16', '2019-04-01', NULL, true),
	('c8bc4723-4f4f-4d73-802a-16f5cda87a95', '6aacea57-4ceb-4d0a-aa10-c173b4680a8e', '9bc31c3b-a426-4c3b-aa93-9857e76a029c', NULL, NULL, true),
	('e8dbda76-869d-4c8b-9f60-8c2b4f9ebf4e', 'a53f0b18-f87e-4c9e-80ab-125f39dda09d', 'bbeb4921-d158-41b8-bc3f-cb69e816e97a', NULL, NULL, true),
	('ad5b991f-3166-45c3-8440-237817c23c79', '307ab953-e458-45f1-a9b0-8a77e748defc', '22743a4f-933c-4f60-ba3b-514714ce8752', NULL, NULL, true),
	('3226060a-b1bd-4b33-b5bb-c37d6a74b56e', '57b58660-c86d-47c3-8ea4-ce5ddd481acf', 'b28aa95b-78f3-43b0-88cb-eb3059f8d6e9', NULL, NULL, true),
	('63e7a326-2131-4ebe-ad69-2ad5c35da478', '1b250be7-2899-49ba-901e-36f49d1232ec', 'e05aa0c3-07e2-45bd-a9ee-fd2e1e7ec3e2', NULL, NULL, true),
	('e8dcf13a-1eed-4c8a-8d44-de4a9b0a6fe0', '0a31b9ab-17d2-4798-8e5f-ff4492aacc70', '025bb820-d1f3-4453-86b8-9f38b5215eee', NULL, NULL, true),
	('e436cf17-735e-4f4f-80f6-e53b7bbb7a82', '93bb5dea-27f6-4bf0-8233-e7927397de7b', '93ae56c8-97e3-4329-aa89-fb1aeb55b97d', NULL, NULL, true),
	('2f7c0c71-4b91-4a50-9f31-304855540b80', 'c3d8abf3-2f04-447c-9782-932eafdab4e4', '39ef0d98-239c-4f8f-9b5a-d8678df8c398', NULL, NULL, true),
	('671507ad-9f02-48c6-9b30-bd72d3fa52b3', '9030641c-4d9c-48a3-88c3-cbba0a40b566', '975790b4-4ee9-4441-a221-0542a7643960', NULL, NULL, true),
	('ca284ee4-f01c-4ccc-af01-c9b82c0ee0c6', 'e6798be3-d54f-4d23-8deb-35e088e71a6c', 'cc9bd538-c4e9-4d85-bf7b-71f1df6edc23', NULL, NULL, true),
	('25079d47-2721-48ae-8a6d-7ea21b48a6c9', 'b9405c3c-f00d-4cf9-a6ff-ee32896c7be5', 'dc951090-305e-42e5-aaa3-5ebccd8ef9f7', NULL, NULL, true),
	('716b95e1-44a7-401b-bbe1-2dc30b7f1b7c', 'bb6f85c2-d140-44f6-a242-f618429165b1', '78ccc4b3-472c-4e62-9d53-9bded5d55fe3', NULL, NULL, true),
	('a4e44a8a-2afa-4e52-ac91-067836ae17ec', '56ab09b5-d9e4-4a45-a7df-89248cd23bd0', '5ef4014b-53b5-4283-95d9-02a053ecee56', NULL, NULL, true),
	('0366605a-b3e3-467b-9599-11f021822c42', 'bfa5b408-ebcd-4ec4-881b-2debf074118e', 'b1de0c81-1379-4d63-809d-ff0776e9290a', NULL, NULL, true),
	('ed622b0c-666a-4b0d-a52a-e5e5f57d9861', '604e6608-4ba9-4c74-a5fe-1f775fe6316f', 'f23d827d-4352-4a1e-ae6c-29d10933bec9', NULL, NULL, true),
	('44e6c3ff-f63f-4b56-bdad-d78241c1c3ca', '23086e0b-b834-438c-b9d1-c14eed9b13b4', '9b0cbf0f-1631-4130-a947-614ee98dc9e0', NULL, NULL, true),
	('539ea0ce-5ae0-4349-9b6f-71882467ff24', '932ea583-4eb6-4cd9-aa2f-748bbc035a9d', 'b36730b2-e5cb-4c99-8f59-735407239472', NULL, NULL, true),
	('85b96f10-f419-4b68-bc9e-b2b5c643886c', '3c18ac69-9840-4503-88c6-93179d4a891d', 'fab48b2f-1c2e-4ced-a086-c500ac4df2d5', NULL, NULL, true),
	('874f6aa5-f574-4495-ae8a-c01eaa399a3f', 'f925737b-dbac-471f-8b9e-52bd6089deb4', 'cdd84a97-ddf2-4fbb-a7f2-d18b16870e62', NULL, NULL, true),
	('6fed8956-f93e-471e-a835-1a8953450dfa', '56be7819-f791-4106-908d-7aba57f8c097', '2ac7c2b6-53da-440a-a313-41c78eb35ad6', NULL, NULL, true),
	('981206c6-877e-42cb-8e44-09fbebc228a1', 'de8d4e14-51b0-4d4d-965a-c303d302656a', 'bad2d713-bd8e-4c56-9435-ac404e51109a', NULL, NULL, true),
	('8fd41e24-a48e-40c9-86ac-a03f650de002', '712c32d7-166b-4bc2-a4d8-169f13e7a4b8', 'b952d053-4fe3-4a17-bb21-8c1578788b48', NULL, NULL, true),
	('101de4f4-4144-4a72-8d93-361ad5ba6746', '22344fcc-37bb-46d5-8e66-ddff85603afe', 'fcf0f52a-1c8a-4090-a361-bcebfe4f6986', NULL, '2009-04-01', false),
	('0b54dba0-5f84-4184-924b-39fc7eea6f0f', 'da5e177b-85dc-44b6-9dd2-9f524934b946', 'de79e58e-3465-45fa-8168-5f9f1ad00232', NULL, NULL, true),
	('82e54c87-1f46-4bfb-a0ed-71dac3ee8583', 'c27b0135-fec8-4f35-a4f3-44144bec2c84', '2252b68e-9ecd-4199-bd4f-ba1961a25fc5', NULL, NULL, true),
	('bdf1bfc4-cb59-4985-b256-6df68e49a351', '626dbd32-b6d3-4fb6-bbf8-f3c3ab72f092', '5fe408d9-fb14-4acf-999d-f8caa9098401', NULL, NULL, true),
	('3850ecda-1881-48f9-ba7c-ac5cc305312b', 'ab2b70cc-6cff-4ed1-ba60-751d1bc7b4fd', '5827756d-86e3-4de5-8469-3f283f7720c4', NULL, NULL, true),
	('605db2e3-79b2-421a-a18f-821c72e41814', 'f9e8bd49-5b60-405e-8233-cfc2e636df84', 'ef858f6b-3d2d-4d2a-a458-6e855b6aca27', NULL, NULL, true),
	('434f6324-e6e4-40d3-9c36-70c209631654', '7b729af0-59de-4240-9774-ac83f069f650', 'd58456a8-eb8a-4d44-bd48-9611fff6b332', NULL, NULL, true),
	('f8c8c376-4f71-4881-84f2-4587668e41b1', 'c3515092-3546-4073-86bf-ef8acb602b26', 'b360b238-6c52-4832-9043-6233078322b2', NULL, NULL, true),
	('bd38cee4-5cf7-470b-a06d-b302def4089d', '4e5774a1-ffb7-417b-94f4-3b592fda1d51', '324b4c97-a6f7-42b1-a0bb-691448804347', NULL, NULL, true),
	('e6641fa5-5535-4fca-b3a8-36afc0983ac1', 'ded54030-eb05-4ab4-b037-8be73417314c', '4dfdecda-ac8c-4253-abce-0354105dcd9a', NULL, NULL, true),
	('46747818-72bd-4e74-b356-ab5dd46cdae5', '2dfcc04f-c608-407d-9290-d22abbca163e', '49d316d6-6cc0-45f3-a869-8380cea33cf5', NULL, NULL, true),
	('3b0bb043-b305-4af7-9334-01ad1265506f', 'b3ada519-7e02-4872-b10f-eb60c941d6b4', '4eb78548-efa5-4688-85e2-0d3a01ecd786', '1998-04-01', NULL, true),
	('178df9b9-e7fb-4c78-b39d-bcfdb281b0c3', '6fe85cc7-45a2-4810-b83a-0bb11395a015', '705c1c08-2b8d-48fb-9fae-52ee96575424', NULL, NULL, true),
	('f1c30044-265f-4e2c-9ba6-65650304d7ad', '60e61478-b50b-45d1-90dd-45bef20365e3', 'bbd501c2-2def-4e0c-b22a-ceb523d5ab56', NULL, NULL, true),
	('2c34847f-71d7-466d-8997-0de95f681d6f', '64899045-cf52-4df0-a706-a5d13d37cb67', 'bc6f073b-9831-466b-8488-b97fbf19f2b4', NULL, NULL, true),
	('13ed281e-ff01-4a96-9967-c38d76cd6ec3', '41816e20-48a2-45d0-80c1-cd781e51a9db', 'f8e65d35-b2db-4c0c-9f32-9069cf5525d0', NULL, NULL, true),
	('551de912-a535-43ae-81b4-46c60ffc7610', '676fda1c-234a-4ce5-80b0-e99eb79abc41', '5fb139ce-a696-4ac2-ba3a-445b361c206a', NULL, NULL, true),
	('4989e1d3-9d5a-4a5e-9309-7db83dc7d08e', '70096b9c-7a86-4d73-b2db-38259c3d74fa', '1f7e5cff-981d-4a19-b175-7976651532a0', NULL, NULL, true),
	('e8f6b81e-4546-48d1-b5f3-325bf5a06808', 'c9f8e683-d75f-4ed5-9e29-a755f892f638', '64f34b7e-3413-4bcf-817a-c8024a243b32', NULL, NULL, true),
	('e91d1599-14ee-46fd-9119-d517749ffcb2', '5a5be3fa-1c78-4860-b0a3-3130baf0bab2', '4c61a1bf-474a-4530-9e9b-783f74eef813', NULL, NULL, true),
	('d677058b-a579-41ce-9bcf-eb56e5d93f3a', '1900d0b6-ddd2-416a-a5ed-89d8f4bacc76', '6f9bc24c-f6ca-4cbe-9946-8eeb13fc4884', '2009-04-01', NULL, true),
	('1a74ed23-94b1-4a4b-9807-1240376d44ef', 'c7b38654-9826-4be9-b659-8dede38994dd', 'c6224d1d-e1dd-44f2-b9b4-79c6b57aab94', '2009-04-01', NULL, true),
	('e9dc2aa7-b28e-45f4-8657-68fb25b6792c', '7e2a92ec-acfa-4078-8eca-85c30da74870', 'f8cd82a7-4c45-483b-9ba6-75d46fff8ab6', NULL, '1996-04-01', false),
	('564c3c83-9bf5-45e2-bf3e-c62cef6ac6d4', '4ddf1dc0-cbc8-4d06-9c25-91a0a47c6c4a', 'f36d53bd-7d85-4040-af96-d22cff0ef708', NULL, NULL, false),
	('631eef63-7d37-4d0e-b5bd-85cf2c2518a2', 'c9190113-fd5d-4ad7-97de-dd8d2122be19', 'ea046f10-de23-4dda-b3bf-2ca12e876bf2', NULL, '1998-04-01', false),
	('0d1950e4-a1ec-4c7f-a872-e741d7a7e008', '4c1994aa-0016-4c70-a06f-3208ddbe5a17', '5b5721c4-9f88-44cb-9302-e6130e8ed6e6', NULL, NULL, false),
	('0b2ed288-a662-447a-8525-e00a534e02d9', 'a4bd2c93-2793-47bb-a3e8-29f283c7fdd6', 'bad2d713-bd8e-4c56-9435-ac404e51109a', NULL, NULL, false),
	('3228af35-eddc-4e7b-b811-628012324266', 'bcb85b88-fe20-4c1d-af32-81e67117d959', 'fcf0f52a-1c8a-4090-a361-bcebfe4f6986', NULL, NULL, false),
	('5929fbb2-70b0-4863-be39-73e40410e3f4', 'f3790d49-8e7e-43af-8659-8fb9ebe7a56e', '3944a193-a6f9-4a9a-aad6-219c83ff71ff', NULL, '1996-04-01', false),
	('06493854-c2ea-46c5-b508-cbde99a27456', 'df10df65-4e7c-4c4f-a3bb-a6b26cba6e3b', '6c429195-ac5d-4622-843c-fe13aedbc0e0', NULL, NULL, true),
	('39f4a1a1-87b5-4fb9-8836-c4245167ae03', 'eafdd5b6-e4e9-4082-8d1a-0e729c39a72e', '052e2cf5-ebd4-4a10-af22-01dd41afe5c7', NULL, '2023-04-01', false),
	('8bc4c899-f335-49e8-b053-ce7d442bbfcf', '2f12bf4f-5901-47d2-88e8-4ea50e54f5d2', '00081acf-dd3a-41c1-90d9-6be0dda47be2', NULL, NULL, false),
	('579e35a1-a7f7-41a3-900f-8341e9aaca4e', 'b4caa070-9e62-4841-bd27-235f8b3f0677', '5fe408d9-fb14-4acf-999d-f8caa9098401', NULL, NULL, false),
	('5382cfac-c5b2-48e4-8586-cbda219f5aa4', '2a8f0f63-6077-4683-9c90-62b5e6fbf399', '1b00df3e-1b56-4574-9bf9-cfd920c1e468', NULL, NULL, false),
	('c64d7b88-fcc5-4826-8fde-43a0ae90a542', 'ad52c5cc-64d2-409b-a4a1-26e56eac5d76', '9bc31c3b-a426-4c3b-aa93-9857e76a029c', NULL, NULL, false),
	('eaaf5f30-c020-4809-9465-d9f156fb299f', '49bf02e6-a792-42b1-a3a9-8d80330aa6d7', '22743a4f-933c-4f60-ba3b-514714ce8752', NULL, NULL, false),
	('c90fc534-e79c-435a-9ac2-13041cca14bb', 'a7d5a9f9-d3f2-4eb8-a8cb-a7a68ece0d88', 'd58456a8-eb8a-4d44-bd48-9611fff6b332', NULL, NULL, false),
	('1ce60817-0b96-4508-ae24-66c96bee5187', 'fb880ead-184b-4802-b149-4054276d9e67', 'c0bab65a-1dda-451f-9012-638ae1078ebe', NULL, NULL, true),
	('d82cc44f-d032-4f22-b3d2-653a40a6cd58', '1ee43dbb-d3b7-4c9c-9dac-51b92b287177', 'e05aa0c3-07e2-45bd-a9ee-fd2e1e7ec3e2', NULL, NULL, false),
	('e5a0e914-fd48-4014-a8ea-26726c819e6c', 'c7c62198-1da3-43af-991f-085b6f22303d', 'dc82f36a-c010-405b-ac23-985fc21c7cb3', NULL, '1998-04-01', false),
	('233ecd5d-c10e-4539-9be5-6f5011aef6c8', '248f228d-63cc-424b-80ee-2618723f2e5c', 'df867651-16f1-4266-91f9-4509f3a9ac50', NULL, NULL, true),
	('a5036635-11b5-468f-b148-489cdc583f14', 'b00533a6-3015-4aa9-af14-c2ab0f2d3889', '97939759-3e3b-4c4a-a2b4-9ff9ebbc145c', NULL, '1996-04-01', false),
	('524a68e9-6044-4b9c-b138-73a7863fab53', '17e82885-5db1-4f02-a386-5ae6cd719a6d', '35d541a2-f11c-4778-99e8-4d779bd9da62', NULL, NULL, true),
	('bd289413-106b-465c-98a8-6f648d794e0a', '3625fb60-5c87-45da-8ccf-00bbdc4c30b1', '4eb78548-efa5-4688-85e2-0d3a01ecd786', NULL, '1998-04-01', false),
	('255496f4-221c-4202-825f-eda84c647b3d', '99cf424d-fb7f-4b06-8698-e99b7f1eeace', 'bbd501c2-2def-4e0c-b22a-ceb523d5ab56', NULL, NULL, false),
	('cb5bbd71-910e-464a-a259-896cea97c863', '9e54c8c8-2600-4ad2-b71c-ae27e07b9fd6', '39ef0d98-239c-4f8f-9b5a-d8678df8c398', NULL, NULL, false),
	('a22ba674-5d8b-4c38-bfdb-595d9f8324df', '6bddaf00-9eae-4a40-8268-ed1ae6bd0d47', '6b2e2c44-71c7-4ab6-800c-7202af3a9df3', NULL, NULL, true),
	('b31edfb9-7b22-4bc9-b174-3491d795338a', 'd8d14dac-53f6-4811-99e8-0df08516a74f', 'a95ba826-f1eb-4c64-80a2-9f147d9a4a7f', NULL, NULL, true),
	('cd5ae02d-e380-4a58-a365-c5da4ab0e2ab', '9dbae5d9-fc83-4410-be20-2a08b8a8df74', '53c392d9-9d44-4c5d-bf03-b2c39df95953', NULL, NULL, false),
	('69603b1c-87b1-467d-8e45-2d84c701198c', '0de36ab5-ff7d-46a9-9ce1-41cd166fac72', 'b05840c4-c612-478c-8243-56cc8542886f', NULL, '2021-04-01', false),
	('048f18df-1356-447c-8014-a5375618ed67', 'de2cc6bf-79db-4a0b-9e68-e5a5ce1b42eb', 'de51de93-8ce1-49e2-8740-929dcc6cfccf', NULL, NULL, true),
	('4e60185b-befc-4c75-a324-f26cc5f020c3', '688eb982-3e6d-4d44-90bc-ddf3e8eb7399', '5fb139ce-a696-4ac2-ba3a-445b361c206a', NULL, NULL, false),
	('cfbb8d0c-154c-453e-8b03-3bded857465c', '56890faa-91ca-4125-b52b-ef84e8e8a985', 'ba306a61-57b7-401a-891a-21302c0debf9', NULL, NULL, true),
	('0afb0a12-f5ef-42f9-920d-b0968e2750e0', 'ebc34405-e89e-4379-87f8-b5e376bb2f3b', '64f34b7e-3413-4bcf-817a-c8024a243b32', NULL, NULL, false),
	('9ced8a97-a695-408c-84a6-0e2c09cac013', '9b6e5e74-7705-4b2c-9ad8-3dd0a336b61f', 'fbd8faf4-3dbe-4410-81c0-ce0891128d5a', NULL, NULL, true),
	('33959df8-c672-4ac7-b067-afb49a15307e', 'f9a5348d-b145-4477-aa9d-6c02c6743485', 'dc951090-305e-42e5-aaa3-5ebccd8ef9f7', NULL, NULL, false),
	('ac19a791-30b8-4bb8-9d19-d20c3cb857da', 'ff50ce81-1e80-4602-8d3c-14217d8238c0', '1a88dac3-1035-481a-89e9-a53036c47a51', NULL, NULL, true),
	('a4dc9d2b-ed7e-43f2-afd4-aa8c3b46c995', '598fa85a-4d94-4272-af10-9ed854e5bcaa', '30783fab-3dcc-4091-b26a-af8907c0dfd1', NULL, NULL, true),
	('890e3832-06af-4de5-9179-5d0bce6d5a9c', 'da6b2fa5-7a52-45f5-be06-59eb8eb2d1a7', 'a1e1223a-8442-424c-8b9f-59714899a9b0', NULL, NULL, true),
	('e56b56ee-615f-4d3d-a887-2bc2b18f4580', 'ee23452d-7e59-4025-8c10-aaec2ae3be59', 'cf576508-e284-4938-9c4d-ea3439e92f75', NULL, NULL, true),
	('6be64525-0202-4f90-a71a-89663bbdc0b7', '2ae95357-0fbd-48d8-b5d9-89a1c56208e1', '5ef4014b-53b5-4283-95d9-02a053ecee56', NULL, NULL, false),
	('f3b2527e-e391-45e7-93cb-c539eb5f1605', '0ec0ee9d-1321-43e6-90cc-9c456c8f51f5', '058cc7ab-9391-4aa6-9ba4-93a8cd4e378b', '2021-04-01', NULL, true),
	('afc4f192-222a-4fd2-9970-c46898e3828a', '92f1ca8c-82d4-4ef0-80ca-eb4c784e8e37', '0e0e4de8-f04e-428a-ab29-ef1bc67cb376', '2021-04-01', NULL, true),
	('e16d3c31-b28a-42d9-a406-cfa4c5bdda93', 'c1cd8079-d587-46fe-881d-2eed86cc84ec', '1c20b22f-1f5c-41d6-a3ff-3696e4522a15', '2023-04-01', NULL, true),
	('2a813012-c757-4d9f-a804-7b3348208867', '19b24e36-cc4f-4742-b657-fceb7e8cef9a', '41272cc4-45fc-499e-bf6c-ffe78ce50b9b', '2023-04-01', NULL, true);


--
-- Data for Name: organisation_group_address; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_group_member; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_group_member_lead_period; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: organisation_identifier; Type: TABLE DATA; Schema: establishment; Owner: -
--



--
-- Data for Name: specialist_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.specialist_provision (specialist_provision_id, establishment_id, specialist_provision_type_id) VALUES
	('d8640814-6422-4a42-a31d-a28944503eb5', '7ba6d27f-657c-4108-af37-1485a9a4f719', 3);


--
-- Data for Name: resourced_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.resourced_provision (resourced_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('263d5b78-06fd-49a1-b044-9138e129ac51', 'd8640814-6422-4a42-a31d-a28944503eb5', 24, 24);


--
-- Data for Name: sen_unit_provision; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.sen_unit_provision (sen_unit_provision_id, specialist_provision_id, capacity, pupil_count) VALUES
	('c7dae337-62f4-4632-b8b1-ec55b0e3a57f', 'd8640814-6422-4a42-a31d-a28944503eb5', 24, 24);


--
-- Data for Name: statutory_age_range; Type: TABLE DATA; Schema: establishment; Owner: -
--

INSERT INTO establishment.statutory_age_range (statutory_age_range_id, education_admissions_and_provision_id, lower_statutory_age, upper_statutory_age) VALUES
	('7a5519ae-1d25-455e-acf9-3da20d68eb07', '023e4af3-ba20-41f7-b874-06ef3284c106', 2, 11),
	('53bf71e0-fb4d-4973-b47e-acda0e0d466a', '94576653-e7ac-4900-a917-07b8bd43746a', 4, 11),
	('dda0a3a8-0751-4300-bc4c-8ff48230e8cf', '386e52d3-b4fd-403d-a888-ff0febc463c3', 11, 19);


--
-- PostgreSQL database dump complete
--

\unrestrict LffoXpXwQYo7FdFMejRAdDnYrVuWWmoMOuxutdZKzRQHwunIzfAYuvsgMASGOQn

