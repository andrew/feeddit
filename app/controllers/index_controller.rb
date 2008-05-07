class IndexController < ApplicationController
  
  caches_page :index, :format => :html
  
  def index
    respond_to do |format|
      format.html 
      format.atom { find_diggs }
    end
  end

  protected
  def find_diggs
    # TODO move this into digg library file
    response = open("http://services.digg.com/stories/popular?count=100&appkey=http%3A%2F%2Ffeeddit.com", "User-Agent" => "Diggfeedr/1").read 
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
