module Daemons

  class Consumer

    def initialize( options = {} )
      opts = { workers: 1 }.merge( options )

      EM.fork( opts[:workers] ) {
        exch = AMQP::Channel.new.topic AMQP_CONFIG[:topic]

        AMQP::Channel.new.queue( opts[:name] ).bind(exch, :key => opts[:key]).subscribe do |job|
          job = Marshal.load job
          print "[#{ opts[:name] }] Processing #{job}..."

          job.run!
          puts "... done."
        end
      }
    end

  end

end
