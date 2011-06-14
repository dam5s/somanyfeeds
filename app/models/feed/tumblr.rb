class Feed::Tumblr < Feed

  def self.default
    new(name: 'My Tumblr', info: 'username')
  end

  def url=(info)
    new_url = info.normalize_url

    new_url =
      case new_url
      when %r{^((http(s?)://)?[^/\?]+\.[^/\?]+)(/|/rss)?$}
        new_url = $1
        new_url.insert(0, 'http://') unless new_url.match /^http/
        new_url + "/rss"
      when %r{^[a-zA-Z0-9]+$}
        "http://#{new_url}.tumblr.com/rss"
      else
        nil
      end

    write_attribute :url, new_url
  end

end
