class YelpTouristTrapper
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
    tourist_traps = results.businesses
    trap_count = results.total
    trap_names = results.businesses.collect{|r| r.name}.join(", ")

    puts "You are near #{trap_count} tourist traps: #{trap_names}."
    build_data(tourist_traps)
  end

  def search_by_neighborhood(neighborhood)
    params = {category_filter: CATEGORIES, radius_filter: RADIUS}
    results = Yelp.client.search(neighborhood, params, LOCALE)
    tourist_traps = results.businesses
    trap_count = results.total
    trap_names = results.businesses.collect{|r| r.name}.join(", ")
    
    puts "#{neighborhood} has #{trap_count} Tourist Traps, including #{trap_names}."
    build_data(tourist_traps)
  end

  def build_data(tourist_traps)
    tourist_traps.each.with
    data[:neighborhoods] = get_neighborhoods(tourist_traps)
    data[:landmarks] = get_landmarks(tourist_traps)
    data
  end

  def get_neighborhoods(tourist_traps)
    tourist_traps.collect { |trap| trap.location.neighborhoods }.flatten.uniq
  end  

  def get_landmarks(tourist_traps)
    tourist_traps.select{|trap| trap.categories.flatten.include?("landmarks")}.collect{|trap| trap.name}
  end

end