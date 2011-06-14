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
        new_url.gsub!('http://', 'https://')
        new_url.insert(0, 'https://') unless new_url.match /^http/
        new_url + ".atom"
      when %r{^[a-zA-Z0-9]+$}
        "https://github.com/#{new_url}.atom"
      else
        nil
      end

    write_attribute :url, new_url

  end

end
