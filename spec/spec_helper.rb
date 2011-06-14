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

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[ File.join(RACK_ROOT, 'spec/support/**/*.rb') ].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
end
