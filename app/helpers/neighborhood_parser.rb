module NeighborhoodParser
  require 'csv'
  
  module InstanceMethods
    def parse_neighborhood(neighborhood)
      manhattan_neighborhoods = CSV.foreach("lib/neighborhoods/manhattan.csv").first
    end
    
  end
  
end