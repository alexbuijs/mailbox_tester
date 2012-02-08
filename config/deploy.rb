require 'bundler/capistrano'
load 'deploy/assets'

set :application, "mailbox_tester"
set :repository,  "https://github.com/alexbuijs/mailbox_tester.git"
set :normalize_asset_timestamps, false

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/home/cvzprj/#{application}"
set :user, "cvzprj"
set :password, "prjcvz99"
set :use_sudo, false

default_environment['LD_LIBRARY_PATH'] = "/usr/local/lib"

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_type, :user

server "CVZLACT001", :app, :web, :db, :primary => true

set :rails_env,      "production"
set :passenger_port, 9000
set :passenger_cmd,  "bundle exec passenger"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{passenger_cmd} start -e #{rails_env} -p #{passenger_port} -d"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{passenger_cmd} stop -p #{passenger_port}"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      if [[ -f #{current_path}/tmp/pids/passenger.#{passenger_port}.pid ]];
      then
        cd #{current_path} && #{passenger_cmd} stop -p #{passenger_port};
      fi
    CMD

    run "cd #{current_path} && #{passenger_cmd} start -e #{rails_env} -p #{passenger_port} -d"
  end
end