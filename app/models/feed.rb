class Feed

  TYPES = %w(Blog Tumblr Flickr Delicious Twitter Github)

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,    type: String
  field :slug,    type: String
  field :info,    type: String
  field :url,     type: String
  field :default, type: Boolean

  embedded_in :user, inverse_of: :feeds

  attr_accessible :name, :info, :default

  before_save :update_articles
  before_save :queue_job

  def update_articles
    if self.slug_was
      articles = self.user.articles.where(source: self.slug_was)

      Article.collection.update(
        articles.selector,
        {'$set' => {'source' => self.slug}},
        {upsert: false, multi: true, safe: true}
      )
    end
  end

  def queue_job
    require 'daemons/job'

    Daemons::Job.queue(self, priority: :medium) if first_url?
    Daemons::Job.queue(self, priority: :high)   if trying_app?
  end

  def first_url?
    self.user.registered? && self.url.present? && ( self.url_was.blank? || self.new_record? )
  end

  def trying_app?
    self.user.visitor? && self.url.present?
  end

  def name=(value)
    write_attribute :name, value
    self.slug = self.name.try(:to_slug)
  end

  def info=(value)
    write_attribute :info, value
    self.url = value
  end

  def info
    read_attribute(:info).presence || self.url
  end

  require 'feed/parser'
  include Feed::Parser

  def articles
    self.user.articles.where(source: self.slug)
  end

  # For some reason attributes= uses write_attribute,
  # which is silly since I want to be able to override accessors!
  def attributes=(attr)
    attr.each do |name, value|
      self.send("#{name}=", value)
    end
  end

  class << self

    def default(type = nil)
      class_from_type(type).default
    end

    def factory(type, attr)
      class_from_type(type).new attr
    end

    private
    def class_from_type(type)
      begin
        type ||= 'Feed::Blog'

        if type =~ /^Feed::/
          type
        else
          "Feed::#{type}"
        end.constantize
      rescue
        Feed::Blog
      end
    end

  end

end

Feed::TYPES.each { |type| require "feed/#{type.underscore}" }
