ASSET_ROOT = RACK_ROOT

require 'jammit'
Jammit.load_configuration(File.join RACK_ROOT, 'config/jammit.yml')

require 'sass'
require 'compass'

Sass.load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"

