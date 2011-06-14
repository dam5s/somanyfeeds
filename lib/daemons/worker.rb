require File.expand_path( '../boot', __FILE__ )
require File.expand_path( '../job', __FILE__ )

module Daemons

  class Publisher

    def initialize( options = {} )
      @@job ||= 1

      EM.fork(1) {
        exch = AMQP::Channel.new.topic AMQP_CONFIG[:topic]

        EM.add_periodic_timer(1) do
          priority = %w(high medium low)[ rand(3) ]

          puts "Publishing job num #{@@job} with priority #{priority}"
          exch.publish Marshal.dump( "Job num: #{@@job}" ), :key => "jobs.#{priority}"
          @@job += 1
        end
      }
    end

  end # class Publisher

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

  end # class Consumer

end # module Daemons

AMQP_CONFIG[:consumers].each do |config|
  Daemons::Consumer.new config
end

#Daemons::Publisher.new

# wait on forks
while !EM.forks.empty?
  sleep(5)
end
