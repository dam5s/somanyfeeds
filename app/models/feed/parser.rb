require 'open-uri'

module Feed::Parser

  def update!
    existing = self.articles.all

    entries.each do |entry|
      if ntry = existing.detect{|e| e.entry_id == entry.entry_id}
        ntry.attributes = entry.attributes
        ntry.save!
      else
        feed_type = self.class.to_s.demodulize.underscore
        entry.save!(source: self.slug, user: self.user, feed_type: feed_type)
      end
    end

    if self.articles.count > 10
      excess = self.articles.desc(:date).skip(10)
      self.user.articles.delete_all(conditions: { id: excess.map(&:id) })
    end
  end

  def parse
    @xml =
      begin
        xml = open(url, 'r', read_timeout: 5.0)
        RSS::Parser.parse(xml)
      rescue Exception => e
        return if RACK_ENV == 'test'

        $stderr.puts "**************************************************"
        $stderr.puts "There was an error fetching the feed #{name}, for #{user.try(:to_label) || 'no user'}"
        $stderr.puts e.message
        $stderr.puts e.backtrace
        $stderr.puts "**************************************************"
        nil
      end
  end

  def xml
    @xml || parse && @xml
  end

  def entries
    return [] unless xml.present?

    if xml.respond_to?(:entries)
      xml.entries
    else
      xml.items
    end
  end

end
