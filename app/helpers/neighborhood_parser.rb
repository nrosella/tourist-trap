module NeighborhoodParser
  require 'csv'
  
  module InstanceMethods
    def parse_neighborhood(neighborhood)
      brooklyn_path = File.join(Rails.root, 'lib/neighborhoods/brooklyn.csv')
      brooklyn_neighborhoods = []
      begin
        open(brooklyn_path) do |f|
          brooklyn_neighborhoods = CSV.parse f
          brooklyn_neighborhoods = brooklyn_neighborhoods.flatten
        end
      rescue IOError => e
      end    

      manhattan_path = File.join(Rails.root, 'lib/neighborhoods/manhattan.csv')
      manhattan_neighborhoods = []
      begin
        open(manhattan_path) do |f|
          manhattan_neighborhoods = CSV.parse f
          manhattan_neighborhoods = manhattan_neighborhoods.flatten
        end
      rescue IOError => e
      end      

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