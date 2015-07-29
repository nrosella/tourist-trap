class Map
  attr_accessor :address, :lat, :lng
  
  def initialize(address, lat, lng)
    @address = address
    @lat = lat
    @lng = lng
  end

end