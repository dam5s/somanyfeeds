require 'digest/md5'

module JammitHelper

  def fingerprint(type, package)
    path = File.join(RACK_ROOT, 'public/jam', "#{package}.#{type}")

    if File.exist? path
      Digest::MD5.hexdigest(File.read path)
    else
      nil
    end
  end

  def jammit(type, package, options = {})
    paths = 
      if development?
        Jammit.packager.individual_urls(package, type)
      else
        ["/jam/#{package}.#{type}/#{fingerprint(type, package)}"]
      end

    if options[:async] && production?
      haml_tag :script do
        haml_concat "head.js(#{paths.map{|p|"'#{p}'"}.join ','});"
      end
    else
      paths.each { |p| asset(type, p, options) }
    end
  end

  def asset(type, path, options)
    case type
    when :js
      haml_tag :script, src: path
    when :css
      haml_tag :link, rel: 'stylesheet', href: path
    end
  end

  def manager_package
    package = "#{@controller}_manager"

    if Jammit.configuration[:javascripts].keys.include? package
      package
    else
      :jquery
    end
  end

  def google_web_fonts
    haml_tag :link, href: 'http://fonts.googleapis.com/css?family=Neuton&v1', rel: 'stylesheet', type: 'text/css'
  end

end
