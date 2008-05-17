atom_feed(:schema_date => 2008, :root_url => root_path, :url => atom_path) do |feed|
  feed.title 'Feeddit'
  feed.updated Time.now

  for story in @stories
    feed.entry(story, :url => story.link) do |entry|
      entry.title story.title
      entry.author do |author|
        author.name story.user.name
        author.uri "http://digg.com/users/#{story.user.name}"
      end
      entry.content story.description, :type => 'html'
    end
  end
end