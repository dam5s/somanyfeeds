require 'open-uri'
require 'nokogiri'

class Feed::Blog < Feed

  def self.default
    new(name: 'My Blog', info: 'your blog url')
  end

  def url=(info)
    if info
      new_url = info.normalize_url
      new_url.insert(0, 'http://') unless info.match /^http/

      if doc = Nokogiri(open new_url) rescue nil

        feed = new_url if doc.css('rss').present? || doc.css('feed').present?

        if feed
          return feed

        else
          links = doc.css('link[rel=alternate]')
          rss   = links.find{|l| l['type'] =~ /rss/ }['href'] rescue nil
          atom  = links.find{|l| l['type'] =~ /atom/}['href'] rescue nil
        end

        feed = rss || atom

        unless feed.match /^http/
        end

        write_attribute :url, feed

      end # if doc
    end # if info
  end

end
