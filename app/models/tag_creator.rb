class TagCreator

	def convert_hash_to_tag(result_hash)
		new_tag = result_hash.neighborhood.split(",")
		converted = new_tag.first.gsub(" ", "").downcase
		converted
	end

end