Mongoid.configure do |config|
  settings = YAML::load_file(File.join RACK_ROOT, 'config/mongoid.yml')

  config.from_hash settings[RACK_ENV]
end
