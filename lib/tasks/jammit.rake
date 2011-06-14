desc 'Jammit!'
task :jammit do

  Jammit.package! config_path: File.join(RACK_ROOT, 'config/jammit.yml')

  #
  # Fix CSS media queries
  #
  Dir.glob(File.join(RACK_ROOT, 'public/jam/*.css')).each do |file|

    css = File.read(file)
    css.gsub!('@media screen and(', '@media screen and (')
    File.open(file, 'w') {|f| f.write css}

  end

end
