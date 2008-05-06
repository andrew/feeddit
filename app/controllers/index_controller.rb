class IndexController < ApplicationController
  
  caches_page :index, :format => :html
  
  def index
    respond_to do |format|
      format.html {
      }
      format.atom {
        find_diggs
        feed_options
        render_atom_feed_for @diggs, @options_for_feed
      }
      format.rss {
        find_diggs
        feed_options
        render_rss_feed_for @diggs, @options_for_feed
      }
    end
  end

  protected
  def find_diggs
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
  
  def feed_options # TODO remove this infavour of index.atom.builder
    @options_for_feed = {
        :feed => { :title => "Feeddit", :link => "http://Feeddit.com" }, 
        :item => { :title => :title, :description => :feed_description, :pub_date => :promote_date, :link => :link }
      }
  end
  
end
