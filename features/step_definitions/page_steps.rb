Given /^the following pages:$/ do |pages|
  Page.create!(pages.hashes)
end

Given /^the homepage exists$/ do
  page = Page.find_by_name('HomePage')
  page = Page.create!(:name => 'HomePage', :title => 'Home Page', :content => '') unless page
end

Given /^the home page contains a "(.*)"$/ do |page_link|
  page = Page.find_by_name('HomePage')
  page.content << page_link
  page.save!
end

When /^I delete the (\d+)(?:st|nd|rd|th) page$/ do |pos|
  visit pages_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

When /^I enter the details$/ do
  fill_in 'Title', :with => 'Page Title'
  fill_in 'page_content', :with => 'content'
end

Then /^I should see the (.*) page$/ do |action|
  body = response.body
  body.should =~ /<h1>.*Page Title/m
  body.should =~ /<strong>Page Title<\/strong> was successfully #{action}/m
  body.should =~ /content/m
end

Then /^I should see some formatting help$/ do
  response.body.should =~ /h1. heading/m
end

Then /^I should see some bold text$/ do
  Then 'I should see "<strong>some bold text</strong>"'
end

Then /^I should see a WikiWord as a link$/ do
  response.body.should =~ /<a class="new" href="\/pages\/wiki-words-point-to-other-pages">Wiki Words Point To Other Pages<\/a>/m
end

Then /^I should not see a WikiWord as a link in a code block$/ do
  response.body.should =~ /<pre><code>WikiWordsNotLinkedInCodeTags<\/code><\/pre>/
end

Then /^I should see "(.*)" in (?:a|an) (.*) .* tag$/ do |text, tag|
  response.body.should =~ /<#{tag}>#{text}<\/#{tag}>/
end

Then /^I should see the following links in the history:$/ do
end
