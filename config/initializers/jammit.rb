ASSET_ROOT = RACK_ROOT

require 'jammit'
Jammit.load_configuration(File.join RACK_ROOT, 'config/jammit.yml')
