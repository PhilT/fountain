Feature: Edit page
  In order for users to see content on the site
  An admin
  wants to edit pages

  Scenario: Login page
    When I go to the login page
    Then I should see "Login"

  Scenario: Successful Admin Login
    Given I am on the login page
    When I fill in "Password" with "reason"
    And I press "Login"
    Then I should see "Home Page"
    And I should see "Edit"

  Scenario: Failed Admin Login
    Given I am on the login page
    When I press "Login"
    Then I should see "Login"
    And I should see "Invalid Password"


  Scenario: New page
    Given I am logged in
    And I am on a new page
    When I fill in "Name" with "PageName"
    And I fill in "Title" with "page title"
    And I fill in "Content" with "some content"
    And I press "Create"
    Then I should see "PageName"
    And I should see "page title"
    And I should see "some content"
