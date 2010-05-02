# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.gem 'rack-rewrite', '~> 0.2.0'
require 'rack-rewrite'
config.middleware.insert_before(::Rack::Lock, ::Rack::Rewrite) do
  r301 %r{.*}, 'http://feeddit.com$&', :if => Proc.new {|rack_env|
    rack_env['SERVER_NAME'] != 'feeddit.com'
  }
  r301 '/digg/popular.atom', 'http://feeds.feedburner.com/Diggfeedr', :if => Proc.new {|rack_env|
    rack_env['HTTP_USER_AGENT'] !~ /FeedBurner|FeedValidator/
  }
  r301 '/index.html', '/'
  r301 %r{^/feed(.*)}, '/digg/popular.atom'
  r301 '/topics', '/digg'
  r301 %r{^/topics/(.*).atom}, '/digg/topics/$1.atom'
end