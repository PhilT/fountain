Feature: Show pages using wiki formatting
  In order to make editing easier
  An admin
  wants to edit a page using wiki formatting

  Scenario: View WikiWords
    When I go to a Wiki Page
    Then I should see "<strong>some bold text</strong>"
    And I should see "<a class=\"new\" href=\"/pages/wiki-words-point-to-other-pages\">Wiki Words Point To Other Pages</a>"
    And I should see "<pre><code>WikiWordsNotLinkedInCodeTags</code></pre>"
    And I should see "<h2>A Heading</h2>"
