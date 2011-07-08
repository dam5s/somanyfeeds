require File.expand_path( '../../../config/application', __FILE__ )

require File.expand_path( '../job', __FILE__ )
require File.expand_path( '../publisher', __FILE__ )
require File.expand_path( '../consumer', __FILE__ )

module Daemons

  module Worker

    PID_FILE = File.join( RACK_ROOT, 'tmp/pids/worker.pid' )

    def self.start!
      shutdown = Proc.new do
        EM.forks.each{ |pid| Process.kill 'KILL', pid }
        exit 0
      end

      Signal.trap 'INT', shutdown
      Signal.trap 'TERM', shutdown

      File.open( PID_FILE, 'w' ) { |f| f << Process.pid }

      AMQP_CONFIG[:consumers].each do |config|
        Consumer.new config
      end

      sleep 5 while EM.forks.present?
    end

    def self.stop!
      if File.exists? PID_FILE
        begin
          Process.kill 'TERM', File.read( PID_FILE ).to_i
        rescue
        ensure
          require 'fileutils'
          FileUtils.rm_f PID_FILE
        end
      end
    end

  end

end # module Daemons
