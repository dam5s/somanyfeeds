ENV["RACK_ENV"] ||= 'test'

require 'bundler'
Bundler.require

require 'ruby-debug'
require 'ap'

# Require Machinist before any Mongoid Document is loaded
# That is because Mongoid doesn't use inheritence, and including
# a module in an already included module won't update
# the existing mixin.
#
require 'machinist/mongoid'

require File.expand_path('../../config/application', __FILE__)
require 'rspec'
require 'rack/test'
require 'mongoid-rspec'
require 'akephalos'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[ File.join(RACK_ROOT, 'spec/support/**/*.rb') ].each {|f| require f}

Capybara.javascript_driver = :akephalos

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:each, js: true) do
    Capybara.current_driver = Capybara.javascript_driver
  end

  config.after(:each, js: true) do
    Capybara.current_driver = Capybara.default_driver
  end
end
