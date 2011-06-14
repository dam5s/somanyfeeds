class Feed::Github < Feed

  def self.default
    new(name: 'My Github', info: 'username')
  end

  def url=(info)
    new_url = info.normalize_url

    new_url =
      case new_url
      when %r{^((http(s?)://)?github.com/[^/\.\?]+)(/|\.atom)?$}
        new_url = $1
        new_url.insert(0, 'http://') unless new_url.match /^http/
        new_url + ".atom"
      when %r{^[a-zA-Z0-9]+$}
        "http://github.com/#{new_url}.atom"
      else
        nil
      end

    write_attribute :url, new_url

  end

end
