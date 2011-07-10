module ApplicationHelper

  def flash_js
    if xhr?
      @format = :js
      return %Q|Manager.flash("notice", "#{flash[:notice]}", "#{@feed.id}");|
    end
  end

  #
  # Render a template without layout
  #
  # If a collection is given, then iterates over collection
  # and render with each element of the collection as a local
  #
  def partial(template, options={})
    options  = options.merge(layout: false)
    filename = "_#{template}"
    variable = options[:as] || template.to_s.split('.').first.to_sym

    if collection = options.delete(:collection)
      collection.map do |value|
        respond( filename, options.merge(locals: {variable => value}) )
      end.join

    else
      respond filename, options
    end
  end

  #
  # Render template and layout based on @format
  #
  def respond(template, options = {})
    @format ||= :html
    @title  ||= template.to_s.titleize

    template = find_view template
    layout   = find_view 'layout'

    haml template, {layout: request.xhr? ? false : layout}.merge(options)
  end

  #
  # Find template in @controller, or /shared, or /
  # first found, first served
  #
  def find_view( template )
    [ @controller, 'shared', '' ].compact.each do |folder|

      file_name = "#{folder}/#{template}.#{@format}"
      file_path = File.join( settings.views, file_name + '.haml' )

      return file_name.to_sym if File.exist? file_path

    end

    raise "Could not find template #{template} in folders: #{@folders[0..-2].join(', ')}, with setting: #{settings.views}"
  end

  #
  # If format then strip '.' from format
  # Else defaults to :html
  #
  def read_format(format)
    format ||= 'html'
    format.gsub('.', '').gsub('xhr', 'html').to_sym
  end

  def html?
    @format == :html
  end

  def rss?
    @format == :rss
  end

  def xhr?
    request.xhr?
  end

  def no_cache?
    RACK_ENV == 'development' || @no_cache.present?
  end

  def feed_type_class( feed )
    feed.class.to_s.split('::').last.underscore.dasherize
  end

end
