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
  CHAINS = [
    "TGI Friday's","t.g.i. friday's","Olive Garden Italian Restaurant",
    "Sbarro","Subway","Hooter's","Auntie Anne's","Europa Cafe","Pret A Manger",
    "Chili's","Red Lobster","Applebee's","Haagen-Dazs","Apple Store"]
   
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
      params = {category_filter: category, radius_filter: RADIUS, sort: 1}
      results = Yelp.client.search(neighborhood, params, LOCALE)

      if !results.businesses.empty?
        names = results.businesses.collect{|b| b.name}
        results.businesses.each do |b|
          if b.location.respond_to?(:coordinate)
            rating = get_rating(category)
            self.locations << Location.new(b.name, b.location.coordinate.latitude, b.location.coordinate.longitude, rating)
          end
        end
        self.coords = get_coords(results)
        self.send(category+"=", names)
      else
        self.send(category+"=", [])      
      end   

    end

    self.neighborhood = neighborhood
    build_famous_locations_data
    build_chains_data
    self
  end

  def score
    self.locations.inject(0) { |sum, location| sum + location.rating}
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
    CHAINS.each do |chain|
      params = {term: chain, limit: 5, radius_filter: RADIUS}
      results = Yelp.client.search(self.neighborhood, params, LOCALE)
      business_names = results.businesses.collect{|b| b.name}
      results.businesses.each do |b|
        if b.location.respond_to?(:coordinate)
          self.locations << Location.new(b.name, b.location.coordinate.latitude, b.location.coordinate.longitude, 3)
        end
      end
      matches = business_names.select{|bn| bn == chain}.size
      self.chains << {name: chain, count: matches}
    end      
  end

  def get_coords(results)
    {latitude: results.region.center.latitude, longitude: results.region.center.longitude}
  end    

  def get_rating(category)  
    case category
    when "ticketsales"
    when "magicians"
      5
    when "tours"
      5
    when "landmarks"
      5
    when "giftshops"
      5
    when "souvenirs"
      5
    when "amusementparks"
      5
    when "bikerentals"
      5
    when "zoos"
      5
    when "aquariums"
      5
    when "boatcharters"
      5
    when "hotels"
      4
    when "trainstations"
      4
    when "pedicabs"
      5
    when "travelservices"
      4
    when "localflavor"
      3
    end
  end

  # class methods
  def self.famous_locations    
    fl_path = File.join(Rails.root, 'lib/assets/famous_locations.csv')
    famous_locations = []
    begin
      open(fl_path) do |f|
        famous_locations = CSV.parse f
      end
    rescue IOError => e
    end      

    famous_locations.collect do |row| 
      {name: row[0], latitude: row[1].to_f, longitude: row[2].to_f}
    end
  end  


end