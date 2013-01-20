desc 'Jammit!'
task :jammit do
  #
  # Compile scss files
  #
  scss_files = Dir.glob(File.join RACK_ROOT, 'app/assets/*.scss')
  generated_css_files = []

  scss_files.each do |scss|
    generated_css_files << File.join(RACK_ROOT, 'public/css', File.basename(scss).sub('scss', 'css'))

    File.open(generated_css_files.last, 'w') do |file|
      sass_engine = Sass::Engine.for_file(scss, {})
      file.write sass_engine.render
    end
  end

  Jammit.package! config_path: File.join(RACK_ROOT, 'config/jammit.yml')

  #
  # Fix CSS media queries
  #
  Dir.glob(File.join(RACK_ROOT, 'public/jam/*.css')).each do |file|
    css = File.read(file)
    css.gsub!('@media screen and(', '@media screen and (')
    File.open(file, 'w') {|f| f.write css}
  end

  #
  # Cleanup generated css files
  #
  File.delete *generated_css_files
end
