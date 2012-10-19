require_files('app/helpers/*.rb')

module SoManyFeeds

  class Aggregator < Sinatra::Base

    include Application

    helpers do
      include ApplicationHelper
      include JammitHelper
      include AggregatorHelper
      include ArticleHelper
      include NavigationHelper
    end

    #
    # GET /
    # GET /index
    # GET /index.rss
    # GET /Flickr.rss
    # GET /Twitter+Delicious.html
    # GET /Twitter+Delicious.rss
    # GET /Twitter+Delicious.json
    #
    get %r{/([^\./]+)?(\.html|\.rss|\.json)?} do |sources, format|
      find_user

      @format = read_format(format)

      #
      # Get Articles for sources
      #
      @sources =
        if sources.present? && sources != 'index'
          (sources.split('+').flatten & @user.all_sources).sort
        elsif @user.all_sources.size <= 1
          @user.all_sources
        else
          @user.default_sources
        end

      if @format != :html
        @articles = @user.articles.any_in(source: @sources)

        if s = (params[:s].presence.to_s.size > 3 && /#{params[:s]}/)
          @articles = @articles.any_of( {title: s}, {description: s} )
        end

        @articles = @articles.desc(:date)

        raise Sinatra::NotFound if @articles.blank?
      end

      case @format
      when :json
        return @articles.to_json
      else
        respond :index
      end
    end

    def find_user
      server_name = env['SERVER_NAME']

      unless production?
        server_name.sub! '.dev',   '.com'
        server_name.sub! '.local', '.com'
      end

      @user =
        if server_name =~ /^(.+)\.somanyfeeds\.com$/
          User.where(username: $1).first
        else
          User.where(domain_name: server_name).first
        end

      @user ||= User.first if %w(development test).include? RACK_ENV

      raise Sinatra::NotFound if @user.nil?

      @title = @user.site_name
    end

  end

end
