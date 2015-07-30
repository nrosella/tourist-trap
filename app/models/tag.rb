class Tag
  attr_reader :client

  def initialize
    @client = Instagram.client(:client_id => ENV["instagram_client_id"])
  end

  def get_count_for_tag(tag)
    results = client.tag_search(tag)
    results.collect {|result| result["media_count"]}.first
  end

  def get_tourist_instagrams(tag)
    pics = client.tag_recent_media(tag)
    if pics.collect{|pic| pic["tags"].include?("selfie")}
      selfie_array =[]
      pics.each do |pic|
        pic["tags"].include?("selfie")
        selfie_array << pic
      end
      instagrams = selfie_array.collect {|pic| pic["images"]["standard_resolution"]["url"]}
      ten_instagrams = instagrams[0..9]
    elsif pics.collect {|pic| pic["tags"].include?(tag)}
      tourist_array = []
      pics.each do |pic| 
        pic["tags"].include?(tag)
        tourist_array << pic
      end
      instagrams = tourist_array.collect {|pic| pic["images"]["standard_resolution"]["url"]}
      ten_instagrams = instagrams[0..9]
    else
      instagrams = pics.collect {|pic| pic["images"]["standard_resolution"]["url"]}
      ten_instagrams = instagrams[0..9]
    end
  end
    #else return first three items

end