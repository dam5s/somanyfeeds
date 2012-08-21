module SoManyFeeds
  module Manager::Feeds

    extend ActiveSupport::Concern

    included do

      before '/*-feed*' do
        @controller = 'user'
      end

      get '/my-feeds' do

        require_login
        respond :my_feeds

      end

      post '/my-feeds/:id' do

        require_login

        id   = params[:id]
        type = params[:feed][id][:_type]
        attr = {
          id:      params[:id],
          name:    params[:feed][id][:name],
          info:    params[:feed][id][:info],
          default: params[:feed][id][:default].presence == 'yes'
        }

        @created =
          if @feed = user.feed(id)
            @feed.attributes = attr
            @feed.save!

            false
          else
            @feed = Feed.factory(type, attr)
            user.feeds << @feed
            user.save!

            true
          end

        if xhr? && @created
          respond :feed
        elsif xhr?
          flash_js
        else
          redirect '/my-feeds'
        end

      end

      delete '/my-feeds/:id' do

        require_login

        if feed = user.feed(params[:id])
          feed.destroy
        end

        redirect '/my-feeds'

      end

      get '/new-feed/:type' do

        require_login
        @feed = Feed.default(params[:type])
        respond :new_feed

      end

    end # included

  end # Manager::Feeds
end # SoManyFeeds
