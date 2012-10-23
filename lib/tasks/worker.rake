namespace :worker do
  task :execute do
    User.update_all!
  end
end
