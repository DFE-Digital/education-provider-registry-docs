# Code lists

A code list is a controlled set of codes and labels used to classify data, such as establishment types or admissions policies. Preserving BAU codes and their meanings keeps migrated records interpretable and maintains consistency with existing APIs, extracts and reports. Target internal IDs are separate; the BAU `code` provides the stable mapping back to the source. Any excluded values are recorded below.


## establishment_type_category

Establishment category. BAU: `dbo.EstablishmentTypeGroup`. Rows: 11.

| `establishment_type_category_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | Colleges |
| 2 | `2` | Universities |
| 3 | `3` | Independent schools |
| 4 | `4` | Local authority maintained schools |
| 5 | `5` | Special schools |
| 6 | `6` | Welsh schools |
| 7 | `9` | Other types |
| 8 | `10` | Academies |
| 9 | `11` | Free Schools |
| 10 | `12` | Children's Centres |
| 11 | `13` | Online provider |

## establishment_type

Detailed establishment type. BAU: `dbo.EstablishmentType`. Rows: 41.

| `establishment_type_id` | `code` | `name` | `establishment_type_category_id` | `academy_route_id` |
| --- | --- | --- | --- | --- |
| 1 | `01` | Community school | 4 | NULL |
| 2 | `02` | Voluntary aided school | 4 | NULL |
| 3 | `03` | Voluntary controlled school | 4 | NULL |
| 4 | `05` | Foundation school | 4 | NULL |
| 5 | `06` | City technology college | 3 | NULL |
| 6 | `07` | Community special school | 5 | NULL |
| 7 | `08` | Non-maintained special school | 5 | NULL |
| 8 | `10` | Other independent special school | 5 | NULL |
| 9 | `11` | Other independent school | 3 | NULL |
| 10 | `12` | Foundation special school | 5 | NULL |
| 11 | `14` | Pupil referral unit | 4 | NULL |
| 12 | `15` | Local authority nursery school | 4 | NULL |
| 13 | `18` | Further education | 1 | NULL |
| 14 | `24` | Secure units | 7 | NULL |
| 15 | `25` | Offshore schools | 7 | NULL |
| 16 | `26` | Service children's education | 7 | NULL |
| 17 | `27` | Miscellaneous | 7 | NULL |
| 18 | `28` | Academy sponsor led | 8 | 2 |
| 19 | `29` | Higher education institutions | 2 | NULL |
| 20 | `30` | Welsh establishment | 6 | NULL |
| 21 | `31` | Sixth form centres | 1 | NULL |
| 22 | `32` | Special post 16 institution | 7 | NULL |
| 23 | `33` | Academy special sponsor led | 8 | 2 |
| 24 | `34` | Academy converter | 8 | 1 |
| 25 | `35` | Free schools | 9 | NULL |
| 26 | `36` | Free schools special | 9 | NULL |
| 27 | `37` | British schools overseas | 7 | NULL |
| 28 | `38` | Free schools alternative provision | 9 | NULL |
| 29 | `39` | Free schools 16 to 19 | 9 | NULL |
| 30 | `40` | University technical college | 9 | NULL |
| 31 | `41` | Studio schools | 9 | NULL |
| 32 | `42` | Academy alternative provision converter | 8 | 1 |
| 33 | `43` | Academy alternative provision sponsor led | 8 | 2 |
| 34 | `44` | Academy special converter | 8 | 1 |
| 35 | `45` | Academy 16-19 converter | 8 | 1 |
| 36 | `46` | Academy 16 to 19 sponsor led | 8 | 2 |
| 37 | `47` | Children's centre | 10 | NULL |
| 38 | `48` | Children's centre linked site | 10 | NULL |
| 39 | `49` | Online provider | 11 | NULL |
| 40 | `56` | Institution funded by other government department | 7 | NULL |
| 41 | `57` | Academy secure 16 to 19 | 8 | NULL |

## establishment_status

Establishment lifecycle status. BAU: `dbo.EstablishmentStatus`. Rows: 4.

| `establishment_status_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | Open |
| 2 | `2` | Closed |
| 3 | `3` | Open, but proposed to close |
| 4 | `4` | Proposed to open |

## reason_establishment_opened

Opening reason. BAU: `dbo.ReasonEstablishmentOpened`. Rows: 13.

Not brought across from BAU: `00` (Not applicable); `13` (Not Recorded); `99` (Not recorded).

| `reason_establishment_opened_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `01` | Result of Amalgamation |
| 2 | `02` | Result of Closure |
| 3 | `03` | Change Religious Character |
| 4 | `04` | Fresh Start |
| 5 | `05` | New Nursery School |
| 6 | `06` | New Provision |
| 7 | `07` | Former Independent |
| 8 | `08` | Split school |
| 9 | `09` | Change in status |
| 10 | `10` | Academy Converter |
| 11 | `11` | Academy Free School |
| 12 | `12` | Free Special School |
| 13 | `14` | Meets accreditation standards |

## reason_establishment_closed

Closure reason. BAU: `dbo.ReasonEstablishmentClosed`. Rows: 15.

Not brought across from BAU: `00` (Not applicable); `99` (Not recorded).

| `reason_establishment_closed_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `01` | Result of Amalgamation/Merger |
| 2 | `02` | Closure |
| 3 | `03` | Change Religious Character |
| 4 | `04` | Fresh Start |
| 5 | `05` | Close Nursery School |
| 6 | `06` | For Academy |
| 7 | `07` | De-registered |
| 8 | `08` | Does not meet criteria for registration |
| 9 | `09` | Change in status |
| 10 | `10` | Academy Converter |
| 11 | `11` | Academy Free School |
| 12 | `12` | Transferred to new sponsor |
| 13 | `13` | Created in Error - coversion not going ahead |
| 14 | `14` | Created in Error - application rejected |
| 15 | `15` | No longer meets accreditation standards |

## education_phase

Education phase. BAU: `dbo.EducationPhase`. Rows: 7.

Not brought across from BAU: `0` (Not applicable); `9` (Not recorded).

| `education_phase_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | Nursery |
| 2 | `2` | Primary |
| 3 | `3` | Middle deemed primary |
| 4 | `4` | Secondary |
| 5 | `5` | Middle deemed secondary |
| 6 | `6` | 16 plus |
| 7 | `7` | All-through |

## further_education_type

Further-education classification. BAU: `dbo.FurtherEducationType`. Rows: 8.

Not brought across from BAU: `00` (Not applicable); `99` (Not recorded).

| `further_education_type_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `01` | Land-Based College |
| 2 | `02` | Art, Design and Performing Arts College |
| 3 | `03` | General Further Education College |
| 4 | `04` | General Further Education College (Special) |
| 5 | `05` | Sixth Form College (General) |
| 6 | `06` | Sixth Form College (Voluntary Aided) |
| 7 | `07` | Sixth Form College (Voluntary Controlled) |
| 8 | `08` | Specialist Designated College |

## gender_of_entry_type

Gender of entry. BAU: `dbo.Gender`. Rows: 3.

Not brought across from BAU: `0` (Not applicable); `9` (Not recorded).

| `gender_of_entry_type_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | Boys |
| 2 | `2` | Girls |
| 3 | `3` | Mixed |

## admissions_policy

Admissions classification. BAU: `dbo.AdmissionsPolicy`. Rows: 4.

Not brought across from BAU: `0` (Not applicable); `5` (Not collected); `9` (Not recorded).

| `admissions_policy_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | Comprehensive (secondary) |
| 2 | `2` | Selective (grammar) |
| 3 | `3` | Modern (secondary) |
| 4 | `4` | Non-selective |

## boarding_provision

Boarding provision. BAU: `dbo.Boarders`. Rows: 4.

Not brought across from BAU: `0` (Not applicable); `9` (Not recorded).

| `boarding_provision_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | No boarders |
| 2 | `2` | Children's home (Boarding school) |
| 3 | `3` | Boarding school |
| 4 | `4` | College / FE residential accomodation |

## nursery_provision

Nursery provision. BAU: `dbo.NurseryProvision`. Rows: 2.

Not brought across from BAU: `0` (Not applicable); `9` (Not recorded).

| `nursery_provision_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | Has Nursery Classes |
| 2 | `2` | No Nursery Classes |

## sixth_form_provision

Sixth-form provision. BAU: `dbo.OfficialSixthForm`. Rows: 2.

Not brought across from BAU: `0` (Not applicable); `9` (Not recorded).

| `sixth_form_provision_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | Has a sixth form |
| 2 | `2` | Does not have a sixth form |

## section_41_approval_status

Section 41 approval. BAU: `dbo.Section41Approved`. Rows: 2.

Not brought across from BAU: `3` (Not applicable).

| `section_41_approval_status_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | Approved |
| 2 | `2` | Not approved |

