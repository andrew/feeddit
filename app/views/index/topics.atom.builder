atom_feed(:schema_date => 2008, :root_url => root_path, :url => atom_path) do |feed|
  feed.title "Feeddit Topic #{params[:topic]}"
  feed.updated Time.now

  for digg in @diggs
    feed.entry(digg, :url => digg.link) do |entry|
      entry.title digg.title
      entry.author do |author|
        author.name digg.user_name
        author.uri "http://digg.com/users/#{digg.user_name}"
      end
      entry.content digg.feed_description, :type => 'html'
    end
  end
end