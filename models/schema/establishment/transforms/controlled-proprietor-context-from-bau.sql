-- Raw local context only. No obfuscated proprietor names/contact data are
-- exported or used to resolve the accepted public-extract party.
SELECT e.URN AS urn, e.EstablishmentName AS establishment_name,
       e.type_code AS establishment_type_code, e.status_code AS status_code,
       i.proprietorType_code AS proprietor_type_code,
       p.name AS proprietor_type,
       (SELECT COUNT(*) FROM dbo.EstablishmentProprietors ep WHERE ep.urn=e.URN)
           AS additional_proprietor_rows
FROM dbo.Establishment e
JOIN dbo.IndependentSchools i ON i.URN=e.URN
LEFT JOIN dbo.ProprietorType p ON p.code=i.proprietorType_code
WHERE e.URN IN ($(URNS))
ORDER BY e.URN;
