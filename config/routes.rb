ActionController::Routing::Routes.draw do |map|
  
  map.with_options :controller => 'digg' do |route|
    route.digg                '/digg/', :action => 'index'
    route.digg_popular        '/digg/popular.atom', :action => 'popular', :format => 'atom'
    route.digg_topic          '/digg/topics/:topic.atom', :action => 'topic', :format => 'atom'
    route.digg_topics         '/digg/topics', :action => 'topics'
    route.digg_upcoming       '/digg/upcoming', :action => 'popular', :format => 'atom'
    route.digg_upcoming_topic '/digg/upcoming/topics/:topic.atom', :action => 'topic', :format => 'atom'
  end
  
  # legacy routes
  map.rss '/feed.rss', :controller => 'digg', :action => 'popular', :format => 'atom' 
  map.atom '/feed.atom', :controller => 'digg', :action => 'popular', :format => 'atom' 
  map.topic '/topics/:topic.atom', :controller => 'digg', :action => 'topic', :format => 'atom'

  map.with_options :controller => 'index' do |index|
    index.root 
    index.connect ':action'
  end
    
end
