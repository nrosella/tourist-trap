class MapsController < ApplicationController
  def new
    @manhattan_neighborhoods = Borough.find_by(id: 3).neighborhoods.order("name ASC")
    @brooklyn_neighborhoods = Borough.find_by(id: 2).neighborhoods.order("name ASC")
    @neighborhood = Neighborhood.new
  end

  def create
    @map = Map.new(params[:latitude], params[:longitude])
    render 'map'
  end

  def index
    
  end

end
