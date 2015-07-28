class YelpTouristTrapper
  attr_accessor :tourist_traps, :data
  include NeighborhoodParser::InstanceMethods

  CATEGORIES = [
    "ticketsales", "magicians", "tours", "landmarks", "giftshops", "souvenirs", "amusementparks",
    "bikerentals", "zoos", "aquariums", "boatcharters", "hotelstravel", "trainstations", "pedicabs",
     "travelservices", "localflavor"
  ].join(",")
  LOCALE = {lang: "en"}
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

  def search_by_coords(lat, lng)
    params = {category_filter: CATEGORIES, radius_filter: RADIUS }
    coords = {latitude: lat, longitude: lng}
    results = Yelp.client.search_by_coordinates(coords, LOCALE, params)
    self.tourist_traps = results.businesses
    self.data = build_data
  end

  def search_by_neighborhood(neighborhood)
    neighborhood = parse_neighborhood(neighborhood)
    params = {category_filter: CATEGORIES, radius_filter: RADIUS}
    results = Yelp.client.search(neighborhood, params, LOCALE)
    self.tourist_traps = results.businesses
    self.data = build_data
  end

  def build_data
    data = {}
    data[:neighborhoods] = get_neighborhoods
    data[:landmarks] = get_category("landmarks")
    data[:tours] = get_category("tours")
    data[:magicians] = get_category("magicians")
    data[:giftshops] = get_category("giftshops")
    data[:souvenirs] = get_category("souvenirs")
    data[:ticketsales] = get_category("ticketsales")
    data[:amusementparks] = get_category("amusementparks")
    data[:bikerentals] = get_category("bikerentals")
    data[:zoos] = get_category("zoos")
    data[:aquariums] = get_category("aquariums")
    data[:boatcharters] = get_category("boatcharters")
    data[:hotels] = get_category("hotelstravel")
    data[:trainstations] = get_category("trainstations")
    data[:pedicabs] = get_category("pedicabs")
    data[:travelservices] = get_category("travelservices")
    data[:localflavor] = get_category("localflavor")
    data[:coords] = get_coords
    data
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