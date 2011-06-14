module Daemons

  class Job

    attr_accessor :feed, :key

    def self.queue( feed, opts = {} )
      new( feed, opts ).publish!
    end

    def initialize( feed, opts = {} )
      self.feed = feed
      self.key = "jobs.#{opts[:priority]}"
    end

    def publish!
      bunny do |b|
        b.exchange( AMQP_CONFIG[:topic], :type => :topic )
         .publish( Marshal.dump( self ), :key => self.key )
      end
    end

    def run!
      feed.update!
    end

    def to_s
      "Job for feed: #{feed.name}, user: #{feed.user.username}, key: #{key}"
    end

  private

    def bunny
      @@bunny ||= Bunny.new( AMQP_CONFIG[:server] )
      return @@bunny unless block_given?

      @@bunny.start
      yield @@bunny
      @@bunny.stop
    end

  end

end
