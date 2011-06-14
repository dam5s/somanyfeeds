require_files('app/models/*.rb')
require_files('app/helpers/*.rb')

module SoManyFeeds

  module Application

    extend ActiveSupport::Concern
    include ApplicationHelper

    included do

      use Rack::Mole, rackamole_config if production?

      set :views,  File.join(RACK_ROOT, 'app/views', to_var)
      set :haml, format: :html5
      set :public, File.join(RACK_ROOT, 'public') if development?

      mime_type :rss,  'application/rss+xml'
      mime_type :html, 'text/html'
      mime_type :js,   'application/javascript'
      mime_type :css,  'text/css'
      mime_type :json, 'application/json'

      class << self
        def get_with_no_cache(path, options={}, &block)
          if options.delete(:no_cache)
            no_cache = Proc.new { @no_cache = true }
            before(path, &no_cache)
          end

          get_without_no_cache(path, options, &block)
        end

        alias_method_chain :get, :no_cache
      end

      after do
        @format ||= :html

        content_type(@format, charset: 'utf-8')

        case @format
        when :html, :rss, :json
          # 5 minutes cache
          expires 60*5, :public unless no_cache?
        else
          # 1 year cache
          expires 60*60*24*30*12, :public
        end
      end

      #
      # GET /jam/default.css
      # GET /jam/default.js
      # GET /jam/modernizr.js
      #
      get %r{/jam/([^\./]+)\.(css|js)(.*)} do |package, format, fingerprint|

        @package, @format = params['captures']

        if file = serve_file_from_path("#{@package}.#{@format}", 'jam')
          return file
        end

        case @format.to_sym
        when :js
          Jammit.packager.pack_javascripts(@package)
        when :css
          Jammit.packager.pack_stylesheets(@package, nil)
        else
          raise Sinatra::NotFound
        end

      end

      #
      # GET /img/loading.gif
      #
      get '/img/:image' do

        @image = params[:image]
        @format = @image.split('.').last.to_sym

        if file = serve_file_from_path(@image, 'img')
          return file
        else
          raise Sinatra::NotFound
        end

      end

      get '/favicon.ico' do
      end


      error Jammit::PackageNotFound do
        error_404
      end

      not_found do
        error_404
      end

      error do
        error_500
      end

    end

    module InstanceMethods

      def error_404
        if html?
          respond 404
        else
          'Oops we could not find what you are looking for!'
        end
      end

      def error_500
        if html?
          respond 500
        else
          'Oops there was an error processing your request!'
        end
      end

      def serve_file_from_path(file, path)
        path = File.join(RACK_ROOT, 'public', path)
        file_path = File.expand_path( File.join(path, file) )

        if File.exist?(file_path) && File.dirname(file_path) == path
          return File.read(file_path)
        end

        return nil
      end

    end

    module ClassMethods

      def to_var
        to_s.downcase.split('::').last
      end

      def rackamole_config
        {
          app_name: to_var,
          user_key: :user_id,
          email: {
            from: "rackamole+#{to_var}@somanyfeeds.com",
            to: "damien@meliondesign.com",
            alert_on: [ Rackamole.perf, Rackamole.fault ]
          },
          store: Rackamole::Store::MongoDb.new(db_name: "mole_#{to_var}_#{RACK_ENV}_mdb")
        }
      end

    end

  end

end
