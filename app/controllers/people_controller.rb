class PeopleController < ApplicationController
    
  skip_before_filter :require_user, :only => [:new, :create]
  skip_before_filter :require_nickname, :only => [:edit, :update]
  
  def select
    authorize! :read, Person
    search_string = params[:person_search]
    options = {:page => params[:page], :order => params[:orders]}
    
    if search_string
      begin
        parser = FilterParser.new(:person, [:nickname])
        options.merge!(parser.parse(search_string)) 
      end
    end
    @people = Person.paginate options
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'person_select', :partial => "select"
        end
      end
    end
  end
  
  def search_autocomplete
    authorize! :read, Person
    value = params[:value]
    @results = FilterAutoComplete.new(Person, [:nickname]).get_results(value)
    render :partial => '/layouts/search_autocomplete'
  end

  def show
    @person = Person.find(params[:id])
    authorize! :read, @person
  end

  def edit
    @person = Person.find(params[:id])
    authorize! :update, @person
  end

  def update
    @person = Person.find(params[:person][:id])
    authorize! :update, @person
    update_roles(@person)
    @person.nickname = params[:person][:nickname]
    @person.save
    render :action => :edit
  end
  
  def destroy
    @person = Person.find(params[:id])
    authorize! :destroy, @person
    @person.destroy
    respond_to do |format|
      format.js {redirect_to(:action => :select, :orders => params[:orders])}
    end
  end
  
  private
  
  def update_roles(person)
    Person::ROLES.each do |role|
      has_role = !params[role].nil?
      changed = (person.has_role? role) ^ (has_role)
      if changed
        authorize! ('appoint_' + role).to_sym, person 
        if has_role
          person.add_role role
        else
          person.remove_role role
        end
      end
    end
  end
  

end
