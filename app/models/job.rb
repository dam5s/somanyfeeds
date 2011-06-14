class Job

  include Mongoid::Document
  include Mongoid::Timestamps

  require 'job/state'
  include Job::State

  referenced_in :user

  field :feed_id, type: String

  def feed
    @feed ||= user.feed(feed_id)
  end

  def run!
    feed.update!
    done!
  end

  class << self
    def run_all!
      queued.all.each &:run!
    end

    def queue(feed)
      create(user: feed.user, feed_id: feed.id)
    end
  end

end
