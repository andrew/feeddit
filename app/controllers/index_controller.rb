class IndexController < ApplicationController
  
  caches_action :feed, :cache_path => {:time => Time.now.hour / 15}
  caches_page :index
  after_filter :clear_cache, :only => :feed
  
  def index
    respond_to do |format|
      format.html 
    end
  end
  
  def feed
    respond_to do |format|
      format.atom { @stories = Digg.new.stories }
    end
  end

  # random comment

  def topics
    respond_to do |format|
      format.html { find_topics }
      format.atom { find_diggs(params[:topic]) }
    end
  end

  protected
  
  def find_topics
    # TODO also prolly wants to be moved into the library
    
    response = open("http://services.digg.com/topics/?appkey=http%3A%2F%2Ffeeddit.com", # TODO extract the appkey to an initializer
                    "User-Agent" => "Diggfeedr/1").read 
    
    @topics = []
    REXML::Document.new(response).elements.each("topics/topic") do |topic| 
      @topics << Topic.new( topic.attributes["name"],
                          topic.attributes["short_name"])           
    end
  end

  def clear_cache
    for hour in 0..3 do
      next if hour == Time.now.hour / 15
      expire_action(:hour => hour)
    end
  end
end
