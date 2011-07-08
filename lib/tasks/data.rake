require 'config/application'

namespace :data do

  desc 'Set registered users'
  task :set_registered_users do

    Article.delete_all

    User.all.each do |user|
      user.registered = true
      user.save!
      user.update!
    end

  end

end
