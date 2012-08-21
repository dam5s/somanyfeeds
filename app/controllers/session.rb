module SoManyFeeds

  module Session

    extend ActiveSupport::Concern

    included do

      include SessionHelper

      enable :sessions

      get '/login', no_cache: true do

        redirect '/' if logged_in?
        @title = 'Login'
        respond :login

      end

      post '/login' do

        if user = User.authenticate(params[:login], params[:password])
          session[:user_id] = user.id
          redirect session.delete(:return_to).presence || '/'

        else
          redirect '/login'
        end

      end

      get '/logout', no_cache: true do

        session.delete(:user_id)
        redirect '/'

      end

    end

    def require_login(return_to = request.path)
      @no_cache = true

      unless logged_in?
        session[:return_to] = return_to if return_to
        redirect '/login'
      end
    end

  end

end
