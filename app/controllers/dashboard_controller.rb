class DashboardController < ApplicationController
  def index
    @subapps = Subapp.all#TODO: filter, history, mru top
    flash[:notice] = :huh
  end
  
  private 
  
  

end
