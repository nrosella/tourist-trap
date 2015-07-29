namespace :tourist_traps do
  desc "Creates a csv of famous NYC locations"
  task famous_locations: :environment do
    businesses = [
      "Katz's Delicatessen","Coyote Ugly Saloon","The Rainbow Room",
      "Joe's Pizza","Buddakan","Smith & Wollenksy","The Central Park Boathouse",
      "SoHo House","Café Grumpy","Tom's Restaurant","21 Club","Lenny's Pizza",
      "Café Lalo","New York Public Library","McGee's Pub","Russ & Daughters"
    ]
    locale =  {cc: "US", lang: "en"}

    ids = businesses.collect do |b|
      search = Yelp.client.search("New York", {term: b, limit: 3})
      search.businesses.first.id.gsub(/é/, "e")
    end

    coords = ids.collect do |id|
      search = Yelp.client.business(id)
      [search.location.coordinate.latitude, search.location.coordinate.longitude]
    end

    rows = businesses.zip(coords).collect do |arr|
      arr.flatten
    end

    CSV.open("lib/assets/famous_locations.csv", 'w') do |writer|
      rows.each do |row|
        writer << row
      end
    end
    
  end

end
