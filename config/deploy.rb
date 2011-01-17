
# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end


# be sure to change these
set :user, 'griduser' 
set :domain, 'sl-grid.interface.hu' 
#set :domain, 'sl-grid-jt'

set :application, 'gp-web-app'
# file paths
#set :repository, "#{user}@#{git_repo_host}:git/#{application}.git" 
#set :repository, "ssh://git@interface11.repositoryhosting.com/interface11/gp-web-app.git"
set :repository, "git@github.com:tamasjung/gp-web-app.git"
#
#ssh_options[:forward_agent] = true
set :deploy_to, "/home/#{user}/#{application}"

role :app, domain 
role :web, domain 
role :db, domain, :primary => true

# you might need to set this if you aren't seeing password prompts # default_run_options[:pty] = true
# As Capistrano executes in a non-interactive mode and therefore doesn't cause # any of your shell profile scripts to be run, the following might be needed # if (for example) you have locally installed gems or applications. Note: # this needs to contain the full values for the variables set, not simply
# the deltas. # default_environment['PATH']='<your paths>:/usr/local/bin:/usr/bin:/bin' # default_environment['GEM_PATH']='<your paths>:/usr/lib/ruby/gems/1.8'
# miscellaneous options
set :deploy_via, :remote_cache 

set :scm, 'git' 
set :branch, 'master' 
set :scm_verbose, true
set :use_sudo, false
# task which causes Passenger to initiate a restart
namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end 
  
  desc "Stop Passenger"
  task :stop, :roles => :app do
    #run "touch #{current_path}/tmp/stop.txt"
  end

  desc "Start (or un-stop) Passenger"
  task :start, :roles => :app do
    #run "rm -f #{current_path}/tmp/stop.txt"
  end  
end
# optional task to reconfigure databases
after "deploy:update_code", :configure_database 
desc "copy database.yml into the current release path" 
task :configure_database, :roles => :app do
  db_config = "#{deploy_to}/localconfig/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end


after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end


# after "deploy", "deploy:restart_delayed_job"
# 
# namespace :deploy do
#   desc "Restart delayed_job workers"
#   task :restart_delayed_job do
#     run "cd #{release_path} && ./script/delayed_job restart"
#   end
# end
    
    
#   after "deploy:stop",    "delayed_job:stop"
#   after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"


namespace :delayed_job do
  def rails_env
    fetch(:rails_env, false) ? "RAILS_ENV=#{fetch(:rails_env, 'production')}" : ''
  end
  
  desc "Stop the delayed_job process"
  task :stop, :roles => :app do
    run "cd #{current_path};#{rails_env} script/delayed_job stop"
  end

  desc "Start the delayed_job process"
  task :start, :roles => :app do
    run "cd #{current_path};#{rails_env} script/delayed_job start"
  end

  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    run "cd #{current_path};RAILS_ENV=production script/delayed_job -n 10 restart"
  end
end
