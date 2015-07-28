class HomeController < ApplicationController
  def index
  	@instagram = Instagram.client(:client_id => "836d3b44e64a4c378694e9c4185ae983", :count => 100)
  	binding.pry
  end
end
