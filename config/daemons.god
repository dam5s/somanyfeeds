RACK_ROOT = File.expand_path '../..', __FILE__
RACK_ENV  = ENV['RACK_ENV'] || 'production'

God.watch do |w|

  w.interval = 30.seconds
  w.name     = "somanyfeeds-worker"
  w.env      = { "RACK_ENV" => RACK_ENV }
  w.start    = "cd #{RACK_ROOT}; rake worker:start"
  w.stop     = "cd #{RACK_ROOT}; rake worker:stop"
  w.log      = File.join RACK_ROOT, 'log/worker.stdout.log'
  w.err_log  = File.join RACK_ROOT, 'log/worker.stderr.log'
  w.pid_file = File.join RACK_ROOT, 'tmp/pids/worker.pid'

  # clean pid files before start if necessary
  w.behavior(:clean_pid_file)

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 2
      c.transition = :start
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_exits)
  end

  # restart if memory or cpu is too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.interval = 20
      c.above = 50.megabytes
      c.times = [3, 5]
    end

    on.condition(:cpu_usage) do |c|
      c.interval = 10
      c.above = 10.percent
      c.times = [3, 5]
    end
  end

end
