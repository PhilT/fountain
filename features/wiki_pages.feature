Feature: Show pages using wiki formatting
  In order to make editing easier
  An admin
  wants to edit a page using wiki formatting

  Scenario: View WikiWords
    When I go to a Wiki Page
    Then I should see some bold text
    And I should see a WikiWord as a link
    And I should not see a WikiWord as a link in a code block
    And I should see "A Heading" in an h2 header tag
