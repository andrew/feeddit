ActionController::Routing::Routes.draw do |map|
  map.rss '/feed.rss', :controller => 'index', :action => 'feed', :format => 'atom' # legacy routes
  map.atom '/feed.atom', :controller => 'index', :action => 'feed', :format => 'atom' # legacy routes

  map.topics '/topics/:topic.:format', :controller => 'index', :action => 'topics'

  map.root :controller => 'index'

  map.connect ':action', :controller => 'index'
end
