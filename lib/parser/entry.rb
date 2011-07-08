require 'article'

module Parser

  module Entry

    def save!(options = {})
      user = options.delete(:user)
      user.articles << Article.new(attributes.merge options)
      user.save!
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
