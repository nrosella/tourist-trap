module NeighborhoodParser
  require 'csv'
  
  module InstanceMethods
    def parse_neighborhood(neighborhood)
      manhattan_neighborhoods = CSV.foreach("lib/neighborhoods/manhattan.csv").first
      brooklyn_neighborhoods = CSV.foreach("lib/neighborhoods/brooklyn.csv").first
      match = manhattan_neighborhoods.find{|m| m.downcase == neighborhood.downcase}
      if (match.nil?)
        match = brooklyn_neighborhoods.find{|b| b.downcase == neighborhood.downcase}
        match = match + ", Brooklyn, NY"
      else
        match = match + ", Manhattan, NY"
      end
      match
    end
    
  end
  
end