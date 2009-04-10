class DiggController < ApplicationController
  
  def popular
    respond_to do |format|
      format.atom { @stories = Digg.new.stories('stories/popular', :count => 100) }
    end
  end
  
  def topics 
    respond_to do |format|
      format.html { @topics = Digg.new.topics }
    end
  end
  
  def topic
    respond_to do |format|
      format.atom { @stories = Digg.new.stories("stories/topic/#{params[:topic]}/popular", :count => 100) }
    end
  end
  
  def upcoming
    respond_to do |format|
      format.atom { @stories = Digg.new.stories('stories/upcoming', :count => 100) }
    end
  end
  
  def upcoming_topic 
    respond_to do |format|
      format.atom { @stories = Digg.new.stories("stories/topic/#{params[:topic]}/upcoming", :count => 100) }
    end
  end
  
end