namespace :tourist_traps do
  desc "Creates a csv of famous NYC locations"
  task famous_locations: :environment do
    businesses = [
      "Katz's Delicatessen","Coyote Ugly Saloon","The Rainbow Room",
      "Joe's Pizza","Buddakan","Smith & Wollenksy","The Central Park Boathouse",
      "SoHo House","Café Grumpy","Tom's Restaurant","21 Club","Lenny's Pizza",
      "Café Lalo","New York Public Library","McGee's Pub","Russ & Daughters"
    ]
    ids = businesses.collect do |b|
      search = Yelp.client.search("New York", {term: b, limit: 3}, {cc: "US", lang: "en"})
      ids << search.businesses.first.id
    end
  end

end