## religious_character

Religious character. BAU: `dbo.ReligiousCharacter`. Rows: 48.

Not brought across from BAU: `00` (Does not apply); `99` (Not recorded).

| `religious_character_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `02` | Church of England |
| 2 | `03` | Roman Catholic |
| 3 | `04` | Methodist |
| 4 | `05` | Jewish |
| 5 | `06` | None |
| 6 | `07` | Muslim |
| 7 | `08` | Seventh Day Adventist |
| 8 | `09` | Church of England/Methodist |
| 9 | `10` | Methodist/Church of England |
| 10 | `11` | Church of England/Roman Catholic |
| 11 | `12` | Church of England/United Reformed Church |
| 12 | `13` | Roman Catholic/Church of England |
| 13 | `14` | Quaker |
| 14 | `15` | Christian |
| 15 | `16` | United Reformed Church |
| 16 | `17` | Congregational Church |
| 17 | `18` | Free Church |
| 18 | `19` | Church of England/Free Church |
| 19 | `20` | Church of England/Christian |
| 20 | `21` | Sikh |
| 21 | `22` | Greek Orthodox |
| 22 | `23` | Unitarian |
| 23 | `24` | Buddhist |
| 24 | `25` | Hindu |
| 25 | `26` | Moravian |
| 26 | `27` | Pentecostal |
| 27 | `28` | Inter- / non- denominational |
| 28 | `29` | Multi-faith |
| 29 | `30` | Church of England/Methodist/United Reform Church/Baptist |
| 30 | `31` | Anglican |
| 31 | `32` | Anglican/Christian |
| 32 | `33` | Anglican/Evangelical |
| 33 | `34` | Anglican/Church of England |
| 34 | `35` | Catholic |
| 35 | `36` | Charadi Jewish |
| 36 | `37` | Christian/Evangelical |
| 37 | `38` | Christian Science |
| 38 | `39` | Christian/Methodist |
| 39 | `40` | Christian/non-denominational |
| 40 | `41` | Church of England/Evangelical |
| 41 | `42` | Islam |
| 42 | `43` | Orthodox Jewish |
| 43 | `44` | Plymouth Brethren Christian Church |
| 44 | `45` | Protestant |
| 45 | `46` | Protestant/Evangelical |
| 46 | `47` | Reformed Baptist |
| 47 | `48` | Roman Catholic/Anglican |
| 48 | `49` | Sunni Deobandi |

## religious_ethos

Religious ethos. BAU: `dbo.ReligiousEthos`. Rows: 48.

Not brought across from BAU: `00` (Does not apply); `99` (Unknown).

| `religious_ethos_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `02` | Church of England |
| 2 | `03` | Roman Catholic |
| 3 | `04` | Methodist |
| 4 | `05` | Jewish |
| 5 | `06` | None |
| 6 | `07` | Muslim |
| 7 | `08` | Seventh Day Adventist |
| 8 | `09` | Church of England/Methodist |
| 9 | `10` | Methodist/Church of England |
| 10 | `11` | Church of England/Roman Catholic |
| 11 | `12` | Church of England/United Reformed Church |
| 12 | `13` | Roman Catholic/Church of England |
| 13 | `14` | Quaker |
| 14 | `15` | Christian |
| 15 | `16` | United Reformed Church |
| 16 | `17` | Congregational Church |
| 17 | `18` | Free Church |
| 18 | `19` | Church of England/Free Church |
| 19 | `20` | Church of England/Christian |
| 20 | `21` | Sikh |
| 21 | `22` | Greek Orthodox |
| 22 | `23` | Unitarian |
| 23 | `24` | Buddhist |
| 24 | `25` | Hindu |
| 25 | `26` | Moravian |
| 26 | `27` | Pentecostal |
| 27 | `28` | Inter- / non- denominational |
| 28 | `29` | Multi-faith |
| 29 | `30` | Church of England/Methodist/United Reform Church/Baptist |
| 30 | `31` | Anglican |
| 31 | `32` | Anglican/Christian |
| 32 | `33` | Anglican/Evangelical |
| 33 | `34` | Anglican/Church of England |
| 34 | `35` | Catholic |
| 35 | `36` | Charadi Jewish |
| 36 | `37` | Christian/Evangelical |
| 37 | `38` | Christian Science |
| 38 | `39` | Christian/Methodist |
| 39 | `40` | Christian/non-denominational |
| 40 | `41` | Church of England/Evangelical |
| 41 | `42` | Islam |
| 42 | `43` | Orthodox Jewish |
| 43 | `44` | Plymouth Brethren Christian Church |
| 44 | `45` | Protestant |
| 45 | `46` | Protestant/Evangelical |
| 46 | `47` | Reformed Baptist |
| 47 | `48` | Roman Catholic/Anglican |
| 48 | `49` | Sunni Deobandi |

## diocese

Religious diocese. BAU: `dbo.Diocese`. Rows: 62.

Not brought across from BAU: `0000` (Not applicable); `9999` (Not recorded).

| `diocese_id` | `code` | `name` |
| --- | --- | --- |
| 4b863b67-e3e9-00f9-ab94-7e77d5c87a5f | `0002` | Diocese is not trustees |
| 91f61701-b835-0628-d243-6685609f787a | `CE01` | Diocese of Bath and Wells |
| cde509d3-f0a3-1015-b530-b3c061fc2287 | `CE02` | Diocese of Birmingham |
| 6fc215fc-881c-1f1c-8333-79782e0661dc | `CE03` | Diocese of Blackburn |
| 4f6bcba1-cf3d-d340-49f7-8497c7346bc8 | `CE05` | Diocese of Bristol |
| ea7d858b-ea9f-7234-389f-4e37f80645e8 | `CE06` | Diocese of Canterbury |
| f4ebfbc0-0875-d392-42a8-88e9d3e42738 | `CE07` | Diocese of Carlisle |
| 604801b8-1d0e-043a-a926-189134f701b3 | `CE08` | Diocese of Chelmsford |
| be71f0ec-7ab7-21af-999f-92ccebfc9463 | `CE09` | Diocese of Chester |
| 784760dc-15ac-4440-7f66-146b2105ced3 | `CE10` | Diocese of Chichester |
| 5f5da405-b282-9876-8342-3a513380afa1 | `CE11` | Diocese of Coventry |
| 7c0658f2-c940-198f-68fb-0c6dd37c201d | `CE12` | Diocese of Derby |
| e1e81962-c047-6090-2d3a-9afd200ca1e4 | `CE13` | Diocese of Durham |
| a5d62d01-57c4-8b77-2fdc-b694ce135103 | `CE14` | Diocese of Ely |
| 8f210cb1-7933-9276-a57b-578b885fbfd7 | `CE15` | Diocese of Exeter |
| 50a09a18-ac4f-906c-c76a-67c6312e8e29 | `CE16` | Diocese of Gloucester |
| c17d7aef-9016-ff94-ed2f-e9152dbc8de9 | `CE17` | Diocese of Guildford |
| 1ac80ba8-6f71-f557-6da5-5bf3d1cb04b3 | `CE18` | Diocese of Hereford |
| bdb17084-b6bf-1ee8-e1da-8fd41efd5f0c | `CE19` | Diocese of Leicester |
| 36673aa6-9499-f71f-d0c1-d02010f69d1b | `CE20` | Diocese of Lichfield |
| 63c87cd3-1b4d-61be-8727-bb0619a85c74 | `CE21` | Diocese of Lincoln |
| 1f79d2be-bb9a-004c-9593-610e4e3c6ea3 | `CE22` | Diocese of Liverpool |
| 44cf5640-c295-96d7-cf84-4d3badc3eec5 | `CE23` | Diocese of London |
| 2b2148c0-1567-5dbb-e357-b13d7432baff | `CE24` | Diocese of Manchester |
| 64ce1536-d098-4718-cb48-ad728f43651e | `CE25` | Diocese of Newcastle |
| af3ff354-88f2-0a57-2a26-3db7c129539c | `CE26` | Diocese of Norwich |
| 46f39819-bcce-f10c-462e-8347f099a647 | `CE27` | Diocese of Oxford |
| 83e06f18-70b3-1889-3eb5-32039721b813 | `CE28` | Diocese of Peterborough |
| 73f3ff6c-a389-a91c-603f-67fb4f6b4e2d | `CE29` | Diocese of Portsmouth (ce) |
| bc3516c0-97c8-4546-ec54-a03dfafe59f2 | `CE31` | Diocese of Rochester |
| b702a76d-948e-a580-6ffa-366c146b59bd | `CE32` | Diocese of St Albans |
| 5dd38c74-0410-695f-edb9-3280353b875b | `CE33` | Diocese of St Edmundsbury and Ipswich |
| adb73f99-20f1-9297-1ed6-d4b6c55047c4 | `CE34` | Diocese of Salisbury |
| e85b3f1b-2f2a-6d29-7888-e42daff41d91 | `CE35` | Diocese of Sheffield |
| 64a5caaf-fbc3-54bc-6012-43eb53aba2d7 | `CE36` | Diocese of Southwark |
| d9605e9a-1067-820d-34a4-e43df2573bbe | `CE37` | Diocese of Southwell |
| 6ffc1f1a-b5e7-90c8-c7b3-995092c441e9 | `CE38` | Diocese of Truro |
| ced602dd-5b8f-2f86-25e8-60a475fab499 | `CE40` | Diocese of Winchester |
| 2bdb383f-beba-9bc2-00c8-91f11f113f9b | `CE41` | Diocese of Worcester |
| d3a2a3f5-c305-46ea-32c4-22492a0fb55c | `CE42` | Diocese of York |
| b18203c4-f11a-0f24-e3e9-7d7d01853000 | `CE43` | Diocese of Leeds (ce) |
| 0da74203-2900-64d6-60d4-06369c50cca2 | `JT01` | Diocese of Shrewsbury/Diocese of Chester |
| c36d79ef-381a-c2b8-3e96-f3f950f38fec | `RC01` | Archdiocese of Westminster |
| 790998cf-a681-f59a-224d-356aa81e5b91 | `RC02` | Diocese of Arundel and Brighton |
| a4361474-84b5-e25f-1f1c-dec38d95fe77 | `RC03` | Archdiocese of Birmingham |
| 00cb36c8-5cc7-ee6d-13cc-92a3e4658836 | `RC04` | Diocese of Brentwood |
| 695bc3bb-ff97-70ce-bf56-55177295cf3e | `RC05` | Diocese of Clifton |
| 0420dd6c-b951-e589-8630-e4d06d719577 | `RC06` | Diocese of East Anglia |
| 153735b9-086e-7e39-6ad8-07573982f8fe | `RC07` | Diocese of Hallam |
| bdaa90f8-3147-63f4-18ae-2c81e85116c2 | `RC08` | Diocese of Hexham and Newcastle |

