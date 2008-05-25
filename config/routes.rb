ActionController::Routing::Routes.draw do |map|
  map.rss '/feed.rss', :controller => 'index', :action => 'index', :format => 'atom' # legacy routes
  map.atom '/feed.atom', :controller => 'index', :action => 'index', :format => 'atom' # legacy routes
  map.topic '/topics/:topic.atom', :controller => 'index', :action => 'topics', :format => 'atom'
  map.root :controller => 'index'
  map.connect ':action', :controller => 'index'
end
