require File.expand_path(File.dirname(__FILE__) + '/../blueprints')

def truncate_db
  Mongoid.master.collections.select do |collection|
    collection.name !~ /system/
  end.each(&:drop)
end

RSpec.configure do |config|
  # == Truncate database after suite
  #
  config.before :suite do
    truncate_db
  end

  # == gem mongoid-rspec
  #
  config.include Mongoid::Matchers

  # == Machinist's Sham needs to be reset between tests
  #
  config.before(:all)  { Sham.reset(:before_all)  }
  config.before(:each) { Sham.reset(:before_each) }
end