Curtailed: first 50 of 62 rows shown; 12 omitted.

## specialist_provision_type

Specialist facility classification. BAU: `dbo.TypeOfReservedProvision`. Rows: 3.

Not brought across from BAU: `0` (Not applicable); `9` (Not recorded).

| `specialist_provision_type_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | Resource Provision |
| 2 | `2` | SEN Unit |
| 3 | `3` | Resource Provision and SEN Unit |

## sen

Current SEN classification. BAU: `dbo.Sen`. Rows: 12.

Not brought across from BAU: `00` (Not Applicable).

| `sen_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `01` | VI - Visual Impairment |
| 2 | `02` | HI - Hearing Impairment |
| 3 | `03` | SLCN - Speech, language and Communication |
| 4 | `04` | ASD - Autistic Spectrum Disorder |
| 5 | `05` | SEMH - Social, Emotional and Mental Health |
| 6 | `06` | MSI - Multi-Sensory Impairment |
| 7 | `07` | PD - Physical Disability |
| 8 | `08` | MLD - Moderate Learning Difficulty |
| 9 | `09` | SLD - Severe Learning Difficulty |
| 10 | `10` | PMLD - Profound and Multiple Learning Difficulty |
| 11 | `11` | SpLD - Specific Learning Difficulty |
| 12 | `12` | OTH - Other Difficulty/Disability |

## local_authority_jurisdiction

Local-authority jurisdiction. BAU: `dbo.LocalAuthorityGroup`. Rows: 2.

| `local_authority_jurisdiction_id` | `code` | `name` |
| --- | --- | --- |
| 1 | `english` | English |
| 2 | `welsh` | Welsh |

## local_authority_area

DfE local-authority area. BAU: `dbo.LocalAuthority`. Rows: 206.

Not brought across from BAU: `000` (Does not apply); `999` (Not recorded).

