require 'capybara'
require 'capybara/dsl'

module SoManyFeeds::IntegrationExampleGroup

  module Application

    include Rack::Test::Methods
    include Capybara
    include RSpec::Matchers

    def last_response
      page
    end

  end

  module Aggregator

    include Application
    extend ActiveSupport::Concern

    included do
      before { Capybara.app = app }
    end

    def app
      SoManyFeeds::Aggregator
    end

    RSpec.configure do |c|
      c.include self, example_group: { file_path: /\bspec\/integration\/aggregator\// }
    end

  end

  module Manager

    include Application
    extend ActiveSupport::Concern

    included do
      before { Capybara.app = app }
    end

    def app
      SoManyFeeds::Manager
    end

    RSpec.configure do |c|
      c.include self, example_group: { file_path: /\bspec\/integration\/manager\// }
    end

  end

end
