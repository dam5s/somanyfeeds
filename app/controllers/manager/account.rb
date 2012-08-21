module SoManyFeeds
  module Manager::Account

    extend ActiveSupport::Concern

    included do

      before '/my-account' do
        @controller = 'user'
      end

      get '/my-account' do

        require_login
        respond :my_account

      end

      post '/my-account' do

        require_login

        attributes = params['user'][user.id.to_s]
        user.attributes = attributes

        user.save

        respond :my_account

      end

    end # included

  end # Manager::Account
end # SoManyFeeds
