require 'rack-flash'

module SoManyFeeds

  module Session

    extend ActiveSupport::Concern

    included do

      include SessionHelper

      enable :sessions
      use Rack::Flash, sweep: true

      get '/login', no_cache: true do

        redirect '/' if logged_in?
        @title = 'Login'
        respond :login

      end

      post '/login' do

        if user = User.authenticate(params[:login], params[:password])
          session[:user_id] = user.id
          flash[:notice]    = "Logged in as #{user.to_label}"
          redirect session.delete(:return_to).presence || '/'

        else
          flash[:error] = "Login and password didn't match"
          redirect '/login'
        end

      end

      get '/logout', no_cache: true do

        session.delete(:user_id)
        flash[:notice] = "Logged out"
        redirect '/'

      end

    end

    module InstanceMethods

      def require_login(return_to = request.path)
        @no_cache = true

        unless logged_in?
          session[:return_to] = return_to if return_to
          redirect '/login'
        end
      end

    end

  end

end
