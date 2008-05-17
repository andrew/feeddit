class Topic
  
  # <topic name="Apple" short_name="apple">
  #  <container name="Technology" short_name="technology" />
  # </topic>
  
  
  attr :name, true
  attr :short_name, true

  def initialize (name = nil, 
                  short_name = nil)
    @name = name
    @short_name = short_name

  end
  
  
end