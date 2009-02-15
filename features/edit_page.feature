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

  Scenario: Create a new page
    GivenScenario: Successful Admin Login
    And I am on a new page
    When I create a new page
    Then I should see a page with the details I entered

  Scenario: Users cannot edit pages
    Given I am not logged in
    When I go to edit the homepage
    Then I should not see "Title"
