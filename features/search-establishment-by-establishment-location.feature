@search
Feature: SearchEstablishmentByLocation
  As a public user
  I want to search for establishments using town, county or postcode
  So that I can find establishments in a geographic location

Background:
  Given the following establishments exist
  | Establishment Name                           | Town      | County           | Postcode |
  | Orchard School & Nursery                     | Bedford   | Bedfordshire     | MK45 4RB |
  | Heatherton School                            | Amersham  | Buckinghamshire  | HP6 5QB  |
  | Merrywood House Independent Special School   | Surrey    | Surrey           | KT20 7HF |
  | Bury Park Educational Institute              | Luton     | Bedfordshire     | LU1 1EH  |
  | The Island Project School                    | Meriden   | West Midlands    | CV7 7HQ  |
  | St Albans Independent College                | St Albans | Hertfordshire    | AL1 1LN  |

Scenario Outline: Results include the establishments that match the location search term
  When a location search is made using the search term "<search_term>"
  Then the establishment returned is "<returned_establishment>">"

Examples:
  | example_description      | search_term     | returned_establishment                    |
  | Partial match on Town    | Albans          | St Albans Independent College             |
  | Partial match on County  | Midlands        | The Island Project School                 |
  | Partial match on Postcode| KT20            | Merrywood House Independent Special School|
  | Exact match on Town      | Bedford         | Orchard School & Nursery                  |
  | Exact match on County    | Buckinghamshire | Heatherton School                         |
  | Exact match on Postcode  | LU1 1EH         | Bury Park Educational Institute           |
  | Case insensitive match   | west midlands   | The Island Project School                 |
  | No fuzzy matching        | Bckinghamshire  | NONE                                      |
