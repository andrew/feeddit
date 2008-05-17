class Topic

  attr :name, true
  attr :short_name, true

  def initialize (name = nil,short_name = nil)
    @name = name
    @short_name = short_name
  end
  
end