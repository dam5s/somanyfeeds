class Feed::Delicious < Feed

  def self.default
    new(name: 'My Delicious', info: 'username')
  end

  def url=(info)
    new_url = info.normalize_url

    new_url =
      case new_url
      when %r{http(s?)://feeds\.delicious\.com/v2/rss/([^/\.\?]+)$}
        new_url
      when %r{^(http(s?)://)?(delicious.com|del.icio.us)/([^/\.\?]+)/?$}
        "http://feeds.delicious.com/v2/rss/#{$4 || $3}"
      when %r{^[a-zA-Z0-9]+$}
        "http://feeds.delicious.com/v2/rss/#{new_url}"
      else
        nil
      end

    write_attribute :url, new_url
  end

end
