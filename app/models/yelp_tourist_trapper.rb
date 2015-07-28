class YelpTouristTrapper
  require 'csv'
  attr_accessor :coords, :neighborhoods, :tourist_traps, :chains, :famous_locations
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

  def attributes
    self.methods.select do |method|
      /\w+={1}/.match(method)
    end
  end

  def category_attributes
    self.attributes.reject{|a| /coords=|neighborhoods=|tourist_traps=|chains=|famous_locations=/.match(a.to_s)}
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
    self.coords = get_coords(results)
    build_data(neighborhood)
  end

  def build_data(location)
    build_famous_locations_data(location)
    build_chains_data(location)
    build_category_data  
    self  
  end

  def build_famous_locations_data(location)
    self.famous_locations = []
    self.class.famous_locations.each do |fl|
      if location.class == Hash
        params = {term: fl, limit: 5, radius_filter: RADIUS}
        businesses = Yelp.client.search_by_coordinates(location, params, LOCALE).businesses
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
    self.category_attributes.each do |ca|
      category = ca.to_s.gsub("_","").delete("=")
      self.send(ca, get_category(category))
    end
  end

  def get_category(category)
    self.tourist_traps.select{|trap| trap.categories.flatten.include?(category)}.collect{|trap| trap.name}
  end

  def get_neighborhoods
    self.tourist_traps.collect { |trap| trap.location.neighborhoods }.flatten.uniq
  end  

  def get_coords(results)
    {latitude: results.region.center.latitude, longitude: results.region.center.latitude}
  end

end