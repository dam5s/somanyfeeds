class Feed::Twitter < Feed

  def self.default
    new(name: 'My Twitter', info: 'username')
  end

  def url=(info)
    new_url = info.normalize_url

    new_url =
      case new_url
      when %r{(http(s?)://)?twitter.com/statuses/user_timeline/([^/\.\?]+)\.rss$}
        new_url.insert(0, 'http://') unless new_url.match /^http/
        new_url
      when %r{^((http(s?)://)?twitter.com/(#!/)?([^/\.\?]+))/?$}
        "http://twitter.com/statuses/user_timeline/#{$5}.rss"
      when %r{^[a-zA-Z0-9_]+$}
        "http://twitter.com/statuses/user_timeline/#{new_url}.rss"
      else
        nil
      end

    write_attribute :url, new_url
  end

end
