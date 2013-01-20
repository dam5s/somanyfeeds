namespace :worker do
  desc 'Update all user feeds'
  task :execute do
    User.update_all!
  end
end
