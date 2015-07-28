class TagCreator

	def convert_hash_to_tag(result_hash)
		if result_hash[:landmarks][0]
			new_tag = result_hash[:landmarks][0]
			converted = new_tag.split(/\s/).join("").downcase
		else
			new_tag = result_hash[:neighborhoods][0]
			converted = new_tag.split(/\s/).join("").downcase
		end
		converted
	end

end