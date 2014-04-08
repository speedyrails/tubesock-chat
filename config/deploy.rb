require 'bundler/capistrano'
load 'deploy/assets'

role :web, "YOUR.HOST.NAME" # Your HTTP server, Apache/etc
role :app, "YOUR.HOST.NAME" # This may be the same as your `Web` server
role :db,  "YOUR.HOST.NAME", :primary => true # This is where Rails migrations will run

set :application, "tubechat"

set :repository,  "https://github.com/speedyrails/tubesock-chat.git"

set(:deploy_to) { "/var/www/apps/#{application}" }

set :user, "deploy"

set :deploy_via, :remote_cache
set :scm, "git"
set :keep_releases, 5

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"

namespace :deploy do

  desc "Tasks to execute after code update"
  task :symlink_configs, :roles => [:app] do
    # run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "if [ -d #{release_path}/tmp ]; then rm -rf #{release_path}/tmp; fi; ln -nfs #{deploy_to}/#{shared_dir}/tmp #{release_path}/tmp"
  end

  desc "Restart server"
  task :restart, :roles => [:app] do
    run "/etc/init.d/puma restart #{application}"
  end
end
