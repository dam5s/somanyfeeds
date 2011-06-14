require 'article'

module Parser

  module Entry

    def save!(options = {})
      Article.new(attributes.merge options).save!
    end

    def attributes
      {
        title: title,
        link: link,
        description: description,
        date: date,
        entry_id: entry_id
      }
    end

  end

end