| `local_authority_area_id` | `code` | `name` | `local_authority_jurisdiction_id` | `gss_local_authority_code_id` |
| --- | --- | --- | --- | --- |
| 297f246b-c4be-4d83-b38e-801e95cd72be | `201` | City of London | 1 | c0c8f890-9c07-4702-8635-913ea3967415 |
| 28dbd3a3-9f71-495d-8ed9-d75bf19ff95b | `202` | Camden | 1 | 286015b2-e63d-4555-88cd-fc027d74207f |
| 95684217-d28d-4094-81a6-14a276a8738a | `203` | Greenwich | 1 | a503f854-c464-493d-b99f-1d0434065a05 |
| 64930f11-0703-4c20-9fcf-c0769c204655 | `204` | Hackney | 1 | d3707e57-ba72-4f92-8a21-c426e19a54d9 |
| 86e53f34-4016-45ab-8a66-faf6a149ed2d | `205` | Hammersmith and Fulham | 1 | 71f381d9-2b0b-413b-af96-d184176998cb |
| c7df72e0-cee2-4f8c-9c41-122ee9c4f95f | `206` | Islington | 1 | 692865c7-9bce-4c4b-8db2-d9cd2814205c |
| c7ef36dd-fd76-4563-9d31-014447af8c16 | `207` | Kensington and Chelsea | 1 | 1dc1f034-3da1-4233-a714-a15bc1574375 |
| 5bb95f7f-3b0c-424a-829a-8c6adf97330a | `208` | Lambeth | 1 | 653162a0-2883-46c3-9ff0-c728d42bff11 |
| 0d7aa581-e954-480e-82a8-603c44c3d834 | `209` | Lewisham | 1 | 79d89dcf-660a-4640-8447-2e87016efd9e |
| ddac8f27-16bf-4419-8f59-0cbbbf09c929 | `210` | Southwark | 1 | 36c91b74-c1b9-44ba-93e7-781fb4855c3a |
| ff905c18-8842-4ad4-b097-c6f15d6cc037 | `211` | Tower Hamlets | 1 | 14e310f3-af23-4d7e-b3be-9fdbb747cc74 |
| 0260a86b-a82e-46ea-80ce-ab5ee559a275 | `212` | Wandsworth | 1 | 9e1b59c5-9f74-4bcc-a9ea-f353fc421319 |
| 0333fd63-23aa-4f25-9cfa-c0737ce1ff23 | `213` | Westminster | 1 | 7e6437e8-3919-46de-a611-c90c75ce9504 |
| 12c33324-71df-44af-9603-24c32618ec48 | `301` | Barking and Dagenham | 1 | 7f56cb14-6b0d-454c-9ff6-22b5e8d86a5c |
| 4fc9f892-7eb2-4498-b0a3-282bdfe78abf | `302` | Barnet | 1 | 4c5ba831-c45b-4dcb-b07e-9a1443bd7ae1 |
| 11b8abc2-9f8e-46a1-b9fd-82461e86cc1a | `303` | Bexley | 1 | 0f72d9e4-09d4-4769-87cc-15767b704d08 |
| 4200bf2f-0485-49e6-8dcc-987ab8993964 | `304` | Brent | 1 | e95e964a-a94d-48b5-b23e-2497d339a583 |
| 274b262c-7c52-426b-8b90-99d43f82b71c | `305` | Bromley | 1 | 54f5f550-e400-4704-bcc0-9fcfd97fcbbc |
| f6981dbf-2923-46b5-8192-86c263df3202 | `306` | Croydon | 1 | 97ca030b-fb16-4c0e-84d4-59083d1cdf7a |
| a50124b2-93ff-4c67-b4ac-8ce44a6c5c6f | `307` | Ealing | 1 | 0703827c-9391-4c29-85ab-99b94db15293 |
| 9e42c107-87f1-4181-8686-b72757330b2a | `308` | Enfield | 1 | d25a7716-a691-4a09-b36a-98bad9b2146e |
| 488b0b24-3dcc-4887-ab9a-5597b7e4e017 | `309` | Haringey | 1 | feb3be93-fff3-44b1-8414-3422b17bef28 |
| 34ebc980-14e2-4312-a001-62a4c63cca7d | `310` | Harrow | 1 | ba155a73-7e40-410a-b0e3-e10600dca2a5 |
| f5bcbc88-af40-4d97-aa21-7e1626a8fbd4 | `311` | Havering | 1 | 7b72895f-20bd-493c-9032-d114d393afaf |
| 544bcbd9-755d-4961-a6ae-3b420a743550 | `312` | Hillingdon | 1 | e20eb6c2-8e8f-4daa-b04e-dbce32f6d0f0 |
| 22022604-e6ff-4dd9-94bc-18394bfadbd7 | `313` | Hounslow | 1 | 8549257e-11c9-4436-ba88-acadca93f4b9 |
| 02d4138f-9676-4117-8796-9af46e1913f8 | `314` | Kingston upon Thames | 1 | 8fe07247-5a83-4f34-b981-0d6155ad5e62 |
| 9adc9496-2a92-41e8-9e6b-1d909f466598 | `315` | Merton | 1 | 2e2721c9-7026-4eb2-b7ad-17d819c14adb |
| 3522dafa-e903-4be1-9d32-ef0efab1f5be | `316` | Newham | 1 | e452a369-3bf6-4012-9eeb-cbe3ea196212 |
| 6a310340-543a-4026-a4ce-aef3ab0a4f95 | `317` | Redbridge | 1 | 5d3d8ebf-4f28-4a10-8b6e-62f8807b9afa |
| ed0d395b-d5e3-40ac-b5b7-44fec3b1ac26 | `318` | Richmond upon Thames | 1 | cba24ff3-0dff-4bc2-a98f-d965dd6a20c4 |
| ed4ab17d-811a-4afc-8059-519c8d8e6ef7 | `319` | Sutton | 1 | 8c855076-7082-483e-af4c-d2e4e0322c82 |
| c9ddcf36-c8e4-43f0-a971-d1fb6d265081 | `320` | Waltham Forest | 1 | 26277b86-38c8-4577-835a-82f21c361347 |
| d1e1bf4a-a56b-4ebf-8968-2e789878851a | `330` | Birmingham | 1 | 2bc4e2cd-ca08-4229-860b-850b9192c4b5 |
| 57110768-0fca-4ac3-a912-0f4fa36e3916 | `331` | Coventry | 1 | 64e4d166-d263-421a-8343-7118059000fe |
| 50c32ca4-c250-4d2c-884d-294e1a902033 | `332` | Dudley | 1 | 68c773e5-76c2-42bc-9196-45dab1986842 |
| 4bd2654a-0f1f-4b52-9f1d-988d0ab5d7d9 | `333` | Sandwell | 1 | c03a6cc7-d1fd-4c09-9db5-69fc385f9170 |
| f6762993-273f-40d2-a3bc-a34d60d0f1a1 | `334` | Solihull | 1 | 6306cdcc-0b0f-4495-a67b-746b72fd204e |
| aeb6b1cd-736d-45f2-87bc-515ca86320f6 | `335` | Walsall | 1 | a22f7518-1805-4407-b3fd-bc4241805617 |
| b4b6da9d-a2ce-4765-949d-ec5521cdfe53 | `336` | Wolverhampton | 1 | 8057f85f-e73a-4c4a-9afb-68dddbb147ff |
| a0a735c9-1a80-4ea9-aee9-88310a581204 | `340` | Knowsley | 1 | f871a7e3-43a2-4d42-8fc4-aa6c3668a860 |
| 6fa42e94-a832-4e37-8f51-57413d5ef13d | `341` | Liverpool | 1 | 43f7e6ff-78a0-4bb9-a9ee-400fd508aa0f |
| bbc67a9f-1d2c-46bc-9b86-6b63c8929185 | `342` | St. Helens | 1 | bb9cc7ab-decb-4a64-814d-c7047abccd76 |
| 57371cb7-f395-4f31-be3a-28402db10127 | `343` | Sefton | 1 | 5229c229-ab09-413c-b8f5-171544c33afb |
| 49ee5141-f7a6-42dd-b92f-2caa2f4c4605 | `344` | Wirral | 1 | 3d59c05b-8a34-4bbc-928b-cdc7a9c55eac |
| 14992e23-2b88-44be-97da-ffb6b53ce708 | `350` | Bolton | 1 | d157b7d1-795b-47ec-8932-88cee0fa570e |
| f2826687-ca95-408e-b7d1-409c814eed3d | `351` | Bury | 1 | 1c1264e2-9a2d-4fa5-bb66-6f04292877ad |
| 2a554866-d171-4e7b-91d0-69afe4990e06 | `352` | Manchester | 1 | bca84901-2fea-4169-ae5c-cbf1fbe7c678 |
| 8875c587-cda4-4311-857b-7c1d5d04a649 | `353` | Oldham | 1 | 7b5c8d58-a84c-410a-a707-c88561e45736 |
| df01645a-8307-4c80-b429-b92882a500db | `354` | Rochdale | 1 | 40648be0-554f-46c1-8bbf-98f432d0f61a |

Curtailed: first 50 of 206 rows shown; 156 omitted.

## gss_local_authority_code

GSS local-authority identifier. BAU: `dbo.GSSLACode`. Rows: 190.

| `id` | `code` |
| --- | --- |
| c001120f-2a7d-4ed3-bd52-8bf2428a68dd | `E06000001` |
| 22ef8b66-cc86-4aef-8224-c4130804d51a | `E06000002` |
| 363847a7-d04b-4007-bcb4-0c22a2c87d04 | `E06000003` |
| d62056a1-2dea-4fd9-8e4f-596fe00cb358 | `E06000004` |
| 589643e9-2803-4084-8952-abeeebf493ba | `E06000005` |
| 88fc3150-50e7-45b2-b233-e798a9aecfae | `E06000006` |
| ef48725c-6fea-4538-8613-c2371d80d44c | `E06000007` |
| 776287ef-3ad5-47f4-b476-190cb9f942d5 | `E06000008` |
| e180150d-f58a-4c0b-a303-7df2c4f12fc3 | `E06000009` |
| af5205b1-d333-42da-b2ba-b88b9c8427e4 | `E06000010` |
| a07935b6-9358-4633-9395-4322263ee46b | `E06000011` |
| 8c6009bc-4fab-4c05-a190-dec2e684c5a4 | `E06000012` |
| 4e6c3068-9e9a-4603-9119-8e873d8dce87 | `E06000013` |
| 13eb6968-0bb2-49ad-829b-085162f1b90d | `E06000014` |
| 88ee7651-5398-48d0-a3ee-02215170b2b1 | `E06000015` |
| ed61caa7-8784-4499-af18-ddfebf3496f0 | `E06000016` |
| a6d515a0-2f57-4f3f-95c4-17f6d570992e | `E06000017` |
| 43e25a01-5003-41d0-be39-2d268909e096 | `E06000018` |
| 7fa0578d-1ec3-49a0-8a14-35b8eb1b7ea6 | `E06000019` |
| 2e5885ef-3b0c-4cda-a0a3-1e5644c17c7d | `E06000020` |
| 1e201b62-c1dc-4f67-9c65-f914abaa8626 | `E06000021` |
| a6d93dff-3046-415c-aef4-8efa394fc712 | `E06000022` |
| e735405b-9616-4f2f-893e-7b739d3e8b51 | `E06000023` |
| 4645c42e-ac0f-4a3c-8d4c-a397b61a50d7 | `E06000024` |
| f4634d78-f2a3-4407-ab03-cacfa42fc71a | `E06000025` |
| 340e13e9-944d-427b-938b-89d4ed610538 | `E06000026` |
| ecc94d5d-27c0-4974-a24d-bcc4f0ea9535 | `E06000027` |
| e5b38f9b-4f7b-410e-8eea-d272e494898b | `E06000028` |
| 2809db13-e4f2-4a5a-8f70-1b99c9f9587b | `E06000029` |
| 10185c0b-daad-48fc-922b-9307d47d1330 | `E06000030` |
| f5951f56-d286-409d-86c1-499a47744409 | `E06000031` |
| e23dc011-be69-452b-8d81-31bb2a1f0a3a | `E06000032` |
| 9427a8ce-a096-4026-bf43-3673b4ddea9c | `E06000033` |
| 408a9344-bacb-49d5-91ae-823e5322a6ad | `E06000034` |
| 04276ae6-ea50-41f9-ae90-6061c3ea7a49 | `E06000035` |
| e6ac3bf4-9350-452c-bcf5-4d28091751d8 | `E06000036` |
| 1b982478-4b6d-4dbe-8ceb-6f7a232250ad | `E06000037` |
| 020b53e2-51e2-41c0-9dc7-3fd1317a5cac | `E06000038` |
| a7f48ed5-bb76-4b69-85d4-5b36fb9bf061 | `E06000039` |
| 852b623a-d518-44c3-9a44-7dca246d979b | `E06000040` |
| b3f2c301-11ae-4a44-9462-5720bff1427c | `E06000041` |
| 7933a470-f894-48f1-81e7-10d3b4f3c4f8 | `E06000042` |
| 0f7b1e40-a855-438e-af1b-b49bb5a5c57d | `E06000043` |
| be75931b-797c-4ea9-b36a-a881a5c71d95 | `E06000044` |
| 6640a340-c363-418c-a0db-cc321d274bac | `E06000045` |
| 5c7fee97-9938-417b-9b3a-723f211a8e37 | `E06000046` |
| 2d03536d-24d9-4c46-bd2e-7ae1e843c565 | `E06000047` |
| 42ee5231-f597-4d9a-ab61-b9c8310d5056 | `E06000048` |
| ff1504df-eefd-4703-b329-eea4d4bfff11 | `E06000049` |
| b565423f-81c4-47b0-ab2c-b299df0ef00b | `E06000050` |

