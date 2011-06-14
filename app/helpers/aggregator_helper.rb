module AggregatorHelper

  def source_link(feed)
    source = feed.slug
    name   = feed.name

    classes     = "source #{'selected' if @sources.include?(source)}"
    new_sources =
      if @sources.include?(source)
        @sources - [source]
      else
        (@sources + [source]).sort
      end

    link  = "/"
    link += new_sources.join('+') if new_sources != default_sources

    haml_tag(:a, {href: link, class: classes, 'data-source' => source}) do
      haml_concat(name)
    end
  end

end
