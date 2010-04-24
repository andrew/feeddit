class DiggController < ApplicationController

  def index
    expires_in 15.minutes, :public => true
    respond_to do |format|
      format.html { @topics = Digg.new.topics }
      format.atom { @stories = Digg.new.stories("stories/#{upcoming_or_popular}", :count => 100) }
    end
  end

  def topic
    expires_in 15.minutes, :public => true
    respond_to do |format|
      format.atom { @stories = Digg.new.stories("stories/topic/#{params[:topic]}/#{upcoming_or_popular}", :count => 100) }
    end
  end

  private

  helper_method :upcoming?
  def upcoming?
    params[:upcoming]
  end

  def upcoming_or_popular
    upcoming? ? 'upcoming' : 'popular'
  end

end