Curtailed: first 50 of 190 rows shown; 140 omitted.

## government_office_region

Government Office Region. BAU: `dbo.GovernmentOfficeRegion`. Rows: 10.

Not brought across from BAU: `N` (Not Applicable (Archived)); `Z` (Not Applicable).

| `government_office_region_id` | `code` | `name` |
| --- | --- | --- |
| 2f453201-9076-4778-aadc-6b2d83f4d2c9 | `A` | North East |
| 88153307-8d90-492d-8a81-eef5c48568e5 | `B` | North West |
| d25452ac-b3fb-4dbf-a29f-c0b0c5d89be8 | `D` | Yorkshire and the Humber |
| 3fd42818-18da-4377-b16b-a606b889198e | `E` | East Midlands |
| 50c93a27-66ab-4369-a9bd-a095ef176960 | `F` | West Midlands |
| 002a45eb-77e3-4d99-8c6b-9ecbaf1c5e1b | `G` | East of England |
| b46ffca9-7ef4-4a21-9c02-c7e399a9f684 | `H` | London |
| 9afb8df9-afc7-4008-905a-fe2af05668aa | `J` | South East |
| 6fef4702-e0c8-455c-8d28-1b6a2bfe4fe0 | `K` | South West |
| 8356b72e-944f-4a08-9b81-fbcf3936f3c4 | `W` | Wales (pseudo) |

## urban_rural

Urban/rural classification. BAU: `dbo.UrbanRural`. Rows: 27.

Not brought across from BAU: `99` (Unknown).

| `id` | `code` | `name` |
| --- | --- | --- |
| 1 | `1` | (Scotland) Large Urban Area |
| 2 | `2` | (Scotland) Other Urban Area |
| 3 | `3` | (Scotland) Accessible Small Town |
| 4 | `4` | (Scotland) Remote Small Town |
| 5 | `5` | (Scotland) Very Remote Small Town |
| 6 | `6` | (Scotland) Accessible Rural |
| 7 | `7` | (Scotland) Remote Rural |
| 8 | `8` | (Scotland) Very Remote Rural |
| 9 | `9` | postcode in Scotland/NI/Channel Is/IoM (pseudo) |
| 10 | `A1` | (England/Wales) Urban major conurbation |
| 11 | `B1` | (England/Wales) Urban minor conurbation |
| 12 | `C1` | (England/Wales) Urban city and town |
| 13 | `C2` | (England/Wales) Urban city and town in a sparse setting |
| 14 | `D1` | (England/Wales) Rural town and fringe |
| 15 | `D2` | (England/Wales) Rural town and fringe in a sparse setting |
| 16 | `E1` | (England/Wales) Rural village |
| 17 | `E2` | (England/Wales) Rural village in a sparse setting |
| 18 | `F1` | (England/Wales) Rural hamlet and isolated dwellings |
| 19 | `F2` | (England/Wales) Rural hamlet and isolated dwellings in a sparse setting |
| 20 | `RLF1` | Larger rural: Further from a major town or city |
| 21 | `RLN1` | Larger rural: Nearer to a major town or city |
| 22 | `RSF1` | Smaller rural: Further from a major town or city |
| 23 | `RSN1` | Smaller rural: Nearer to a major town or city |
| 24 | `UF1` | Urban: Further from a major town or city |
| 25 | `UN1` | Urban: Nearer to a major town or city |
| 26 | `Z9` | (pseudo) Channel Islands/Isle of Man |
| 27 | `ZZZ9` | (pseudo) Channel Islands/Isle of Man |

## district_administrative

Administrative district. BAU: `dbo.DistrictAdministrative`. Rows: 864.

Not brought across from BAU: `9999` (Unknown).

| `id` | `code` | `name` | `archived` |
| --- | --- | --- | --- |
| 3e1ef16f-6367-456d-b7eb-ffbae05e158f | `00AA` | City of London | true |
| a1fbc1cd-f70a-41c9-9265-9a3c676947f2 | `00AB` | Barking and Dagenham | true |
| 797ffd6f-3404-44f4-8a45-7732cf6ac819 | `00AC` | Barnet | true |
| 84c4ff53-370c-45c5-ad62-ef9b93bc12d5 | `00AD` | Bexley | true |
| a837faf9-a0cb-4604-b567-d408fa4b73c4 | `00AE` | Brent | true |
| e35bd41d-0388-4d45-a40e-a2ee8ebb4f79 | `00AF` | Bromley | true |
| 03e13242-b527-4d16-968f-e963343c5820 | `00AG` | Camden | true |
| 18f96e6d-f862-4413-8c30-04452db280f5 | `00AH` | Croydon | true |
| 0e6a36b8-6a58-47a3-b009-d8c620c727f0 | `00AJ` | Ealing | true |
| 3dd65919-0463-4bd0-9e0e-f058679bfae4 | `00AK` | Enfield | true |
| 2f0c4c96-376d-49b3-9c82-7f0c7c53ba0f | `00AL` | Greenwich | true |
| 352f44a6-647c-4b98-918c-41254bcd4275 | `00AM` | Hackney | true |
| eef26e6c-2683-4dad-883a-c9003f22c186 | `00AN` | Hammersmith and Fulham | true |
| 1686af53-0b84-4808-a5ca-05c2d1378878 | `00AP` | Haringey | true |
| ffc05b9a-e62a-45c0-b694-ff9e423a23ba | `00AQ` | Harrow | true |
| 61e572c3-8d1e-4890-b7a3-48c6f09d9997 | `00AR` | Havering | true |
| 3b01c454-71e9-4b6b-b0a4-b5c6f638bd12 | `00AS` | Hillingdon | true |
| 930a40c9-3150-48e8-ab40-9af4c5f6443e | `00AT` | Hounslow | true |
| cbb3bb5f-a355-4ba3-a78b-4cd0068afa97 | `00AU` | Islington | true |
| 3bfe9dd6-ccc6-4170-a498-49ec12af399e | `00AW` | Kensington and Chelsea | true |
| 79d52178-478b-4b6e-98f2-dcd25e1a0e40 | `00AX` | Kingston upon Thames | true |
| fb79af2b-bd43-419a-ab6a-2494a5933b9c | `00AY` | Lambeth | true |
| 146e46c9-75a2-4455-91ca-ac89d20b0498 | `00AZ` | Lewisham | true |
| 5a203fc3-078d-4346-92c1-00c6de594091 | `00BA` | Merton | true |
| 22e3eb83-5a98-4394-8874-6fc07c24f0ec | `00BB` | Newham | true |
| 5a1e9b79-d0ac-48b8-8712-16eade985c5c | `00BC` | Redbridge | true |
| 0fe60371-ae65-45db-a1a7-d8abac5adbd1 | `00BD` | Richmond upon Thames | true |
| 35f48da7-c161-4d78-b2ea-43d10c563dc8 | `00BE` | Southwark | true |
| a0494c5b-77df-4076-b51f-0aa7a036a174 | `00BF` | Sutton | true |
| a25a5372-1590-4807-ad3a-1b8fcdfa736a | `00BG` | Tower Hamlets | true |
| 83954bd8-cd3b-4b1d-9976-a75c7f56969c | `00BH` | Waltham Forest | true |
| 36662c5a-b550-4c2f-806a-287da265f210 | `00BJ` | Wandsworth | true |
| 8d30c6e6-2a81-42d6-821f-3baac04b2b85 | `00BK` | Westminster | true |
| 3f9b55ed-f70e-4cf3-9d69-5c464db6383b | `00BL` | Bolton | true |
| d167f7af-b024-4ac0-bb49-25560da87a67 | `00BM` | Bury | true |
| 5c3d9332-9191-4392-9437-8e12d7886937 | `00BN` | Manchester | true |
| 2b159c64-3065-4a60-b4a7-45386a315dc2 | `00BP` | Oldham | true |
| ab305732-19c9-41fc-9628-ba1e1e1295fc | `00BQ` | Rochdale | true |
| e20ae6b5-7e63-4fdc-a1c0-0652babb5c0a | `00BR` | Salford | true |
| c04a3769-c91d-46ee-a5fe-8b2f4669af09 | `00BS` | Stockport | true |
| 5939886f-506b-47b2-835e-a070365c4909 | `00BT` | Tameside | true |
| 9126b4d3-21af-4d15-ad26-b079c16a0ee9 | `00BU` | Trafford | true |
| 06944649-c6f4-4536-b8f5-778d8ecac6a5 | `00BW` | Wigan | true |
| 6e84c1b1-f77b-4e93-a288-9641d74e3dfe | `00BX` | Knowsley | true |
| 7167d496-a77f-4446-8b96-ed0ae8b60beb | `00BY` | Liverpool | true |
| f6567480-a5a9-403d-a105-23487702154a | `00BZ` | St. Helens | true |
| b0410832-443d-4aaa-92f3-7f9a14e1861b | `00CA` | Sefton | true |
| 37ea117c-77e4-4f4d-84c7-094481fb390c | `00CB` | Wirral | true |
| 9f45b75f-89a6-4294-986c-4279d2fe904b | `00CC` | Barnsley | true |
| 8a965f35-db2b-4fc6-9e7d-bf47591a895b | `00CE` | Doncaster | true |

