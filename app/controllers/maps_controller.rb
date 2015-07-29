class MapsController < ApplicationController
  def new

  end

  def create
    @map = Map.new("My Location", params[:latitude], params[:longitude])
    render 'map'
  end

  def index
    
  end

end
