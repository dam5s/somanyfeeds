set :keep_releases, 10
set :application, "So Many Feeds"
set :repository,  "git@github.com:dam5s/somanyfeeds.git"

set :scm,           :git
set :monit_group,   "www"
set :runner,        "www"

set :server_addr, "184.106.113.138"
ssh_options[:port] = 2022

set :rack_env,    "production"
set :user,        "www"

role :web, server_addr
role :app, server_addr, :mongrel => false, :delayed_job => false, :memcached => false
role :db,  server_addr, :primary => true

set :branch,     "master"
set :deploy_to,  "/home/www/somanyfeeds.com"
set :deploy_via, :copy

RVM_RUBY = 'ruby-1.9.2-p180'
RVM_PATH = '/home/www/.rvm'

set :default_environment, {
          'PATH' => "#{RVM_PATH}/gems/#{RVM_RUBY}@global/bin:#{RVM_PATH}/gems/#{RVM_RUBY}/bin:$PATH",
  'RUBY_VERSION' => RVM_RUBY,
      'GEM_HOME' => "#{RVM_PATH}/gems/#{RVM_RUBY}",
      'GEM_PATH' => "#{RVM_PATH}/gems/#{RVM_RUBY}@global:#{RVM_PATH}/gems/#{RVM_RUBY}",
   'BUNDLE_PATH' => "#{RVM_PATH}/gems/#{RVM_RUBY}"
}


before "deploy", "db:dump"

# Task to run bundle install - per instructions from EngineYard
namespace :bundler do
  desc "Automatically installed your bundled gems if a Gemfile exists"
  task :bundle_gems do
    run "if [ -f #{release_path}/Gemfile ]; then cd #{release_path} && bundle install --path #{shared_path}/bundle --without test,development; fi"
  end
end

namespace :deploy do
  task :config, :roles => :app do
    run "cd #{current_path} && ln -sf #{shared_path}/mongoid.yml config/mongoid.yml"
  end

  task :restart, :roles => :app do
    run "cd #{current_path} && ln -sf #{shared_path}/unicorn.rb config/unicorn.rb"
    run "if [ -f #{shared_path}/pids/unicorn.pid ]; then kill -USR2 `cat #{shared_path}/pids/unicorn.pid`; else cd #{current_path} && RACK_ENV=production bundle exec unicorn -c config/unicorn.rb -D; fi"
  end
end

namespace :db do
  task :dump do
    now = Time.now
    backup_time = [now.year,now.month,now.day,now.hour,now.min,now.sec].join('-')
    run "mkdir -p #{shared_path}/db_backups/#{backup_time}"
    run "/usr/bin/mongodump --db somanyfeeds_production -o #{shared_path}/db_backups/#{backup_time}"
  end

  task :import do
    folder = capture("ls -tr #{shared_path}/db_backups | tail -n 1").chomp

    if folder.empty?
      logger.important "No backups found"
    else
      logger.debug "Loading db_backups/#{folder} into local development database"
      run "cd #{shared_path}/db_backups && tar -cjf #{folder}.tbz2 #{folder}"
      get "#{shared_path}/db_backups/#{folder}.tbz2", "db_backups/#{folder}.tbz2"
      run "cd #{shared_path}/db_backups && rm -f *.tbz2"

      puts "tar xjf db_backups/#{folder}.tbz2 -C db_backups"
      `tar xjf db_backups/#{folder}.tbz2 -C db_backups`

      puts "mongorestore db_backups/#{folder}/somanyfeeds_production -h localhost -d somanyfeeds_development --drop"
      `mongorestore db_backups/#{folder}/somanyfeeds_production -h localhost -d somanyfeeds_development --drop`

      logger.debug "command finished"
    end
  end
end

after "deploy:symlink", "deploy:config", "bundler:bundle_gems"
