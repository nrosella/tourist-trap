class MapsController < ApplicationController
  def new
    @manhattan_neighborhoods = Borough.find_by(id: 3).neighborhoods.order("name ASC")
    @brooklyn_neighborhoods = Borough.find_by(id: 2).neighborhoods.order("name ASC")
    @neighborhood = Neighborhood.new
  end

  def create
    neighborhood = Neighborhood.find(params[:neighborhood][:id]).name
    ytt = YelpTouristTrapper.new.search_by_neighborhood(neighborhood)
    binding.pry
    @map = Map.new(ytt.coords[:latitude], ytt.coords[:longitude])
    render 'map'
  end

  def index
    
  end

end
