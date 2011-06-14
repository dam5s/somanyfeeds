# Standard exit for INT/TERM signals - kill all forked processes and stop eventmachine & AMQP
Signal.trap('INT') {
  unless EM.forks.empty?
    EM.forks.each do |pid|
      Process.kill('KILL', pid)
    end
  end
  AMQP.stop{ EM.stop }
  exit(0)
}

Signal.trap('TERM') {
  unless EM.forks.empty?
    EM.forks.each do |pid|
      Process.kill('KILL', pid)
    end
  end
  AMQP.stop{ EM.stop }
  exit(0)
}

require File.expand_path( '../../../config/application', __FILE__ )

#AMQP.settings.merge! AMQP_CONFIG[:server]
