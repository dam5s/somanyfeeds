require 'app/controllers/session'

module SoManyFeeds

  class Manager < Sinatra::Base

    use Rack::MethodOverride # user PUT / DELETE in forms

    require_files 'app/controllers/manager/*.rb'
    include Application
    include Session
    include Feeds
    include Account

    helpers do
      include ApplicationHelper
      include ManagerHelper
      include JammitHelper
      include SessionHelper
      include FormHelper
    end

    get '/' do

      @title = 'Welcome'
      @commits =
        if development?
          []
        else
          JSON.parse open("https://api.github.com/repos/dam5s/somanyfeeds/commits").read
        end
      respond :index

    end

    get '/my-site' do

      require_login
      redirect "http://#{user.username}.somanyfeeds.com/"

    end

  end

end
