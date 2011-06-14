module SoManyFeeds
  module Manager::Feeds

    extend ActiveSupport::Concern

    included do

      before '/*-feed*' do
        @namespace = 'user'
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
            feed_notice(@feed, 'updated')

            false
          else
            @feed = Feed.factory(type, attr)
            user.feeds << @feed
            user.save!
            feed_notice(@feed, 'created')

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
          feed_notice(feed, 'deleted')
        end

        redirect '/my-feeds'

      end

      get '/new-feed/:type' do

        require_login
        @feed = Feed.default(params[:type])
        respond :new_feed

      end

    end # included

    module InstanceMethods

      def feed_notice(feed, action)
        flash.now[:notice] = %Q|Feed #{action}|
      end

    end

  end # Manager::Feeds
end # SoManyFeeds
