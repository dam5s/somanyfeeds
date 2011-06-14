class Feed::Flickr < Feed::Blog

  def self.default
    new(name: 'My Flickr', info: 'your flickr photostream url')
  end

end
