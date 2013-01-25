require 'forgery'

module ObjectCreationMethods

private

  def setup_object(object, attributes, defaults)
    defaults.merge(attributes).each do |name, value|
      if value.respond_to?(:call)
        value =
          if value.arity == 1
            value.call(object)
          else
            value.call
          end
      end

      object.send("#{name}=", value)
    end

    object
  end

  def self.define(klass, method_name = nil, &block)
    method_name ||= klass.to_s.underscore

    define_method "new_#{method_name}", ->(attributes = {}) {
      defaults = block.call
      setup_object(klass.new, attributes, defaults)
    }

    define_method "create_#{method_name}", ->(attributes = {}) {
      send("new_#{method_name}").tap(&:save!)
    }
  end

public

  define User do
    {
      username: -> { Forgery::Internet.user_name },
      email: -> { Forgery::Internet.email_address },
      password: -> { Forgery::Basic.password },
      password_confirmation: ->(user) { user.password }
    }
  end

  define Feed do
    {
      name: -> { %w(Twitter Delicious Flickr Blog Tumblr).sample },
      url: ->(feed) { "http://example.com/path/to/#{feed.name}.atom" },
      default: true
    }
  end

  define Feed::Blog, 'blog_feed' do
    { name: 'Blog', url: nil }
  end

  define Feed::Github, 'github_feed' do
    { name: 'Github' }
  end

  define Feed::Twitter, 'twitter_feed' do
    { name: 'Twitter' }
  end

  define Feed::Tumblr, 'tumblr_feed' do
    { name: 'Tumblr' }
  end

  define Feed::Delicious, 'delicious_feed' do
    { name: 'Delicious' }
  end

  define Article do
    {
      title: -> { Forgery::LoremIpsum.sentence + Forgery::Basic.text },
      description: -> { Forgery::LoremIpsum.paragraph + Forgery::Basic.text },
      date: -> { Forgery::Date.date },
      entry_id: -> { Forgery::Basic.text },
      source: -> { %w(Twitter Delicious Flickr Blog Tumblr).sample }
    }
  end
end