Curtailed: first 50 of 864 rows shown; 814 omitted.

## administrative_ward

Administrative ward. BAU: `dbo.AdministrativeWard`. Rows: 28930.

Not brought across from BAU: `999999` (Unknown).

| `id` | `code` | `name` |
| --- | --- | --- |
| fe30e3e6-7dee-4180-ac27-979b777128a1 | `00AAFA` | Aldersgate |
| 95c90929-01fc-4391-93aa-77a1e92b56d4 | `00AAFB` | Aldgate |
| 19175229-2ede-487a-b3e1-1e09a5941151 | `00AAFC` | Bassishaw |
| 38453243-7a75-4a0b-af95-b78c6854a536 | `00AAFD` | Billingsgate |
| 47e5b7e3-51f4-4699-af6f-481a6dfb49c5 | `00AAFE` | Bishopsgate |
| aa022867-3de4-4bd0-a5d4-6e3ef094914a | `00AAFF` | Bread Street |
| 66e992c7-77e6-42c0-9ba2-24ec1e63f6c7 | `00AAFG` | Bridge |
| eb0c16d9-e268-4e63-a2e7-dfe9a5ea026d | `00AAFH` | Broad Street |
| 51ec9acc-342d-4cfa-8b52-6db3cabb71a3 | `00AAFJ` | Candlewick |
| d5bfd02f-c79b-4f2c-8aaa-ea5791b7fe6e | `00AAFK` | Castle Baynard |
| e6be0852-94e8-45ae-a2a2-bb9c7d925bf5 | `00AAFL` | Cheap |
| 95b618a2-1819-4ec9-b89c-3c37958f8b4e | `00AAFM` | Coleman Street |
| 502e1e5c-89bc-4034-a7ac-f12a71170714 | `00AAFN` | Cordwainer |
| f8cb62a8-937a-4607-9510-811e9112c4bf | `00AAFP` | Cornhill |
| 62e36878-3437-45a7-aa82-dd6f4bf83bf8 | `00AAFQ` | Cripplegate |
| 4afda533-5d08-4895-9e03-72e494b11029 | `00AAFR` | Dowgate |
| 8136532d-661f-4d64-8bbc-ea0f785c9f98 | `00AAFS` | Farringdon Within |
| 1f0cb1fd-70da-4b4a-a0d7-259adff473c2 | `00AAFT` | Farringdon Without |
| cdb89826-0847-44ca-9ab4-41064e670b47 | `00AAFU` | Langbourn |
| 022e0a9c-d547-48f4-a28e-2e151933a5b8 | `00AAFW` | Lime Street |
| 37355727-13bc-4aec-99f3-7695e7627a4f | `00AAFX` | Portsoken |
| a5b4cb8b-00d4-49fd-b077-5a338e92dc51 | `00AAFY` | Queenhithe |
| c7c132fc-94d9-4e77-8510-093100a19485 | `00AAFZ` | Tower |
| 81fbd9c8-dc04-44d0-bc43-dd88034e4de5 | `00AAGA` | Vintry |
| fcd6d668-2b66-4394-8d65-ac33f42e9d48 | `00AAGB` | Walbrook |
| fe130802-861d-4ffb-97c6-5bd89ad1c63e | `00ABFX` | Abbey |
| 30a54e67-d3b7-4aa5-bb5a-54548e007aa0 | `00ABFY` | Alibon |
| a55cd35e-620c-4bcc-8ef8-8ad4cb378c3b | `00ABFZ` | Becontree |
| 4b6c7cc0-8b9f-4fdc-b3af-41a33e763e1f | `00ABGA` | Chadwell Heath |
| af7a87c9-808a-498e-b058-5d5ee20d2528 | `00ABGB` | Eastbrook |
| f5ef4be9-6940-4935-9e7e-c82072a3e674 | `00ABGC` | Eastbury |
| 4acecce4-007e-48c2-b8f8-73bb74f9cf4a | `00ABGD` | Gascoigne |
| 30a653aa-a039-4e00-b935-3acc83685c89 | `00ABGE` | Goresbrook |
| a5d4461c-511b-4738-bbc4-bf9679506571 | `00ABGF` | Heath |
| 15edaa80-e3af-47cd-b11d-32391ebf4bb5 | `00ABGG` | Longbridge |
| 3f9568ce-39e7-4f83-9c61-552cc3e4f649 | `00ABGH` | Mayesbrook |
| 428863d5-72cd-48a1-b36c-fc05f08ca9d0 | `00ABGJ` | Parsloes |
| 70a11a2a-3d6a-4d59-a8fb-b55d364a3851 | `00ABGK` | River |
| d1b23e3c-3204-46fc-93ee-b3ba369b62bb | `00ABGL` | Thames |
| a824ed4a-2a26-4ff8-83e7-4c49788929d2 | `00ABGM` | Valence |
| cb405197-9e9c-4e1a-8a5b-30e9872c5d42 | `00ABGN` | Village |
| 5d620a73-c5db-4671-9495-7f3b9c622924 | `00ABGP` | Whalebone |
| 8a9cbbc0-8675-4086-ad57-6c2e7b7ec771 | `00ACFX` | Brunswick Park |
| 54f7109e-d775-41fe-ba84-5d8a70b151b0 | `00ACFY` | Burnt Oak |
| f945c207-7507-44ef-85f1-2a3bacb51cdb | `00ACFZ` | Childs Hill |
| 4aaf6840-13a4-4a0b-be48-3ee1b113beb7 | `00ACGA` | Colindale |
| c5af0b3e-60e3-4e35-8f48-716a499e50d7 | `00ACGB` | Coppetts |
| ecd6e498-9dc3-4b21-b25d-fe95c4c49d9f | `00ACGC` | East Barnet |
| 3a13ffa0-feac-4152-a288-3ff78a6dc40a | `00ACGD` | East Finchley |
| 27709787-6029-4913-b0de-6f38d200d46e | `00ACGE` | Edgware |

Curtailed: first 50 of 28930 rows shown; 28880 omitted.

## parliamentary_constituency

Parliamentary constituency. BAU: `dbo.ParliamentaryConstituency`. Rows: 2518.

Not brought across from BAU: `999` (Unknown).

