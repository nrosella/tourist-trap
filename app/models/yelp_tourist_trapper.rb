class YelpTouristTrapper
  attr_accessor :tourist_traps

  CATEGORIES = [
    "ticketsales", "magicians", "tours", "landmarks", "giftshops", "souvenirs", "amusementparks",
    "bikerentals", "zoos", "aquariums", "boatcharters", "hotelstravel", "trainstations", "pedicabs",
     "travelservices", "localflavor"
  ].join(",")
  LOCALE = {lang: "en"}
  RADIUS = 200
  LOCATION = "New York"

  def search_by_coords(lat, lng)
    params = {category_filter: CATEGORIES, radius_filter: RADIUS }
    coords = {latitude: lat, longitude: lng}
    results = Yelp.client.search_by_coordinates(coords, LOCALE, params)
    self.tourist_traps = results.businesses
    build_data
  end

  def search_by_neighborhood(neighborhood)
    params = {category_filter: CATEGORIES, radius_filter: RADIUS}
    results = Yelp.client.search(neighborhood, params, LOCALE)
    self.tourist_traps = results.businesses
    build_data
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