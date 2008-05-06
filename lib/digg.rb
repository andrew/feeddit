class Digg
  
  attr :title, true
  attr :description, true
  attr :user_name, true
  attr :user_icon, true
  attr :topic_name, true
  attr :topic_short_name, true
  attr :container_name, true
  attr :container_short_name, true
  attr :status, true
  attr :href, true
  attr :comments, true
  attr :submit_date, true
  attr :diggs, true
  attr :link, true
  attr :id, true
  attr :promote_date, true
  attr :feed_description
  
  def initialize (title = nil, 
                  description = nil, 
                  user_name = nil, 
                  user_icon = nil, 
                  topic_name = nil,
                  topic_short_name = nil,
                  container_name = nil,
                  container_short_name = nil,
                  status = nil, 
                  href = nil, 
                  comments = nil, 
                  submit_date = nil, 
                  promote_date = nil,
                  id = nil, 
                  diggs = nil, 
                  link = nil)
    @title = title
    @description = description
    @user_name = user_name
    @user_icon = user_icon
    @topic_name = topic_name
    @topic_short_name = topic_short_name
    @container_name = container_name
    @container_short_name = container_short_name
    @status = status
    @href = href
    @comments = comments
    @submit_date = Time.at(submit_date.to_i)
    @promote_date = Time.at(promote_date.to_i)
    @id = id
    @diggs = diggs
    @link = link
    @feed_description = "#{@description}<br /><br /><a href='#{@href}'>#{@diggs} Diggs</a> and <a href='#{@href}'>#{@comments} Comments</a> in <a href='http://digg.com/#{topic_short_name}'>#{@topic_name}</a> - Submitted by <a href='http://digg.com/users/#{@user_name}'>#{@user_name}</a> - <a href='http://duggmirror.com#{@href.to_s[15..@href.to_s.size]}'>Mirror</a>" 
    
  end   
end