# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :init
  before_filter :login_check, :except => [:login_index, :login_create]
  
  
  def init
    @git_version = @@git_version
  end
  
  
  def self.init_git_version
    #`git log --pretty=online`
    @@git_version = `git log -n1 --pretty=format:%H-%cd`
  end
  init_git_version
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  

  def login_check
    unless cookies[:nick] 
      session[:return_to] = request.request_uri
      redirect_to :controller => :login, :action => :login_index
    end
  end
end
