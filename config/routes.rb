ActionController::Routing::Routes.draw do |map|

  # TODO legacy routes, should be index.atom and index.rss
  map.rss '/feed.rss', :controller => 'index', :action => 'index', :format => 'rss'
  map.atom '/feed.atom', :controller => 'index', :action => 'index', :format => 'atom'

  map.root :controller => 'index'

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
