ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'index' do |index|
    index.rss '/feed.rss', :action => 'index', :format => 'atom' # legacy routes
    index.atom '/feed.atom', :action => 'index', :format => 'atom' # legacy routes
    index.topic '/topics/:topic.atom', :action => 'topics', :format => 'atom'
    index.root 
    index.connect ':action'
  end
end
