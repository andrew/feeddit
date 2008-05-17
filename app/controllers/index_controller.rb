class IndexController < ApplicationController
  
  caches_page :index, :format => :html
  caches_action :index, :format => :atom, :cache_path => {:day => Date.today.to_s, :hour => Time.now.hour}
  
  def index
    respond_to do |format|
      format.html 
      format.atom { find_diggs }
    end
  end

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

  def find_diggs(topic)
    # TODO move this into digg library file
    response = open("http://services.digg.com/stories/#{ params[:topic].blank? ? 'popular' : 'topic/' + params[:topic] }?count=100&appkey=http%3A%2F%2Ffeeddit.com", 
                    "User-Agent" => "Diggfeedr/1").read 
    
    
    @diggs = []
    REXML::Document.new(response).elements.each("stories/story") do |story| 
      @diggs << Digg.new( story.elements[1].text,
                          story.elements[2].text,
                          story.elements[3].attributes["name"],
                          story.elements[3].attributes["icon"],
                          story.elements[4].attributes["name"],
                          story.elements[4].attributes["short_name"],
                          story.elements[5].attributes["name"],
                          story.elements[5].attributes["short_name"],
                          story.attributes["status"], 
                          story.attributes["href"], 
                          story.attributes["comments"], 
                          story.attributes["submit_date"], 
                          story.attributes["promote_date"], 
                          story.attributes["id"], 
                          story.attributes["diggs"],
                          story.attributes["link"])           
    end
  end

  

end
