class TagCreator

	def convert_hash_to_tag(result_hash)
		
		if result_hash.landmarks.first
			new_tag = result_hash.landmarks.first
			converted = new_tag.split(/\s/).join("").downcase
		else
			new_tag = result_hash.neighborhoods.first.split(",")
			converted = new_tag.first.gsub(" ", "").downcase

		end
		converted
	end

end