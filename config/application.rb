require 'bundler'
Bundler.require

RACK_ENV  = ENV['RACK_ENV'] || 'development'
RACK_ROOT = File.expand_path( File.join File.dirname(__FILE__), '..' )

require 'sinatra/base'
require 'active_support'
require 'mongoid'

$LOAD_PATH << RACK_ROOT
$LOAD_PATH << File.join( RACK_ROOT, 'lib' )
$LOAD_PATH << File.join( RACK_ROOT, 'app', 'models' )

def require_files(path)
  Dir.glob( File.join RACK_ROOT, path ).each do |file|
    require file
  end
end

#
# Initializers and Environment
#
require_files 'config/initializers/*.rb'
require "config/environments/#{RACK_ENV}"

#
# Core Extensions, and libs
#
require_files 'lib/ext/*.rb'

#
# Models
#
require_files 'app/models/*.rb'

#
# Controllers and Helpers
#
require 'app/controllers/application'
require_files 'app/controllers/*.rb'
require_files 'app/helpers/**/*.rb'
