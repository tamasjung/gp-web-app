
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
#set :domain, 'sl-grid.interface.hu' 
set :domain, '10.0.0.35'
set :application, 'gp-web-app'
# file paths
#set :repository, "#{user}@#{git_repo_host}:git/#{application}.git" 
set :repository, "ssh://git@interface11.repositoryhosting.com/interface11/gp-web-app.git"
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
end
# optional task to reconfigure databases
after "deploy:update_code", :configure_database 
desc "copy database.yml into the current release path" 
task :configure_database, :roles => :app do
  db_config = "#{deploy_to}/localconfig/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end