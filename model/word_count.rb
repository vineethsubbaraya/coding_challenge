class WordCount

  ## Model for saving Wordcount
  include DataMapper::Resource
  
  property :id, Serial
  property :text, Text
  property :exclude, Text
  property :client_id, Integer

  before :save, :generate_id


  def generate_id
    self.client_id = generate_token
  end

  def generate_token
    loop do
      token = rand(1..100000)
      break token unless !WordCount.all(client_id: token).empty?
    end
  end
  
end
