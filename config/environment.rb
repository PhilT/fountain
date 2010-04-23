RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'authlogic'
  config.gem 'bluecloth'
  config.gem 'db2s3'
  config.gem 'haml'
  config.gem 'paper_trail'
  config.gem 'whenever', :lib => false

  config.action_controller.session = {
    :session_key => '_buzz_session',
    :secret      => 'af4ec4ae80383c85f2513693681030942731bd5b026d16e416bfd2db6fa176d7e87330deb0ad65d2a923e0d0e93fc9e2e522738078eb230733a3d85b9c7d2d78'
  }
end

Sass::Plugin.options[:template_location] = RAILS_ROOT + '/app/styles'

