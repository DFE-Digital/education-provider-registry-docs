IF NOT EXISTS (SELECT 1 FROM dbo.Establishment e JOIN dbo.IndependentSchools i ON i.urn=e.URN
 WHERE e.URN=124870 AND e.EstablishmentName='Summerhill School' AND e.type_code='11'
 AND e.status_code='1' AND e.LA_code='935' AND e.EstablishmentNumber=6016
 AND e.UKPRN=10017679 AND CONVERT(date,e.OpenDate)='1921-03-13' AND e.CloseDate IS NULL
 AND e.educationPhase_code='0' AND i.proprietorType_code='02'
 AND (SELECT count(*) FROM dbo.EstablishmentProprietors WHERE urn=124870)=1)
 OR EXISTS (SELECT 1 FROM dbo.GroupLink WHERE urn=124870)
 THROW 50001, 'T21 school/proprietor context assertions changed; review before import.', 1;
SELECT 124870 AS urn;
