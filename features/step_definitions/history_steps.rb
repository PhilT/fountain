Then /^I should see the following pages:$/ do |pages|
  pages.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end

Then /^I should see "(.*)" in the history$/ do |page|
  response.body.should =~ /History.*<li>.*#{page}/m
end

Then /^I should not see "(.*)" in the history$/ do |page|
  response.body.should_not =~ /History.*<li>.*#{page}/m
end
