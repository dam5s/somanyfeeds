require 'config/application'
require 'parser'

namespace :db do

  namespace :feeds do

    desc 'Purge Articles'
    task :purge do
      Article.delete_all
    end

    desc 'Update feeds'
    task :update do
      User.update_all!
    end

  end # feeds

  namespace :jobs do

    desc 'Run jobs'
    task :run do
      Job.run_all!
    end

  end # jobs

end # db
