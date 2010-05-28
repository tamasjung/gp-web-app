class LoginController < ApplicationController
  def login_index
    @person = Person.new
    
    render :action => :index
  end
  
  # POST /people
  # POST /people.xml
  def login_create
    @person = Person.new(params[:person])
    session[:nick_name] = @person.nick
    key_ok = ( params[:sec][:secret_key] == '1234567654321')
    
    if key_ok
      flash[:notice] = "Welcome #{@person.nick}"
      redirect_to session[:return_to]
      session[:return_to] = nil
      cookies[:nick] = { :value	=> @person.nick, :expires => 90.days.from_now}
    else
      flash[:error] = 'Bad secret key'
      render :action => :index
    end
    
  end
  
  
    
end
