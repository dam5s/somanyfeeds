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

  end

end
