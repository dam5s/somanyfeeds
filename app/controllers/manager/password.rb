module SoManyFeeds
  module Manager::Password

    extend ActiveSupport::Concern

    included do

      before '/password/*' do
        @controller = 'password'
      end

      get '/password/forgot' do
        @title = "Forgot your password?"
        respond :forgot
      end

      post '/password/forgot' do
        @title = "Forgot your password?"

        if User.send_password_reset_email! params[:email]
          flash[:notice] = "Instructions have been emailed to you"
          redirect '/login'
        else
          flash[:error] = "Sorry, email was not found"
          redirect '/password/forgot'
        end
      end

      get %r{/password/reset/([0-9a-f]{128})} do |hash|
        if find_user(hash)
          @title = 'Reset password'
          respond :reset 
        end
      end

      post %r{/password/reset/([0-9a-f]{128})} do |hash|
        if find_user(hash)
          @title = 'Reset password'
          p = params['user'].values.first

          @user.password = p['password']
          @user.password_confirmation = p['password_confirmation']

          if @user.valid?
            @user.reset_hash = nil
            @user.save!

            flash[:notice] = 'Password updated successfully'
            session[:user_id] = user.id
            redirect '/my-feeds'
          else
            flash[:error] = 'There were errors changing your password'
            respond :reset
          end
        end # if find
      end

    end # included

    def find_user hash
      conditions = {
        :reset_hash => hash, 
        :reset_hash_created_at.gt => 6.hours.ago
      }

      unless @user = User.where(conditions).first
        flash[:error] = 'Password reset hash is invalid'
        redirect '/login'
      end

      @user
    end

  end # Manager::Password
end # SoManyFeeds
