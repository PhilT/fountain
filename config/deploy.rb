set :application, "wiki"
set :repository,  "git://github.com/PhilT/buzz.git"

set :scm, :git
set :branch, 'master'

set :user, 'ubuntu'
set :deploy_to, nil

set :use_sudo, false
set :keep_releases, 3

set :target_env, 'production'

set :ssh_options, {:forward_agent => true}
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "default.key")]

after 'deploy', 'deploy:cleanup'

role :web, "wiki.puresolo.com"                          # Your HTTP server, Apache/etc
role :app, "wiki.puresolo.com"                          # This may be the same as your `Web` server
role :db,  "wiki.puresolo.com", :primary => true # This is where Rails migrations will run

after "deploy:update_code", "gems:install"
after "deploy:update_code", "copy_db_config"
after "deploy:symlink", "deploy:update_crontab"

before "deploy", "check_env"

task :check_env do
  unless deploy_to
    puts "You must do 'cap wiki deploy'"
    exit
  end
end

task :wiki do
  set :deploy_to, '/data/wiki'
end

namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    run "cd #{current_release} && #{sudo} rake gems:install"
  end
end

task :copy_db_config do
  run "cp #{deploy_to}/shared/database.yml #{current_release}/config/database.yml"
  run "cp #{deploy_to}/shared/s3_backup.rb #{current_release}/config/initializers/s3_backup.rb"
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    sudo "cd #{release_path} && whenever --update-crontab #{application}"
  end
end

