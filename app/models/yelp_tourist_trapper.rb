class YelpTouristTrapper
  require 'csv'
  require 'geo-distance'
  
  attr_accessor :coords, :neighborhoods, :tourist_traps, :chains, :famous_locations
  attr_accessor :ticketsales, :magicians, :tours, :landmarks, :giftshops, :souvenirs,
  :amusementparks, :bikerentals, :zoos, :aquariums, :boatcharters, :hotels, :trainstations, :pedicabs, :travelservices, :localflavor

  include NeighborhoodParser::InstanceMethods
  include YelpTouristTrapperHelper::InstanceMethods
  extend YelpTouristTrapperHelper::ClassMethods

  LOCALE = {lang: "en", cc: "US"}
  RADIUS = 200
  LOCATION = "New York"  
  CATEGORIES = [
    "ticketsales","magicians","tours","landmarks","giftshops","souvenirs",
    "amusementparks","bikerentals","zoos","aquariums","boatcharters","hotels",
    "trainstations","pedicabs","travelservices","localflavor"]
   
  def initialize   
    @coords = {}   
    @neighborhoods = []
    @chains = []
    @famous_locations = []
  end 

  # instance methods
  def search_by_neighborhood(neighborhood)
    neighborhood = parse_neighborhood(neighborhood)

    CATEGORIES.each do |category|
      params = {category_filter: category, radius_filter: 300}
      results = Yelp.client.search(neighborhood, params, LOCALE)
      self.send(category+"=", results.total)
      self.coords = get_coords(results)
    end

    self.neighborhoods << neighborhood
    binding.pry
    build_famous_locations_data
    build_chains_data(neighborhood)
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