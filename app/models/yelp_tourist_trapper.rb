class YelpTouristTrapper
  CATEGORIES = [
    "ticketsales", "magicians", "tours", "landmarks", "giftshops", "souvenirs", "amusementparks",
    "bikerentals", "zoos", "aquariums", "boatcharters", "hotelstravel", "trainstations", "pedicabs",
     "travelservices", "localflavor"
  ].join(",")
  LOCALE = {lang: "en"}
  RADIUS = 200
  LOCATION = "New York"

  def self.search_by_coords(lat, lng)
    params = {category_filter: CATEGORIES, radius_filter: RADIUS }
    coords = {latitude: lat, longitude: lng}
    results = Yelp.client.search_by_coordinates(coords, LOCALE, params)
    trap_count = results.total
    trap_names = results.businesses.collect{|r| r.name}.join(", ")
    "You are near #{trap_count} tourist traps: #{trap_names}."
  end

  def self.search_by_neighborhood(neighborhood)
    params = {category_filter: CATEGORIES, radius_filter: RADIUS}
    results = Yelp.client.search(neighborhood, params, LOCALE)
    trap_count = results.total
    trap_names = results.businesses.collect{|r| r.name}.join(", ")
    "#{neighborhood} has #{trap_count} Tourist Traps, including #{trap_names}."
  end

end