class RSS::Rss::Channel::Item

  include Parser::Entry

  def date
    pubDate
  end

  def entry_id
    guid.content
  end

  alias rss_description description
  def description
    content_encoded || rss_description
  end

end
