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

When /^I create a new page$/ do
  fill_in 'Name', :with => 'PageName'
  fill_in 'Title', :with => 'Page Title'
  fill_in 'page_content', :with => 'content'
  click_button 'Save'
end

Then /^I should see a page with the details I entered$/ do

end

Then /^I should see the following pages:$/ do |pages|
  pages.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end

Then /^I should see the following links in the history:$/ do
end
