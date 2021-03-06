# set :domain, "208.75.86.40"
# role :web, domain
# role :app, domain
# role :db,  domain, :primary => true
# role :scm, domain
# 
# set :application, "diggfeedr"
# set :deploy_to, "/var/www/apps/#{application}"
# 
# set :user, "andrew"
# set :repository, "git://github.com/andrew/feeddit.git"
# set :rails_env, "production"
# 
# set :apache_server_name, domain
# set :apache_proxy_port, 6000
# set :apache_proxy_servers, 4
# 
# set :mongrel_address, apache_proxy_address


default_run_options[:pty] = true
ssh_options[:forward_agent] = true
 
set :scm_verbose, true
 
set :branch, "master"
set :deploy_via, :remote_cache

set :application, "feeddit"
set :repository,  "git@github.com:andrew/feeddit.git"
 
set :deploy_to, "/home/andrew/apps/#{application}"
set :user, "andrew"
 
set :scm, :git

set :domain, "67.207.146.229"
 
role :app, domain
role :web, domain
role :db,  domain, :primary => true
 
set :use_sudo, false
 
namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
 
namespace :deploy do
  %w(start restart stop).each { |name| task name, :roles => :app do passenger.restart end }
end

on :start do
    `ssh-add`
end

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
