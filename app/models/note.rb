class Note
  attr_accessor :title, :body
  
  def self.all
    []
  end
  
  def initialize(title, body)
    self.title = title
    self.body = body
  end
end
