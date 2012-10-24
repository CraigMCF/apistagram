set :application, "cakesta"
set :repository,  "git@github.com:CraigMCF/apistagram.git"

set :scm, :git
set :user, "deployer"
set :branch, "master"

set :use_sudo, false
set :deploy_via, :remote_cache

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :deploy_to, "/home/deployer/sites/#{application}"

role :web, "66.175.221.151"                          # Your HTTP server, Apache/etc
role :app, "66.175.221.151"                          # This may be the same as your `Web` server
role :db,  "66.175.221.151", :primary => true        # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end

  desc "Restarting Passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    release_dir = File.join(release_path, 'apistagram')
    current_dir = File.join(current_release, 'apistagram')
    run "ln -nfs #{shared_path}/database.yml #{release_path}/apistagram/config/database.yml"
    # run "cd #{current_dir} && rake RAILS_ENV=#{rails_env} RAILS_GROUPS=assets assets:precompile"
    # run "cd #{release_dir} && sudo bundle install --without test development"

    # migrate
  end 
end

after "deploy:update_code", "deploy:symlink_shared"