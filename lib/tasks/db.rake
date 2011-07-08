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

end # db
