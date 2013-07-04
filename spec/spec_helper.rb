ENV["RACK_ENV"] ||= 'test'

require 'bundler'
Bundler.require

require 'ruby-debug'
require 'ap'

require File.expand_path('../../config/application', __FILE__)
require 'rspec'
require 'rack/test'
require 'mongoid-rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[ File.join(RACK_ROOT, 'spec/support/**/*.rb') ].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.include ObjectCreationMethods
end
