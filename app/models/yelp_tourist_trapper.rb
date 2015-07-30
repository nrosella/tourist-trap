class YelpTouristTrapper
  require 'csv'
  require 'geo-distance'
  
  attr_accessor :coords, :neighborhoods, :tourist_traps, :chains, :famous_locations
  attr_accessor :ticket_sales, :magicians, :tours, :landmarks, :gift_shops, :souvenirs,
  :amusement_parks, :bike_rentals, :zoos, :aquariums, :boat_charters, :hotels, :train_stations, :pedicabs, :travel_services, :local_flavor

  include NeighborhoodParser::InstanceMethods
  include YelpTouristTrapperHelper::InstanceMethods
  extend YelpTouristTrapperHelper::ClassMethods

  LOCALE = {lang: "en", cc: "US"}
  RADIUS = 200
  LOCATION = "New York"  
   
  def initialize   
    @coords = {}   
    @neighborhoods = []
    @chains = []
    @famous_locations = []
  end 

  # instance methods
  def search_by_neighborhood(neighborhood)
    neighborhood = parse_neighborhood(neighborhood)
    params = {category_filter: self.class.categories, radius_filter: 500}
    results = Yelp.client.search(neighborhood, params, LOCALE)
    self.tourist_traps = results.businesses
    self.neighborhoods << neighborhood
    self.coords = get_coords(results)
    binding.pry
    build_data(neighborhood)
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


  def attributes
    self.methods.select do |method|
      /\w+={1}/.match(method)
    end
  end    

  def category_attributes
    self.attributes.reject{|a| /coords=|neighborhoods=|tourist_traps=|chains=|famous_locations=/.match(a.to_s)}
  end    

  def build_data(location)
    build_famous_locations_data
    build_chains_data(location)
    build_category_data  
    self  
  end

  def build_famous_locations_data
    latitude = self.coords[:latitude]
    longitude = self.coords[:longitude]
    self.class.famous_locations.each do |fl|
      params = [latitude, longitude, fl[:latitude], fl[:longitude]]
      dist = GeoDistance::Haversine.geo_distance(*params).meters
      if dist < RADIUS
        self.famous_locations << fl[:name]
      end
    end
  end

  def build_chains_data(location)
    self.class.chains.each do |chain|
      params = {term: chain, limit: 5, radius_filter: RADIUS}
      if location.class == Hash
        results = Yelp.client.search_by_coordinates(location, params, LOCALE)
      else
        results = Yelp.client.search(location, params, LOCALE)
      end
      business_names = results.businesses.collect{|b| b.name}
      matches = business_names.select{|bn| bn == chain}.size
      self.chains << {name: chain, count: matches}
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
    {latitude: results.region.center.latitude, longitude: results.region.center.longitude}
  end    


  # class methods
  def self.categories    
    CSV.foreach("app/models/tourist_traps/categories.csv").first.join(",")
  end    
   
  def self.chains    
    CSV.foreach("app/models/tourist_traps/chains.csv").first   
  end    
   
  def self.famous_locations    
    CSV.foreach("lib/assets/famous_locations.csv").with_object([]) do |row, arr|
      arr << {name: row[0], latitude: row[1].to_f, longitude: row[2].to_f}
    end      
  end  


end