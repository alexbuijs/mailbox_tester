require 'bundler/capistrano'
load 'deploy/assets'

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"
set :rvm_type, :user

default_environment['LD_LIBRARY_PATH'] = "/usr/local/lib"

set :application, "mailbox_tester"
set :repository,  "https://github.com/alexbuijs/mailbox_tester.git"
set :normalize_asset_timestamps, false
set :scm, :git
set :deploy_to, "/home/cvzprj/#{application}"
set :user, "cvzprj"
set :password, "prjcvz99"
set :use_sudo, false

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