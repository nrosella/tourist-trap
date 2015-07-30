class YelpTouristTrapper
  require 'csv'
  require 'geo-distance'
  
  attr_accessor :coords, :neighborhood, :chains, :famous_locations, :locations
  attr_accessor :ticketsales, :magicians, :tours, :landmarks, :giftshops, :souvenirs,
  :amusementparks, :bikerentals, :zoos, :aquariums, :boatcharters, :hotels, :trainstations, :pedicabs, :travelservices, :localflavor

  include NeighborhoodParser::InstanceMethods

  LOCALE = {lang: "en", cc: "US"}
  RADIUS = 800
  LOCATION = "New York"  
  CATEGORIES = [
    "ticketsales","magicians","tours","landmarks","giftshops","souvenirs",
    "amusementparks","bikerentals","zoos","aquariums","boatcharters","hotels",
    "trainstations","pedicabs","travelservices","localflavor"]
   
  def initialize   
    @coords = {}   
    @chains = []
    @famous_locations = []
    @locations = []
  end 

  # instance methods
  def search_by_neighborhood(neighborhood)
    neighborhood = parse_neighborhood(neighborhood)

    CATEGORIES.each do |category|
      params = {category_filter: category, radius_filter: RADIUS}
      results = Yelp.client.search(neighborhood, params, LOCALE)

      if !results.businesses.empty?
        names = results.businesses.collect{|b| b.name}
        locations = results.businesses.collect do |b|
          Location.new(b.name, b.location.coordinate.latitude, b.location.coordinate.longitude)
        end
        self.coords = get_coords(results)
        self.send(category+"=", names)
        self.locations << locations
      else
        self.send(category+"=", [])      
      end   

    end

    self.neighborhood = neighborhood
    build_famous_locations_data
    build_chains_data
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

  def build_chains_data
    self.class.chains.each do |chain|
      params = {term: chain, limit: 5, radius_filter: RADIUS}
      results = Yelp.client.search(self.neighborhood, params, LOCALE)
      business_names = results.businesses.collect{|b| b.name}
      matches = business_names.select{|bn| bn == chain}.size
      self.chains << {name: chain, count: matches}
    end      
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