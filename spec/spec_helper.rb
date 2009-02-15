# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  # Are these needed if we're not using fixtures?
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
end

require 'spec/factories'
