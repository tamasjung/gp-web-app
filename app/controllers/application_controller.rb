# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :init#TODO clean
  rescue_from CanCan::AccessDenied do |exception|
    flash.now[:error] = exception.message 
    redirect_to ''
  end
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  before_filter :require_user



  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.person
  end
  
  
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end  
  
  def debug_info 
    
    lines = []
    ENV.sort.each do |i|
      lines << i.join('=')
    end
    render :text => (Rails::Info.to_s + "\n\nENVIRONMENT VARIABLES:\n" + lines.join("\n")) , :content_type => 'text/plain'
  end
  
  def init
    @git_version = @@git_version
    bm = params[:broadcast]
    self.class.save_broadcast bm if bm 
    
  end
  
  DIR_NAME = 'tmp/broadcast'
  BC_FILE = DIR_NAME + '/message.txt'
  def self.save_broadcast(message)
    FileUtils.mkdir_p DIR_NAME
    File.open(BC_FILE, "w") do |file|
      file.puts(message)
    end
  end
  
  def self.broadcast
    File.read BC_FILE rescue ""#TODO remove broadcast
  end
  
  
  def self.init_app
    #`git log --pretty=online`
    @@git_version = `git log -n1 --pretty=format:%H-%cd`
    @@broadcast_message = ""
  end
  init_app
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def pool_broadcast
    render :text => ApplicationController.broadcast
  end


end
