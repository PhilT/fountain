Given /^the following pages:$/ do |pages|
  Page.create!(pages.hashes)
  puts pages.inspect
end

When /^I delete the (\d+)(?:st|nd|rd|th) page$/ do |pos|
  visit pages_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
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

Given /^the home page contains a "Link To A Page"$/ do
end

Then /^I should see the following links in the history:$/ do
end
