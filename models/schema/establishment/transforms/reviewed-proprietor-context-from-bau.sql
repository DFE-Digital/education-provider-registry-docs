SELECT CONVERT(int,e.URN) urn,e.EstablishmentName establishment_name,e.type_code,
  e.status_code,CONVERT(varchar(10),e.OpenDate,23) open_date,
  CONVERT(varchar(10),e.CloseDate,23) close_date,CONVERT(varchar(20),e.UKPRN) ukprn,
  e.LA_code local_authority_code,i.proprietorType_code,
  (SELECT count(*) FROM dbo.EstablishmentProprietors p WHERE p.urn=e.URN) additional_proprietor_rows
FROM dbo.Establishment e JOIN dbo.IndependentSchools i ON i.urn=e.URN
WHERE e.URN=$(URN);
