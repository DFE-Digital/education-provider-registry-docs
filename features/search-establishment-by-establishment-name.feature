@search
Feature: Search for establishment by establishment name
  As a public website visitor
  I want to search for establishments by their name
  So that I can find information about establishments I am interested in

  Background:
    Given the following establishments exist:
      | establishment name                                  | URN    | establishment status | establishment type            |
      | Longfield Tutorial Centre                           | 101863 | Closed               | Pupil referral unit           |
      | St Peter and St Paul Catholic Voluntary Academy     | 139623 | Open                 | Academy converter             |
      | Ide Hill Church of England Primary School           | 118722 | Open                 | Voluntary aided school        |
      | Tonbridge Grammar School                            | 136417 | Open                 | Academy converter             |
      | Beacon Primary Academy                              | 140947 | Created in error     | Free schools                  |
      | Chantry Infant School                               | 124664 | Closed               | Community school              |
      | Langley Park School for Boys                        | 136586 | Open                 | Academy converter             |
      | St Aidan's Catholic Primary School                  | 102846 | Closed               | Voluntary aided school        |
      | St James Church of England School Hanney            | 123148 | Closed               | Voluntary controlled school   |
      | Kelling Primary School                              | 120823 | Closed               | Community school              |

  @search-name-lowercase
  Scenario: Lower-case search returns establishments containing the search term
    When a public visitor searches for establishments by name using the term "school"
    Then the number of establishments returned is 7
    And the ordered results are:
      | establishment name                       |
      | Chantry Infant School                    |
      | Ide Hill Church of England Primary School |
      | Kelling Primary School                   |
      | Langley Park School for Boys             |
      | St Aidan's Catholic Primary School       |
      | St James Church of England School Hanney |
      | Tonbridge Grammar School                 |

  @search-name-uppercase
  Scenario: Upper-case search is not case sensitive
    When a public visitor searches for establishments by name using the term "SCHOOL"
    Then the number of establishments returned is 7
    And the ordered results are:
      | establishment name                       |
      | Chantry Infant School                    |
      | Ide Hill Church of England Primary School |
      | Kelling Primary School                   |
      | Langley Park School for Boys             |
      | St Aidan's Catholic Primary School       |
      | St James Church of England School Hanney |
      | Tonbridge Grammar School                 |

  @search-name-mixed-case
  Scenario: Mixed-case search is not case sensitive
    When a public visitor searches for establishments by name using the term "AcadEmy"
    Then the number of establishments returned is 2
    And the ordered results are:
      | establishment name                              |
      | Beacon Primary Academy                          |
      | St Peter and St Paul Catholic Voluntary Academy |

  @search-name-special-character
  Scenario: Search term can contain a special character
    When a public visitor searches for establishments by name using the term "'"
    Then the number of establishments returned is 1
    And the ordered results are:
      | establishment name                 |
      | St Aidan's Catholic Primary School |

  @search-name-no-results
  Scenario: No matching establishments are found
    When a public visitor searches for establishments by name using the term "college"
    Then the number of establishments returned is 0
    And the public visitor is told that no establishments were found
