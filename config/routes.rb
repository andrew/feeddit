ActionController::Routing::Routes.draw do |map|
  map.rss '/feed.rss', :controller => 'index', :action => 'index', :format => 'atom' # legacy routes
  map.atom '/feed.atom', :controller => 'index', :action => 'index', :format => 'atom' # legacy routes
  
  map.index '/index.:format', :controller => 'index', :action => 'index'

  map.topics '/topics/:topic.:format', :controller => 'index', :action => 'topics'

  map.root :controller => 'index'

  map.connect ':action', :controller => 'index'
end
