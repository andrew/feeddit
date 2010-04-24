class IndexController < ApplicationController

  caches_page :index, :opensource, :topics

  def index
    expires_in 1.day, :public => true
    respond_to do |format|
      format.html
      format.atom { @stories = Digg.new.stories('stories/popular', :count => 100) }
    end
  end

  def topics
    expires_in 3.hours, :public => true
    respond_to do |format|
      format.html { @topics = Digg.new.topics }
      format.atom { @stories = Digg.new.stories("stories/topic/#{params[:topic]}/popular", :count => 100) }
    end
  end

end
