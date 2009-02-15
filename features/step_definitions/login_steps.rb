Given /^I am not logged in$/ do
end

When /^I fill in the correct password$/ do
  fill_in "Password", :with => 'reason'
end
