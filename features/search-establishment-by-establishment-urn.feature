@search
Feature: SearchEstablishmentByURN
  As a public website visitor
  I want to search for establishments by their URN
  So that I can find information about establishments I am interested in

Background:
Given the following establishments have been created
| Establishment Name                       | URN    | Establishment Status | Establishment Type          |
| Longfield Tutorial Centre                | 101863 | Closed               | Pupil referral unit         |
| Chantry Infant School                    | 124664 | Closed               | Community school            |
| St Aidan's Catholic Primary School       | 102846 | Closed               | Voluntary aided school      |
| St James Church of England School Hanney | 123148 | Closed               | Voluntary controlled school |
| Kelling Primary School                   | 120823 | Closed               | Community school            |

Scenario Outline: Search on establishment URN
When I search using the term "<term>"
Then <results_count> establishments are returned
And the ordered results are "<results>"

Examples:
| term   | results_count | results                                                                                                        |
| 12     | 3             | Chantry Infant School; Kelling Primary School; St James Church of England School Hanney                        |
| 0      | 3             | Longfield Tutorial Centre; St Aidan's Catholic Primary School; Kelling Primary School                          |
| 48     | 1             | St Aidan's Catholic Primary School                                                                             |
| 124664 | 1             | Chantry Infant School                                                                                          |
| 999    | 0             | NONE                                                                                                           |
