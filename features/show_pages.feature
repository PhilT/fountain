Feature: Show pages
  In order to gain knowledge
  A vistor
  wants to see a page

  Scenario: View the home page
    When I go to the homepage
    Then I should see "Home Page"
    And I should see "Edit disabled"

  Scenario: View the search/index page
    And I am on the homepage
    When I follow "Search"
    Then I should see "Search and Index"
