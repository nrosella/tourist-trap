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
<<<<<<< HEAD

    if pics.find {|pic| pic["tags"].include?("selfie")}
      instagrams = pics.collect {|pic| pic["tags"].include?("selfie")}
    elsif pics.find {|pic| pic["tags"].include?("selfie")}
      instagrams = pics.collect {|pic| pic["tags"].include?("selfie")}
    elsif pics.find {|pic| pic["tags"].include?(tag)}
=======
    if pics.collect{|pic| pic["tags"].include?("selfie")}
      instagrams = selfie_array.collect {|pic| pic["images"]["standard_resolution"]["url"]}
    elsif pics.collect {|pic| pic["tags"].include?(tag)}
>>>>>>> master
      instagrams = pics.collect{|pic| pic["tags"].include?(tag)}
    else
      instagrams = pics
    end
    instagrams = pics.collect {|pic| pic["images"]["standard_resolution"]["url"]}
    ten_instagrams = instagrams[0..9]
    binding.pry
  end
end