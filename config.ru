require 'rubygems'

require File.join(File.dirname(__FILE__), 'config/application')

module Rack
  class URLMap
    def remap(map)
      @mapping = map.map do |location, app|
        host =
          if location =~ %r{\Ahttps?://(.*?)/.*}
            $1
          else
            @default = app
            nil
          end

        [host, app]
      end
    end

    def call(env)
      path = env["PATH_INFO"]
      script_name = env['SCRIPT_NAME']

      hHost, sName, sPort = env.values_at('HTTP_HOST', 'SERVER_NAME', 'SERVER_PORT')

      @mapping.each do |host, app|
        return app.call(env) if hHost =~ /^#{host}$/ || sName =~ /^#{host}$/
      end

      @default.call(env)
    ensure
      env.merge! 'PATH_INFO' => path, 'SCRIPT_NAME' => script_name
    end
  end
end

map 'http://(www\.)?somanyfeeds.*/' do
  run SoManyFeeds::Manager
end

map '*' do
  run SoManyFeeds::Aggregator
end
