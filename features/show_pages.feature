Feature: Show pages
  In order to gain knowledge
  A vistor
  wants to see a page

  Scenario: View the home page
    When I go to the homepage
    Then I should see "Home Page"
    And I should not see "Edit"

  Scenario: View the index page
    And I am on the homepage
    When I follow "Index"
    Then I should see "Index Page"
