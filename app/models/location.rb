class Location
  attr_accessor :name, :latitude, :longitude

  def initialize(name, latitude, longitude)
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
  end
  
end