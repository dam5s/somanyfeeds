APP_ROOT = "/home/www/somanyfeeds.com/"
shared_path  = File.join APP_ROOT, 'shared'
current_path = File.join APP_ROOT, 'current'

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 3

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory current_path

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen "/tmp/.sock", :backlog => 64
#listen 8080, :tcp_nopush => true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# feel free to point this anywhere accessible on the filesystem
pid File.join(shared_path, "pids/unicorn.pid")

stderr_path File.join(shared_path, "log/unicorn.stderr.log")
stdout_path File.join(shared_path, "log/unicorn.stdout.log")

preload_app true