| `id` | `code` | `name` |
| --- | --- | --- |
| 67c79235-bcf7-4521-8780-c6a1a67fbd53 | `001` | Aldershot |
| 50722e24-e8fc-47e9-9fd0-746512c05f19 | `002` | Aldridge-Brownhills |
| d7acf896-a025-4e29-b1b7-c7d90f07afb0 | `003` | Altrincham and Sale West |
| 72bd421d-f4a4-4653-b5eb-da3dc9f3d127 | `004` | Amber Valley |
| 1451b96d-7b9a-4eee-b660-a29e77fe5312 | `005` | Arundel and South Downs |
| 3a329846-30cc-494e-867e-30b34ab0f6ea | `006` | Ashfield |
| 13fa7333-cfb5-4be5-a6d0-f8365176d688 | `007` | Ashford |
| 5e39deb4-7902-424a-9041-bb8a831a38c5 | `008` | Ashton under Lyne |
| 348e162e-ec68-46e0-a561-3fa0be22e623 | `009` | Aylesbury |
| 5bf2cc99-4212-4907-b785-95bad6d2fc0f | `010` | Banbury |
| db834c12-ba1d-489c-a575-665a83394654 | `011` | Barking |
| 4f884d41-b518-452e-a736-d370fff779df | `012` | Barnsley Central |
| e5d5f38b-678b-451b-ad2c-f3d21b23ad77 | `013` | Barnsley East and Mexborough |
| 5596977e-83c1-4771-9f1e-8bad1f54e015 | `014` | Barnsley West and Penistone |
| a85e70ff-041a-4f1c-a702-ded7c819d469 | `015` | Barrow and Furness |
| 01a97bb7-ba0a-42b9-b514-6a243fc0ab02 | `016` | Basildon |
| 955b8394-8eec-4f2b-a31f-0f06c9de8573 | `017` | Basingstoke |
| c20cd2b7-9ea1-45ec-982a-53e792e1c5d9 | `018` | Bassetlaw |
| 83273054-14b7-47be-8377-2d848606f8fb | `019` | Bath |
| 588cbbfd-a269-4671-91e4-d9c7109c1291 | `020` | Batley and Spen |
| b8317cc5-6c06-4795-8d60-bb153fb9ddd7 | `021` | Battersea |
| 994225f0-76d9-44f7-8771-e0160b0af373 | `022` | Beaconsfield |
| 271396bf-28a9-40fe-b386-3793cba28dd7 | `023` | Beckenham |
| 8c29143b-0905-4c03-832e-d68680bf0c47 | `024` | Bedford |
| a336eeb4-969a-420c-ada4-12beca39f467 | `025` | Berwick-upon-Tweed |
| 544bba34-ff21-4d2d-8156-a4023a987004 | `026` | Bethnal Green and Bow |
| 1e36314d-4145-4ec1-94de-2f1ff592348e | `027` | Beverley and Holderness |
| 8f80a3ac-f348-43b3-986c-f8c3073b5656 | `028` | Bexhill and Battle |
| 9d1057cf-2983-489e-a669-af42ed74ab58 | `029` | Bexleyheath and Crayford |
| c7086e8d-79b9-4d95-b501-2b67b7f6c2ac | `030` | Billericay |
| 00a7fcd4-5a6e-450a-82a1-fe20441c814d | `031` | Birkenhead |
| e13d5320-583a-49c6-8722-7d1aa399ddae | `032` | Birmingham, Edgbaston |
| 1c7b2efa-c191-408a-a436-cd0c0b65790a | `033` | Birmingham, Erdington |
| 2624d658-a30a-40c8-95e9-30ae8bd30a5a | `034` | Birmingham, Hall Green |
| d21c27fa-f1c9-44dd-826e-fb4eb21dad81 | `035` | Birmingham, Hodge Hill |
| 097400e3-3a1a-4077-adf0-1afda7f19a7d | `036` | Birmingham, Ladywood |
| 5661ca15-7f0b-4cef-8bac-e38147926ebb | `037` | Birmingham, Northfield |
| 6336eaa5-796f-49ae-90c7-d4ea6cf6fd8b | `038` | Birmingham, Perry Barr |
| 0849f3c7-ba89-4634-a3ea-ae6948b8da9f | `039` | Birmingham, Selly Oak |
| 4217fd0f-5fed-4edb-b4da-4ba56d68df5b | `040` | Birmingham, Sparkbrook and Small Heath |
| 19dbeb18-7d97-4933-a965-1a7ffefaf971 | `041` | Birmingham, Yardley |
| 46fd54d0-14c9-4850-b069-59f6bbccc4cd | `042` | Bishop Auckland |
| 9fc4ca3f-247d-40af-a9f9-60f3a7883c06 | `043` | Blaby |
| 6826b3af-a5f4-4857-85f9-8e46397b12d1 | `044` | Blackburn |
| 9053ac92-8a3b-4a5a-8dcf-8845e956f0d1 | `045` | Blackpool North and Fleetwood |
| 0f26cecb-08ea-433a-a88b-5c2a1072faea | `046` | Blackpool South |
| c145a8ff-bafe-4a8b-92e0-dd2734c16c1d | `047` | Blaydon |
| 06c5bc8a-24ff-49b4-b8e3-e4baeb95616c | `048` | Blyth Valley |
| 91f236f9-13d8-453a-9227-4edddcd84d43 | `049` | Bognor Regis and Littlehampton |
| 2992c17e-889c-4dd2-a2c4-25a63f06158d | `050` | Bolsover |

Curtailed: first 50 of 2518 rows shown; 2468 omitted.

## msoa

Middle layer Super Output Area. BAU: `dbo.MSOA`. Rows: 10156.

Not brought across from BAU: `999999999` (Unknown); `S99999999` (Unknown).

| `id` | `code` | `name` |
| --- | --- | --- |
| 7481068d-3282-4f33-a990-8ff79813f053 | `E02000001` | City of London 001 |
| f6a440f4-8fdf-4b82-8913-301ef650f7f1 | `E02000002` | Barking and Dagenham 001 |
| 08a74ce2-38b5-4691-be60-c6e0dce5cfed | `E02000003` | Barking and Dagenham 002 |
| 3fc68abc-af03-45ac-be46-0975b7857492 | `E02000004` | Barking and Dagenham 003 |
| d5a1bf7c-33d2-419c-9bde-11676e1b5edc | `E02000005` | Barking and Dagenham 004 |
| 6556e8c5-820a-49ec-ace2-c1c5e943fee9 | `E02000006` | Barking and Dagenham 005 |
| 229507b4-c391-435e-8dce-613b95f24970 | `E02000007` | Barking and Dagenham 006 |
| 92974114-bb16-4711-a855-657c9801dd6f | `E02000008` | Barking and Dagenham 007 |
| 579ec78c-8429-47a5-907b-8d9bc4f95d71 | `E02000009` | Barking and Dagenham 008 |
| a04c9269-e5f6-4d71-870d-3a5254b8fc81 | `E02000010` | Barking and Dagenham 009 |
| daa3a607-2351-4695-94d7-50218dbd20c6 | `E02000011` | Barking and Dagenham 010 |
| 479ec52d-a90d-4b65-aba8-f424a61d1de1 | `E02000012` | Barking and Dagenham 011 |
| ea44bbfb-644c-436e-99eb-bf1faa14e9aa | `E02000013` | Barking and Dagenham 012 |
| de3772fd-41c0-49c7-90e0-917defbec697 | `E02000014` | Barking and Dagenham 013 |
| 896f3c3a-cab8-4198-922b-6cd19f3fb450 | `E02000015` | Barking and Dagenham 014 |
| 39d9e4d7-1387-4292-8e3d-d318a8bec2cc | `E02000016` | Barking and Dagenham 015 |
| 361c10f6-f103-44e8-b8e4-9b7432077f65 | `E02000017` | Barking and Dagenham 016 |
| b403a4d5-9252-49e2-98cd-282f2601ff01 | `E02000018` | Barking and Dagenham 017 |
| 0d993904-a904-40c5-9ef8-22b23e55b851 | `E02000019` | Barking and Dagenham 018 |
| 2e662070-ec1e-4481-8f0c-f47a83c08f8a | `E02000020` | Barking and Dagenham 019 |
| 500706bd-5265-4f6d-ab81-6c5c643da90f | `E02000021` | Barking and Dagenham 020 |
| 25c3e868-03a6-43b1-81dd-f2d8b9de0c3b | `E02000022` | Barking and Dagenham 021 |
| 0ebe33ad-c3eb-4d3a-9d72-7a85892df0b9 | `E02000023` | Barking and Dagenham 022 |
| f5a54ae8-c8e3-475a-bd12-f40ffe195278 | `E02000024` | Barnet 001 |
| 5e5686de-b7f0-4721-a300-8c462e6039c7 | `E02000025` | Barnet 002 |
| 608bb324-94a6-4e85-8ea0-66a2b96b73e7 | `E02000026` | Barnet 003 |
| f676d2f2-b322-4318-94af-af48bab0cf8e | `E02000027` | Barnet 004 |
| dae80509-4794-42a3-9765-00589fa0097e | `E02000028` | Barnet 005 |
| 82940e3f-6d02-44de-8f4f-a338e46e2e2e | `E02000029` | Barnet 006 |
| 79cf2253-0207-43b9-92c1-45b5d31f0237 | `E02000030` | Barnet 007 |
| 4c27bcbf-a913-421f-9cad-a301ceda37d2 | `E02000031` | Barnet 008 |
| 0947791b-872c-42c4-be44-149ac5f9a1f2 | `E02000032` | Barnet 009 |
| 191ce1ac-03ff-4fc8-8f19-949cdd6caeb6 | `E02000033` | Barnet 010 |
| b6345b03-d648-4d72-a486-044597f52454 | `E02000034` | Barnet 011 |
| 125fca58-4877-4cee-8a24-5feb3faa1090 | `E02000035` | Barnet 012 |
| ea9e2dbc-1d1e-49eb-904d-05e92d35db26 | `E02000036` | Barnet 013 |
| 2affba03-2888-4c86-9315-97992302485a | `E02000037` | Barnet 014 |
| 07eee753-cae2-427d-be64-a973858434c5 | `E02000038` | Barnet 015 |
| 416f5005-4e3b-4bbe-b7ba-ee30abdb9a7d | `E02000039` | Barnet 016 |
| 9f1798ac-390e-4b30-8531-90056c65fd85 | `E02000040` | Barnet 017 |
| 0348dd28-3dbd-4e10-ac56-f79d5aae016d | `E02000041` | Barnet 018 |
| 5e734c38-a304-4c4e-874b-071398d38063 | `E02000042` | Barnet 019 |
| 4053079f-1421-46d2-8ef9-3b1e80a258b9 | `E02000043` | Barnet 020 |
| 6a9e6d96-9ddc-4549-878f-f41077afe062 | `E02000044` | Barnet 021 |
| 05675213-7b42-4de2-b1cd-40ee8794ab73 | `E02000045` | Barnet 022 |
| 43a05dc1-7c9a-495d-a5e7-af93a5a3ee8e | `E02000046` | Barnet 023 |
| 142121c7-8a08-4e18-a699-28c9e244d7d5 | `E02000047` | Barnet 024 |
| 9c7ad0f8-ffc5-450f-9a2c-8e23535ce303 | `E02000048` | Barnet 025 |
| b3f78d6e-ccab-4a7b-8bf7-121e16c6925a | `E02000049` | Barnet 026 |
| 14ca06b2-e743-4174-8a0c-5dc90e16b222 | `E02000050` | Barnet 027 |

