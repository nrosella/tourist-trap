class TagCreator

	def convert_hash_to_tag(result_hash)
		# binding.pry
		if !result_hash.landmarks.empty?
			new_tag = result_hash.landmarks
			converted = new_tag.split(/\s/).join("").downcase
		else
			new_tag = result_hash.neighborhood.split(",")
			converted = new_tag.first.gsub(" ", "").downcase

		end
		converted
	end

end