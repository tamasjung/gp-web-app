class PeopleController < ApplicationController
  load_and_authorize_resource
  before_filter :require_no_user, :only => [:new, :create]
  skip_before_filter :require_user, :only => [:new, :create]
  skip_before_filter :require_nickname, :only => [:edit, :update]
  


  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    @person.password = params[:person][:password]
    if @person.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end

  def show
    @person = @current_user
  end

  def edit
    @person = @current_user
  end

  def update
    @person = @current_user # makes our views "cleaner" and more consistent
    if params[:for_remote]
      @person.nickname = params[:person][:nickname]
      if @person.save
        redirect_back_or_default
      else
        render :action => :edit
      end
    else
      if @person.update_attributes(params[:person])
        flash[:notice] = "Account updated!"
        redirect_to account_url
      else
        render :action => :edit
      end
    end
  end
end
