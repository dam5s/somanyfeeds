module SoManyFeeds
  module Manager::TryIt

    extend ActiveSupport::Concern

    included do

      before '/try-it/*' do
        @namespace = 'try_it'
        @no_cache = true

        if logged_in?
          redirect '/my-feeds'
        else
          session[:visitor_id] ||= User.create_visitor!.id
        end
      end

      get '/try-it' do
        redirect '/try-it/step-1'
      end

      get '/try-it/step-1' do
        @title = 'Step 1 - Name your site'
        respond :step_1
      end

      post '/try-it/step-1' do
        visitor.update_attribute :site_name, params[:user][visitor.id.to_s][:site_name]
        redirect '/try-it/step-2'
      end

      get '/try-it/step-2' do
        @title = 'Step 2 - Create a feed'
        @feeds = Feed::TYPES.map{ |type| Feed.default type }

        visitor.feeds = []
        visitor.save!
        visitor.articles.destroy_all

        respond :step_2
      end

      post '/try-it/step-2' do
        id   = params[:feed].keys.first
        type = params[:feed][id][:_type]
        attr = {
          id:      id,
          name:    params[:feed][id][:name],
          info:    params[:feed][id][:info],
          default: true
        }

        @feed = Feed.factory(type, attr)
        visitor.feeds << @feed
        visitor.save!

        redirect '/try-it/step-3'
      end

      get '/try-it/step-3' do
        @title = 'Step 3 - See the result!'
        respond :step_3
      end

      get '/try-it/step-3.json' do
        @format = :json
        return visitor.articles.to_json
      end

      get '/try-it/save' do
        @title =  'Save your feed'
        @title << 's' if visitor.feeds.size > 0
        respond :save
      end

      post '/try-it/save' do
        attributes = params['user'][visitor.id.to_s]
        visitor.attributes = attributes
        visitor.registered = true

        if visitor.save
          session[:user_id] = visitor.id.to_s
          session.delete(:visitor_id)

          flash[:notice] = 'Welcome to So Many Feeds!'
          redirect '/my-feeds'
        else
          flash[:error] = 'There were errors saving'
          respond :save
        end
      end

    end

  end
end
