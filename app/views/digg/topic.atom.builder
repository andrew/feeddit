atom_feed(:schema_date => 2008, :root_url => root_url, :url => (upcoming? ? digg_upcoming_topic_url(:topic => params[:topic]) : digg_topic_url(:topic => params[:topic]))) do |feed|
  feed.title "#{'Upcoming in ' if upcoming?}Feeddit Topic: '#{params[:topic].titleize}'"
  feed.updated Time.at(@stories.timestamp.to_s.to_i)

  for story in @stories
    feed.entry(story, :url => story.link) do |entry|
      entry.title story.title
      entry.updated Time.at(story.submit_date.to_i).xmlschema
      entry.author do |author|
        author.name story.user.name
        author.uri "http://digg.com/users/#{story.user.name}"
      end
      entry.content "#{story.description}<br /><br /><a href='#{story.href}'>#{story.diggs} Diggs</a> and <a href='#{story.href}'>#{story.comments} Comments</a> - Submitted by <a href='http://digg.com/users/#{story.user.name}'>#{story.user.name}</a> - <a href='http://www.duggback.com#{story.href.to_s[15..story.href.to_s.size]}'>Mirror</a>", :type => 'html'
    end
  end 
end