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

        unless feed
          links = doc.css('link[rel=alternate]')
          rss   = links.find{|l| l['type'] =~ /rss/ }['href'] rescue nil
          atom  = links.find{|l| l['type'] =~ /atom/}['href'] rescue nil
          feed  = append_host( rss || atom, new_url )
        end

        write_attribute :url, feed

      end # if doc
    end # if info
  end

private

  def append_host( feed, base_url )
    return feed if feed.blank? || feed.match(/^http/)

    host =
      if feed.match(%r[^/]) # absolute path
        base_url.match( %r[^(http://[^/]+)/] )[1]
      else # relative path
        base_url.match( %r[^(http://.+/)[^/]*$] )[1]
      end

    host + feed
  end

end
