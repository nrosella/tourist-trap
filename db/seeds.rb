# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

	Borough.create([{:name => "Bronx"}, {:name => "Brooklyn"}, {:name => "Manhattan"}, {:name => "Queens"}, {:name => "Staten Island"}])

	brooklyn_path = File.join(Rails.root, 'lib/neighborhoods/brooklyn.csv')
	brooklyn_neighborhoods = []
	begin
		open(brooklyn_path) do |f|
			brooklyn_neighborhoods = CSV.parse f
			brooklyn_neighborhoods.flatten.each do |n|
				# binding.pry
				Neighborhood.create(:name => n, :borough_id => 2)
			end
		end
	rescue IOError => e
	end

	# manhattan_path = File.join(Rails.root, 'lib/neighborhoods/manhattan.csv')
	# manhattan_neighborhoods = CSV.foreach(manhattan_path).first

	# brooklyn =  brooklyn_neighborhoods.each do |n|
	#               Neighborhood.create(:name => n, :borough_id => 2)
	            # end

	# manhattan = manhattan_neighborhoods.each do |n|
	#               Neighborhood.create(:name => n, :borough_id => 3)
	#             end




