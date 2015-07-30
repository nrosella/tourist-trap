class MapsController < ApplicationController
  def new

  end

  def create
    @map = Map.new(params[:latitude], params[:longitude])
    render 'map'
  end

  def index
    
  end

end
