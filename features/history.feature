Feature: Page history
In order to navigate the site
A visitor
wants to see a list of links to previously visited pages

Scenario: Page added to history
  When I go to the homepage
  And I follow "Wiki Page"
  Then I should see "Wiki Page" in the history
  When I go to the homepage
  Then I should not see "Home Page" in the history
