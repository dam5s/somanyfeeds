require 'database_cleaner'

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
end
