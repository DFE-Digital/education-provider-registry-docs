@search
Feature: SearchEstablishmentByURN
  As a public website visitor
  I want to search for establishments by their name
  So that I can find information about establishments I am interested in

@search-urn-no-results
Scenario: Search on urn returns no results
  Given an establishment search has been made
  When no establishments match the urn
  Then an error is returned indicating no establishment were found

@search-urn-multiple-results
Scenario: Search on urn returns multiple results
  Given an establishment search has been made
  When one or more establishment names match the search term
  Then the matching estbablishments are returned
