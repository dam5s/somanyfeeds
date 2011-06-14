module NavigationHelper

  def all_sources
    @all_sources ||= @user.all_sources
  end

  def default_sources
    @default_sources ||= @user.default_sources
  end

  def rss_links
    if @user
      rss_link @sources.join('+')
    end
  end

  def rss_link(path, title = path)
    haml_tag :link, {
      rel:   'alternate',
      type:  'application/rss+xml',
      href:  "/#{path.presence || 'index'}.rss",
      title: "#{@title} - #{title}"
    }
  end

end
