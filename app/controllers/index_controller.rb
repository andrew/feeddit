class IndexController < ApplicationController
  
  caches_action :index, :format => :atom, :cache_path => {:time => Time.now.hour / 15}
  caches_action :topics, :format => :atom, :cache_path => {:time => Time.now.hour / 15}
  caches_page :index, :format => :html
  caches_page :topics, :format => :html
  after_filter :clear_cache, :only => :index
  after_filter :clear_cache, :only => :topics
  
  def index
    respond_to do |format|
      format.html 
      format.atom { @stories = Digg.new.stories('stories/popular', :count => 100) }
    end
  end

  def topics 
    respond_to do |format|
      format.html { @topics = Digg.new.topics }
      format.atom { @stories = Digg.new.stories("stories/topic/#{params[:topic]}/popular", :count => 100) } # TODO cache this
    end
  end

  protected
  
  def clear_cache
    for hour in 0..3 do
      next if hour == Time.now.hour / 15
      expire_action(:hour => hour)
    end
  end
end
