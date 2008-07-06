# TODO Get off deprec upgrade to work with capistrano 2.3.0 and github
require 'deprec/recipes' 

set :domain, "feeddit.com"
role :web, domain
role :app, domain
role :db,  domain, :primary => true
role :scm, domain

set :application, "diggfeedr"
set :deploy_to, "/var/www/apps/#{application}"

set :user, "andrew"
set :repository, "git://github.com/andrew/feeddit.git"
set :rails_env, "production"

set :apache_server_name, domain
set :apache_proxy_port, 6000
set :apache_proxy_servers, 4

set :mongrel_address, apache_proxy_address
