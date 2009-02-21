# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatters/unicode' # Comment out this line if you don't want Cucumber Unicode support
Cucumber::Rails.use_transactional_fixtures

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

# Comment out the next two lines if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'
require 'webrat/rspec-rails'

Page.create!(:name => 'HomePage', :title => 'Home Page', :content => '') unless Page.find_by_name('HomePage')

content = <<END
*some bold text* WikiWordsPointToOtherPages

bc. WikiWordsNotLinkedInCodeTags


h2. A Heading
END
Page.create!(:name => 'WikiPage', :title => 'Wiki Page', :content => content) unless Page.find_by_name('WikiPage')
