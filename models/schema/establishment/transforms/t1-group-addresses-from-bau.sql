SET NOCOUNT ON;
IF (SELECT count(*) FROM dbo.EstablishmentGroup WHERE id IN(2777,2779,4949))<>3
   OR NOT EXISTS(SELECT 1 FROM dbo.EstablishmentGroup WHERE id=2777 AND type_code='06')
   OR NOT EXISTS(SELECT 1 FROM dbo.EstablishmentGroup WHERE id=2779 AND type_code='10')
   OR NOT EXISTS(SELECT 1 FROM dbo.EstablishmentGroup WHERE id=4949 AND type_code='05')
   THROW 50000,'T1 source group identities/types changed; review required',1;
SELECT g.id AS source_group_id,g.type_code AS source_type_code,
       a.source_address_block,a.address_line_1,a.address_line_2,a.address_line_3,a.town,
       CAST(NULL AS nvarchar(100)) AS county,a.postcode,
       a.source_county_code,a.source_country_code,a.source_uprn,a.source_site_name
FROM dbo.EstablishmentGroup g
CROSS APPLY(VALUES
 ('primary',g.GroupStreet,g.GroupLocality,g.GroupAddress3,g.GroupTown,g.GroupPostcode,
  g.GroupCounty_code,g.GroupCountry_code,CAST(g.GroupPostUPRN AS nvarchar(100)),g.GroupPostSiteName),
 ('contact',g.GroupContactStreet,g.GroupContactLocality,g.GroupContactAddress3,g.GroupContactTown,g.GroupContactPostcode,
  g.GroupContactCounty_code,g.GroupContactCountry_code,CAST(g.GroupContactUPRN AS nvarchar(100)),g.GroupContactSiteName)
) a(source_address_block,address_line_1,address_line_2,address_line_3,town,postcode,
    source_county_code,source_country_code,source_uprn,source_site_name)
WHERE g.id IN(2777,2779,4949)
ORDER BY g.id,a.source_address_block;
