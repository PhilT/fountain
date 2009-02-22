Feature: Edit page
  In order for users to see content on the site
  An admin
  wants to edit pages

  Scenario: Successful Admin Login
    Given I am on the login page
    When I fill in the correct password
    And I press "Login"
    Then I should see "Home Page"
    And I should see "Edit"

  Scenario: Failed Admin Login
    Given I am on the login page
    When I press "Login"
    Then I should see "Login"
    And I should see "Invalid Password"

  Scenario: Users cannot edit pages
    Given I am not logged in
    When I go to edit the homepage
    Then I should not see "Title"

  Scenario: Create a new page
    GivenScenario: Successful Admin Login
    When I follow "New Page"
    And I enter the details
    And I press "Save"
    Then I should see the created page

  Scenario: Edit a page
    GivenScenario: Successful Admin Login
    When I follow "Wiki Page"
    And I follow "Edit"
    And I enter the details
    And I press "Save"
    Then I should see the updated page

  Scenario: Wiki Help
    GivenScenario: Successful Admin Login
    When I follow "New Page"
    Then I should see some formatting help
