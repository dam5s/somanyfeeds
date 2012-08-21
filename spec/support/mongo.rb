require 'database_cleaner'
require File.expand_path(File.dirname(__FILE__) + '/../blueprints')

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  # == Truncate database after suite
  #
  config.before :suite do
    DatabaseCleaner.clean
  end

  # == gem mongoid-rspec
  #
  config.include Mongoid::Matchers

  # == Machinist's Sham needs to be reset between tests
  #
  config.before(:all)  { Sham.reset(:before_all)  }
  config.before(:each) { Sham.reset(:before_each) }
end