Curtailed: first 50 of 10156 rows shown; 10106 omitted.

## lsoa

Lower layer Super Output Area. BAU: `dbo.LSOA`. Rows: 53748.

Not brought across from BAU: `999999999` (Unknown); `N99999999` (Unknown); `S99999999` (Unknown).

| `id` | `code` | `name` |
| --- | --- | --- |
| 83c6d5c4-690f-43d8-bf21-67049f16f02c | `95AA01S1` | Aldergrove 1 |
| f394ff3b-9599-486d-ac96-0fe0e051c76a | `95AA01S2` | Aldergrove 2 |
| 86bc159e-d88f-4f92-8ace-a210545b9cfb | `95AA01S3` | Aldergrove 3 |
| 543718c6-b7c1-4f27-8a27-d65b49a5cfb8 | `95AA02W1` | Balloo |
| a4af6967-d163-4886-b541-e041d74d1420 | `95AA03W1` | Ballycraigy |
| 3c0ee8e4-4a9b-4b50-be88-1e156389b828 | `95AA04W1` | Clady |
| eed270d9-7f30-4feb-bb83-f3b7e165b4ef | `95AA05W1` | Cranfield |
| 82bbdf3b-b922-4300-8440-04e0347a9ad4 | `95AA06S1` | Crumlin 1 Antrim |
| 4487817c-edaa-4430-8f3f-5c4db99c9289 | `95AA06S2` | Crumlin 2 Antrim |
| 8d9a65ab-f4a7-4b13-87d0-759d5001cecb | `95AA07W1` | Drumanaway |
| 2de8a303-4f3a-45a2-a772-6dd78d75ecad | `95AA08W1` | Farranshane |
| 6f30492d-5972-4f5d-9d26-7093e01d6bd2 | `95AA09W1` | Fountain Hill |
| 53e980df-7dae-48cd-9f01-234729feaa11 | `95AA10W1` | Greystone Antrim |
| 9c9828c4-3eb0-4c08-a23b-c9735930afb5 | `95AA11S1` | Massereene 1 |
| a681a0b2-cf17-45bf-88bf-a7bce6e3c632 | `95AA11S2` | Massereene 2 |
| e26abe85-934e-45eb-83f2-6588ecae4b56 | `95AA12W1` | Parkgate |
| 31e53f21-0b27-4c06-a65f-a1c7f47768eb | `95AA13S1` | Randalstown 1 |
| 52d157e2-dfa1-4c02-82ee-a3f9c1d05b63 | `95AA13S2` | Randalstown 2 |
| ee8feaca-e430-450c-bd5a-8237d75731f0 | `95AA14W1` | Shilvodan |
| 2815ea6d-bf5d-42b7-96ba-d0b0b2d5c4b9 | `95AA15S1` | Springfarm 1 |
| a94b4d15-1945-4147-911a-be983b38e6cc | `95AA15S2` | Springfarm 2 |
| 88f2bed8-35a4-4af0-9097-f456e159ac50 | `95AA16W1` | Steeple |
| 99f969c8-bee6-486c-b294-f39d4731eecf | `95AA17W1` | Stiles |
| 14a1b2cc-1397-49c2-b37c-697ef24e8b67 | `95AA18W1` | Templepatrick |
| da3bc0be-752b-475d-93bb-b78d018cfb3b | `95AA19W1` | Toome |
| 2e9bc3a4-0c58-4742-886f-a1612910d59c | `95BB01S1` | Ballygowan 1 |
| 942e241e-eae6-4e22-a998-aef47be3a541 | `95BB01S2` | Ballygowan 2 |
| 5ffc0fe5-ceb7-449c-a479-5ef378aeeb5e | `95BB02W1` | Ballyrainey |
| 7fa9bb10-e4ba-4b8b-bf76-fb65589e0bd1 | `95BB03S1` | Ballywalter 1 |
| 46fa89bf-1d5a-4891-aea8-409000085ede | `95BB03S2` | Ballywalter 2 |
| d0d9ed2d-33ed-415b-bbff-30cb820f8b5f | `95BB04S1` | Bradshaw's Brae 1 |
| 2d005dac-cb57-4c29-af53-c96a51bf53ea | `95BB04S2` | Bradshaw's Brae 2 |
| d1453304-46d5-4c9b-ac19-ae8e11a0f8d6 | `95BB05S1` | Carrowdore 1 |
| 084c28a0-b4a8-4298-b5dc-a0df2279497a | `95BB05S2` | Carrowdore 2 |
| e1a0710b-8040-4abc-abaf-1d73b5c017b8 | `95BB06W1` | Central Ards |
| d47693b0-292c-4ec4-ab9d-b99da628062a | `95BB07S1` | Comber East 1 |
| dd17da18-c4bf-4c25-9509-f20f77f2d4fc | `95BB07S2` | Comber East 2 |
| 5b4952f1-8f7f-4923-a9f4-26fd179b14a8 | `95BB08S1` | Comber North 1 |
| 3faf0dfe-006f-4b29-a533-610115f1a795 | `95BB08S2` | Comber North 2 |
| 30272c30-7b62-499d-8ce7-dc0ebf395a28 | `95BB09S1` | Comber West 1 |
| c9d488fb-53af-4617-aa43-412c3a593381 | `95BB09S2` | Comber West 2 |
| d6992618-52ff-419c-be51-1afad02d8eb3 | `95BB10S1` | Donaghadee North 1 |
| fdb644d9-2919-49c5-bba4-b3c453ac26e5 | `95BB10S2` | Donaghadee North 2 |
| 25b9ee6b-0b30-4460-b468-5a7ef97afe68 | `95BB11S1` | Donaghadee South 1 |
| 1a16b1bc-6e74-403f-906a-4e9703933343 | `95BB11S2` | Donaghadee South 2 |
| 23f283a1-0efb-4ecc-920c-ee06db8d619d | `95BB12S1` | Glen 1 |
| 277f6c4f-d76c-403d-8028-22415d3273ee | `95BB12S2` | Glen 2 |
| 5e86b3af-6bef-4b61-aeeb-e6c68e829da1 | `95BB13S1` | Gregstown 1 |
| fb8b649f-49c7-4276-bb3a-8f62c711b50c | `95BB13S2` | Gregstown 2 |
| 98e16c36-547d-4332-af5d-cfd7449bbe1b | `95BB13S3` | Gregstown 3 |

Curtailed: first 50 of 53748 rows shown; 53698 omitted.
