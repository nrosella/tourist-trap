class Tag
  attr_reader :client

  def initialize
    @client = Instagram.client(:client_id => ENV["instagram_client_id"])
  end

  def get_count_for_tag(tag)
    results = @client.tag_search(tag)
    results.collect {|result| result["media_count"]}.first
  end

end