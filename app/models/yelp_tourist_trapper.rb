class YelpTouristTrapper
  require 'csv'
  attr_accessor :coords, :neighborhoods, :tourist_traps, :data, :chains, :famous_locations
  attr_accessor :ticket_sales, :magicians, :tours, :landmarks, :gift_shops, :souvenirs,
  :amusement_parks, :bike_rentals, :zoos, :aquariums, :boat_charters, :hotels_travel, :train_stations, :pedicabs, :travel_services, :local_flavor
  include NeighborhoodParser::InstanceMethods

  LOCALE = {lang: "en", cc: "US"}
  RADIUS = 200
  LOCATION = "New York"
   
  def initialize   
    @coords = {}   
    @neighborhoods = []    
  end      
   
  def self.categories    
    CSV.foreach("app/models/tourist_traps/categories.csv").first.join(",")
  end    
   
  def self.chains    
    CSV.foreach("app/models/tourist_traps/chains.csv").first   
  end    
   
  def self.famous_locations    
    CSV.foreach("app/models/tourist_traps/famous_locations.csv").first   
  end  

  def search_by_coords(lat, lng)
    params = {category_filter: self.class.categories, radius_filter: RADIUS }
    coords = {latitude: lat, longitude: lng}
    results = Yelp.client.search_by_coordinates(coords, LOCALE, params)
    self.tourist_traps = results.businesses
    self.coords = {latitude: lat, longitude: lng}
    self.neighborhoods = get_neighborhoods
    build_famous_locations_data(self.coords)
    build_chains_data(self.coords)
    build_category_data
  end

  def search_by_neighborhood(neighborhood)
    neighborhood = parse_neighborhood(neighborhood)
    params = {category_filter: self.class.categories, radius_filter: RADIUS}
    results = Yelp.client.search(neighborhood, params, LOCALE)
    self.tourist_traps = results.businesses
    self.neighborhoods << neighborhood
    self.coords = get_coords
    build_famous_locations_data(neighborhood)
    build_chains_data(neighborhood)
    build_category_data
  end

  def build_famous_locations_data(location)
    self.famous_locations = []
    self.class.famous_locations.each do |fl|
      if location.class == Hash
        params = {term: fl, limit: 5, radius_filter: RADIUS}
        results = Yelp.client.search_by_coordinates(location, params, LOCALE)
      else
        neighborhood = /(.+), Manhattan|, Brooklyn/.match(location)[1]
        params = {term: fl, limit: 5, cll: self.coords}
        businesses = Yelp.client.search(location, params, LOCALE).businesses
        businesses = businesses.select{|b| b.location.respond_to?("neighborhoods") && b.location.neighborhoods.include?(neighborhood)}
      end
      business_names = businesses.collect{|b| b.name}
      self.famous_locations << fl if business_names.include?(fl)
    end    
  end

  def build_chains_data(location)
    self.chains = {}
    self.class.chains.each do |chain|
      params = {term: chain, limit: 10, radius_filter: RADIUS}
      if location.class == Hash
        results = Yelp.client.search_by_coordinates(location, params, LOCALE)
      else
        results = Yelp.client.search(location, params, LOCALE)
      end
      business_names = results.businesses.collect{|b| b.name}
      matches = business_names.select{|bn| bn == chain}.size
      self.chains[chain.to_sym] = matches
    end      
  end

  def build_category_data
    self.landmarks = get_category("landmarks")
    self.tours = get_category("tours")
    self.magicians = get_category("magicians")
    self.gift_shops = get_category("giftshops")
    self.souvenirs = get_category("souvenirs")
    self.ticket_sales = get_category("ticketsales")
    self.amusement_parks = get_category("amusementparks")
    self.bike_rentals = get_category("bikerentals")
    self.zoos = get_category("zoos")
    self.aquariums = get_category("aquariums")
    self.boat_charters = get_category("boatcharters")
    self.hotels_travel = get_category("hotelstravel")
    self.train_stations = get_category("trainstations")
    self.pedicabs = get_category("pedicabs")
    self.travel_services = get_category("travelservices")
    self.local_flavor = get_category("localflavor")
  end

  def get_category(category)
    self.tourist_traps.select{|trap| trap.categories.flatten.include?(category)}.collect{|trap| trap.name}
  end

  def get_neighborhoods
    self.tourist_traps.collect { |trap| trap.location.neighborhoods }.flatten.uniq
  end  

  def get_coords
    coords = {}
    coords[:latitude] = self.tourist_traps.first.location.coordinate.latitude
    coords[:longitude] = self.tourist_traps.first.location.coordinate.longitude
    coords
  end

end