class MapsController < ApplicationController
  def new

  end

  def create
    @map = Map.new(params[:latitude], params[:longitude])
    redirect_to action: "index"
  end

  def index
    
  end

end
