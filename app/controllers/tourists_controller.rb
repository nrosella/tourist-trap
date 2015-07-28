class TouristsController < ApplicationController

  def index  
  end

  def create 
    @coords = YelpTouristTrapper.new.search_by_coords(coord_params[:lat].to_f, coord_params[:lon].to_f)
    @neighborhood = YelpTouristTrapper.new.search_by_neighborhood(neighborhood_params[:neighborhood])
    @tag_creator_neighborhood = TagCreator.new.convert_hash_to_tag(@neighborhood)
    @tag_creator_coords = TagCreator.new.convert_hash_to_tag(@coords)
    @istagram_tags_neighborhood = Tag.new.get_count_for_tag(@tag_creator_neighborhood)
    @instagram_tags_coords = Tag.new.get_count_for_tag(@tag_creator_coords)
  end

  private

  def coord_params
    params.require(:tourist).permit(:lat, :lon)
  end

  def neighborhood_params
    params.require(:tourist).permit(:neighborhood)
  end

end