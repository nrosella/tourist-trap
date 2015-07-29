class TouristsController < ApplicationController

  def index
    @manhattan_neighborhoods = Borough.find_by(id: 3).neighborhoods
    @brooklyn_neighborhoods = Borough.find_by(id: 2).neighborhoods
    @neighborhood = Neighborhood.new
  end

  def create
    neighborhood = Neighborhood.find(params[:neighborhood][:id]).name
    @results = YelpTouristTrapper.new
    @results.search_by_neighborhood(neighborhood)
    @tag_creator = TagCreator.new.convert_hash_to_tag(@results)
    @instagram_tags = Tag.new.get_count_for_tag(@tag_creator)

    render :results 
  end

  def show
  end


  private

  # def neighborhood_params
  #    params.require(:id).permit(:id, :name)
  # end

end