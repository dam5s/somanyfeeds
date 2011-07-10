require 'parser'

class User

  include Mongoid::Document
  include Mongoid::Timestamps

  field :site_name,   type: String
  field :name,        type: String
  field :domain_name, type: String

  embeds_many :feeds
  embeds_many :articles

  require 'user/authentication'
  include User::Authentication

  require 'user/registration'
  include User::Registration

  require 'user/password_reset'
  include User::PasswordReset

  attr_accessible :email,
    :username,
    :password,
    :password_confirmation,
    :site_name,
    :name,
    :domain_name

  def to_label
    name.presence || username.presence || email
  end

  def default_sources
    feeds.select(&:default).map(&:slug).sort
  end

  def all_sources
    feeds.map(&:slug).sort
  end

  def feed(feed_id)
    feeds.find(feed_id) rescue nil
  end

  def update!
    feeds.each(&:update!)
    articles.not_in(source: all_sources).each &:delete
  end

  def self.update_all!
    all.each &:update!
  end

  def self.clean_visitors!
    where(registered: false, :updated_at.lt => 2.hours.ago).delete_all
  end

end
