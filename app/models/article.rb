class Article

  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,       type: String
  field :link,        type: String
  field :description, type: String
  field :date,        type: DateTime
  field :entry_id,    type: String
  field :source,      type: String

  embedded_in :user

  index :date

  require 'article/json'
  include Article::JSON

  def feed_name
    user.feeds.where(slug: source).first.name
  end

end
