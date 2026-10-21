SET NOCOUNT ON;
-- Resolve the county name from the source lookup; preserve raw codes as evidence.
-- County.java defines 099 as Unknown (the current lookup labels it Not recorded)
-- and 000 as Not applicable. Both intentionally produce a null target county.
IF EXISTS (
    SELECT 1 FROM dbo.EstablishmentGroup g
    CROSS APPLY (VALUES(g.GroupCounty_code),(g.GroupContactCounty_code)) a(code)
    LEFT JOIN dbo.County c ON c.code=NULLIF(LTRIM(RTRIM(a.code)),'')
    WHERE g.id IN($(GROUP_IDS))
      AND NULLIF(LTRIM(RTRIM(a.code)),'') IS NOT NULL
      AND LTRIM(RTRIM(a.code)) NOT IN ('000','099')
      AND NULLIF(LTRIM(RTRIM(c.name)),'') IS NULL
)
    THROW 51000, 'Group-address county code is absent from dbo.County or has no name. Review the source lookup before migration.', 1;

SELECT g.id AS source_group_id,g.type_code AS source_type_code,
       a.source_address_block,a.address_line_1,a.address_line_2,a.address_line_3,a.town,
       CASE WHEN LTRIM(RTRIM(a.source_county_code)) IN ('000','099')
                  OR LOWER(LTRIM(RTRIM(county.name))) IN
                     ('unknown','not applicable','not recorded','does not apply')
            THEN NULL ELSE NULLIF(LTRIM(RTRIM(county.name)),'') END AS county,
       a.postcode,
       a.source_county_code,a.source_country_code,a.source_uprn,a.source_site_name
FROM dbo.EstablishmentGroup g
CROSS APPLY(VALUES
 ('primary',g.GroupStreet,g.GroupLocality,g.GroupAddress3,g.GroupTown,g.GroupPostcode,
  g.GroupCounty_code,g.GroupCountry_code,CAST(g.GroupPostUPRN AS nvarchar(100)),g.GroupPostSiteName),
 ('contact',g.GroupContactStreet,g.GroupContactLocality,g.GroupContactAddress3,g.GroupContactTown,g.GroupContactPostcode,
  g.GroupContactCounty_code,g.GroupContactCountry_code,CAST(g.GroupContactUPRN AS nvarchar(100)),g.GroupContactSiteName)
) a(source_address_block,address_line_1,address_line_2,address_line_3,town,postcode,
    source_county_code,source_country_code,source_uprn,source_site_name)
LEFT JOIN dbo.County county ON county.code=NULLIF(LTRIM(RTRIM(a.source_county_code)),'')
WHERE g.id IN($(GROUP_IDS))
ORDER BY g.id,a.source_address_block;
