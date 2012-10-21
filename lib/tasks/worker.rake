require File.expand_path( '../../daemons/worker', __FILE__ )

namespace :worker do

  task :execute do
    User.update_all!
  end

  task :start do
    Daemons::Worker.start!
  end

  task :stop do
    Daemons::Worker.stop!
  end

end
