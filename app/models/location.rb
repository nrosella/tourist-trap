class Location
  attr_accessor :name, :latitude, :longitude, :rating

  def initialize(name, latitude, longitude, rating)
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
    self.rating = rating
  end
  
end