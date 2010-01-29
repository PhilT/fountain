Feature: Edit page
  In order for users to see content on the site
  An admin
  wants to edit pages

  Scenario: Create a new page
    When I follow "New Page"
    And I enter the details
    And I press "Save"
    Then I should see the created page

  Scenario: Edit a page
    When I follow "Wiki Page"
    And I follow "Edit"
    And I enter the details
    And I press "Save"
    Then I should see the updated page

  Scenario: Wiki Help
    When I follow "New Page"
    Then I should see some formatting help

