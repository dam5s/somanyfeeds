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
        if RACK_ENV == 'development'
          [
            {
              "author" => {
                "avatar_url" => "https://secure.gravatar.com/avatar/0bf3294f015263c737080b66ad11b6f8?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
                "login" => "dam5s"
              },
              "commit" => {
                "message" => "Removed mailer initializer"
              }
            },
            {
              "author" => {
                "avatar_url" => "https://secure.gravatar.com/avatar/0bf3294f015263c737080b66ad11b6f8?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
                "login" => "dam5s",
              },
              "commit" => {
                "message" => "Added SCSS assets support instead of raw CSS files"
              }
            },
            {
              "author" => {
                "avatar_url" => "https://secure.gravatar.com/avatar/0bf3294f015263c737080b66ad11b6f8?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
                "login" => "dam5s"
              },
              "commit" => {
                "message" => "Fixed Jammit integration"
              }
            },
            {
              "author" => {
                "avatar_url" => "https://secure.gravatar.com/avatar/0bf3294f015263c737080b66ad11b6f8?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
                "login" => "dam5s"
              },
              "commit" => {
                "message" => "Jammit!"
              }
            },
            {
              "author" => {
                "avatar_url" => "https://secure.gravatar.com/avatar/0bf3294f015263c737080b66ad11b6f8?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
                "login" => "dam5s"
              },
              "commit" => {
                "message" => "Upgraded gems, and ruby 1.9.3\n\nBuild is broken on acceptance for some reason, it still seems to actually work though.",
              }
            },
            {
              "author" => {
                "avatar_url" => "https://secure.gravatar.com/avatar/0bf3294f015263c737080b66ad11b6f8?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
                "login" => "dam5s"
              },
              "commit" => {
                "message" => "Jammit!"
              }
            }
          ]
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
