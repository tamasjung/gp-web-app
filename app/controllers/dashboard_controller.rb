class DashboardController < ApplicationController
  def index
    @subapps = Subapp.all#TODO: filter, history, mru top
    
  end
  
  private 
  
  

end
