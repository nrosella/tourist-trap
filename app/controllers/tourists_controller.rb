class TouristsController < ApplicationController

  def index  
  end

  def create  
  end

  def show
    @coords = YelpTouristTrapper.search_by_coords.find(coord_params)
    @neighborhood = YelpTouristTrapper.search_by_neighborhood(neighborhood_params)
    @tag_creator_neighborhood = TagCreator.convert_hash_to_tag(@neighborhood)
    @tag_creator_coords = TagCreator.convert_hash_to_tag(@coords)
    @istagram_tags_neighborhood = Tag.get_count_for_tag(@tag_creator_neighborhood)
    @instagram_tags_coords = Tag.get_count_for_tag(@tag_creator_coords)
  end

  private

  def coord_params
    params.require(:tourist).permit(:lat, :lng)
  end

  def neighborhood_params
    params.require(:tourist).permit(:neighborhood)
  end

end