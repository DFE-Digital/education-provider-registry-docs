-- Complete source dictionaries. Inclusion rules are applied in the target loader.
SELECT 'establishment_type_category' AS reference_list, 'dbo.EstablishmentTypeGroup' AS source_table,
       CAST(code AS nvarchar(32)) AS code, name, CAST(archived AS integer) AS archived,
       CAST(NULL AS nvarchar(32)) AS group_code FROM dbo.EstablishmentTypeGroup
UNION ALL SELECT 'establishment_type','dbo.EstablishmentType',code,name,archived,CAST(group_code AS nvarchar(32)) FROM dbo.EstablishmentType
UNION ALL SELECT 'establishment_status','dbo.EstablishmentStatus',code,name,archived,NULL FROM dbo.EstablishmentStatus
UNION ALL SELECT 'reason_establishment_opened','dbo.ReasonEstablishmentOpened',code,name,archived,NULL FROM dbo.ReasonEstablishmentOpened
UNION ALL SELECT 'reason_establishment_closed','dbo.ReasonEstablishmentClosed',code,name,archived,NULL FROM dbo.ReasonEstablishmentClosed
UNION ALL SELECT 'education_phase','dbo.EducationPhase',code,name,archived,NULL FROM dbo.EducationPhase
UNION ALL SELECT 'gender_of_entry_type','dbo.Gender',code,name,archived,NULL FROM dbo.Gender
UNION ALL SELECT 'admissions_policy','dbo.AdmissionsPolicy',code,name,archived,NULL FROM dbo.AdmissionsPolicy
UNION ALL SELECT 'boarding_provision','dbo.Boarders',code,name,archived,NULL FROM dbo.Boarders
UNION ALL SELECT 'diocese','dbo.Diocese',code,name,archived,NULL FROM dbo.Diocese
UNION ALL SELECT 'further_education_type','dbo.FurtherEducationType',code,name,archived,NULL FROM dbo.FurtherEducationType
UNION ALL SELECT 'nursery_provision','dbo.NurseryProvision',code,name,archived,NULL FROM dbo.NurseryProvision
UNION ALL SELECT 'sixth_form_provision','dbo.OfficialSixthForm',code,name,archived,NULL FROM dbo.OfficialSixthForm
UNION ALL SELECT 'section_41_approval_status','dbo.Section41Approved',code,name,archived,NULL FROM dbo.Section41Approved
UNION ALL SELECT 'specialist_provision_type','dbo.TypeOfReservedProvision',code,name,archived,NULL FROM dbo.TypeOfReservedProvision
UNION ALL SELECT 'religious_character','dbo.ReligiousCharacter',code,name,archived,NULL FROM dbo.ReligiousCharacter
UNION ALL SELECT 'religious_ethos','dbo.ReligiousEthos',code,name,archived,NULL FROM dbo.ReligiousEthos
UNION ALL SELECT 'sen','dbo.Sen',code,name,archived,NULL FROM dbo.Sen
UNION ALL SELECT 'local_authority_jurisdiction','dbo.LocalAuthorityGroup',code,name,archived,NULL FROM dbo.LocalAuthorityGroup;
