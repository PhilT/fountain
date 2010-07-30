set :application, "wiki"
set :repository,  "git://github.com/PhilT/fountain.git"

set :scm, :git
set :user, 'www'
set :deploy_to, '/data/wiki'
set :branch, ENV['BRANCH']
set :deploy_via, :remote_cache
set :initial_deploy, false
set :use_sudo, false
set :keep_releases, 3

set :target_env, 'staging'
server "wiki.puresolo.com", :app, :web, :db, :primary => true

ssh_options[:user] = "www"
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "app_server.key")]

after 'deploy', 'deploy:cleanup'
after "deploy:update", "gems:install", "db:copy_config", "db:migrate"
after "deploy:symlink", "deploy:update_crontab"
after "deploy:setup", "gems:setup"
after "deploy:initial", "deploy"

before "deploy", "check_env"

task :check_env do
  unless branch
    puts "You must do 'cap deploy BRANCH=<branch>'"
    exit
  end
end

task :velocity do
  set :application, "velocity"
  set :deploy_to, '/data/velocity'
end

task :todo do
  set :application, "todo"
  set :deploy_to, '/data/todo'
end

namespace :gems do
  desc "Install bundler"
  task :setup, :roles => :app do
    run "gem install bundler"
  end

  desc "Install gems"
  task :install, :roles => :app do
    run "cd #{release_path} && bundle install"
  end
end

namespace :db do
  task :setup do
    run "cd #{current_path} && rake db:setup && rake db:restore FROM_ENV=staging"
  end

  task :migrate do
    run "cd #{release_path} && rake db:migrate db:seed" unless initial_deploy
  end

  task :copy_config do
    run "cp #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
end

namespace :deploy do
  task :initial do
    set :initial_deploy, true
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cp /data/s3_backup.rb #{current_release}/config/initializers/s3_backup.rb"
    run "cd #{release_path} && whenever --update-crontab #{application}" unless initial_deploy || target_env == 'staging'
  end

end

