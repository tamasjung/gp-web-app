class UserSessionsController < ApplicationController
  
  dependencies :remote_logout_url
  
  before_filter :require_no_user, :only => [:new, :create]
  skip_before_filter :require_user, :only => [:new, :create]
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    remote_logout = current_user.has_remote_id?
    current_user_session.destroy if current_user_session
    if remote_logout
      redirect_to remote_logout_url
    else
      flash[:notice] = "Logout successful!"
      redirect_back_or_default new_user_session_url
    end
  end
end