class YelpTouristTrapper
  require 'csv'
  attr_accessor :coords, :neighborhoods, :tourist_traps, :data, :ticket_sales, :magicians, :tours, :landmarks, :gift_shops, :souvenirs,
  :amusement_parks, :bike_rentals, :zoos, :aquariums, :boat_charters, :hotels_travel, :train_stations, :pedicabs, :travel_services, :local_flavor
  include NeighborhoodParser::InstanceMethods

  def self.categories 
    CSV.foreach("app/models/tourist_traps/categories.csv").first
  end

  def self.locale
    {lang: "en"}
  end

  RADIUS = 200
  LOCATION = "New York"
  CHAINS = [
    "TGI Friday's", "Olive Garden", "Sbarro", "Subway", "Guy's American Kitchen & Bar",
    "Hooters", "Jimmy Buffett's Margaritaville", "Rainforest Café", "Dinosaur BBQ", "Virgil's"
  ]

  FAMOUS_LOCATIONS = [
    "Katz's Delicatessen", "Coyote Ugly Saloon", "The Rainbow Room", "Joe's Pizza", "Buddakan",
    "Smith & Wollenksy's", "Central Park Boathouse", "SoHo House", "Café Grumpy", "Tom's Restaurant", 
    "21 Club", "Lenny's Pizza", "Café Lalo", "New York Public Library", "McGee's Pub"
  ]

  def initialize
    @coords = {}
    @neighborhoods = []
  end

  def search_by_coords(lat, lng)
    params = {category_filter: self.class.categories.join(","), radius_filter: RADIUS }
    coords = {latitude: lat, longitude: lng}
    results = Yelp.client.search_by_coordinates(coords, self.class.locale, params)
    self.tourist_traps = results.businesses
    self.coords = {latitude: lat, longitude: lng}
    self.neighborhoods = get_neighborhoods
    build_data
  end

  def search_by_neighborhood(neighborhood)
    neighborhood = parse_neighborhood(neighborhood)
    params = {category_filter: self.class.categories.join(","), radius_filter: RADIUS}
    results = Yelp.client.search(neighborhood, params, self.class.locale)
    self.tourist_traps = results.businesses
    self.neighborhoods << neighborhoods
    self.coords = get_coords
    build_data
  end

  def build_data
    self.neighborhoods = get_neighborhoods
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