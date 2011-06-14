require 'config/application'

namespace :data do

  desc 'Convert Feeds to Feed::Blog'
  task :convert_feeds_to_blog do

    User.all.each do |user|
      converted_feeds = user.feeds.map do |f|
        if f.class == Feed
          Feed::Blog.new(
            name:    f.name,
            slug:    f.slug,
            info:    f.info || f.url,
            default: f.default
          )
        else
          f
        end
      end

      user.feeds = converted_feeds
      user.save!
    end

  end

  desc 'Set registered users'
  task :set_registered_users do

    User.all.each do |user|
      user.update_attribute :registered, true
    end

  end

end
