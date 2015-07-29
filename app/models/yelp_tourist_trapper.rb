class YelpTouristTrapper
  require 'csv'
  require 'geo-distance'
  
  attr_accessor :coords, :neighborhoods, :tourist_traps, :chains, :famous_locations
  attr_accessor :ticket_sales, :magicians, :tours, :landmarks, :gift_shops, :souvenirs,
  :amusement_parks, :bike_rentals, :zoos, :aquariums, :boat_charters, :hotels_travel, :train_stations, :pedicabs, :travel_services, :local_flavor

  include NeighborhoodParser::InstanceMethods
  include YelpTouristTrapperHelper::InstanceMethods
  extend YelpTouristTrapperHelper::ClassMethods

  LOCALE = {lang: "en", cc: "US"}
  RADIUS = 200
  LOCATION = "New York"  
   
  def initialize   
    @coords = {}   
    @neighborhoods = []    
  end 

  def search_by_coords(lat, lng)
    params = {category_filter: self.class.categories, radius_filter: RADIUS }
    coords = {latitude: lat, longitude: lng}
    results = Yelp.client.search_by_coordinates(coords, LOCALE, params)
    self.tourist_traps = results.businesses
    self.coords = {latitude: lat, longitude: lng}
    self.neighborhoods = get_neighborhoods
    build_data(self.coords)
  end

  def search_by_neighborhood(neighborhood)
    neighborhood = parse_neighborhood(neighborhood)
    params = {category_filter: self.class.categories, radius_filter: RADIUS}
    results = Yelp.client.search(neighborhood, params, LOCALE)
    self.tourist_traps = results.businesses
    self.neighborhoods << neighborhood
    self.coords = get_coords(results)
    build_data(neighborhood)
  end  

end