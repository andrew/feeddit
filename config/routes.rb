ActionController::Routing::Routes.draw do |map|
  
  map.with_options :controller => 'digg' do |route|
    route.digg                '/digg',                             :action => 'index'
    route.digg_upcoming       '/digg/upcoming',                    :action => 'index',                    :upcoming => true
    route.digg_popular        '/digg/popular.atom',                :action => 'index', :format => 'atom'
    route.digg_upcoming_feed  '/digg/upcoming.atom',               :action => 'index', :format => 'atom', :upcoming => true
    route.digg_topic          '/digg/topics/:topic.atom',          :action => 'topic', :format => 'atom'
    route.digg_upcoming_topic '/digg/topics/upcoming/:topic.atom', :action => 'topic', :format => 'atom', :upcoming => true
  end
  
  # legacy routes
  map.rss     '/feed.rss',           :controller => 'digg', :action => 'index', :format => 'atom' 
  map.atom    '/feed.atom',          :controller => 'digg', :action => 'index', :format => 'atom'
  map.topics  '/topics',             :controller => 'digg', :action => 'index'
  map.topic   '/topics/:topic.atom', :controller => 'digg', :action => 'topic', :format => 'atom'

  map.with_options :controller => 'index' do |index|
    index.root 
    index.connect ':action'
  end
    
end
