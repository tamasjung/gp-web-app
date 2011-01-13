class LaunchesController < ApplicationController
  
  load_and_authorize_resource
  
  def select
    search_string = params[:launch_search]
    options = {:page => params[:page], :order => params[:orders]}
    
    unless search_string
      if params[:preferences] == 'true'
        pref = Preference.find_mine current_user
        search_string = pref.get_last_launch_search
        params[:launch_search] = search_string
      end
    else
      (Preference.find_mine current_user).save_last_launch_search search_string
    end
    if search_string
      begin
        parser = FilterParser.new(:launch, [:name, :state], {:creator => 'people.login', :created_at => 'launches.created_at'})
        options.merge!(parser.parse(search_string)) 
      end
    end
    @launches = Launch.paginate options
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'launch_select', :partial => "select"
        end
      end
    end
  end
  
  def search_autocomplete
    value = params[:value]
    @results = FilterAutoComplete.new(Launch, [:name, :state]).get_results(value)
    render :partial => '/layouts/search_autocomplete'
  end

  # GET /launches/new
  # GET /launches/new.xml
  def new
    
    @launch = Launch.new
    
    subapp_id = params[:subapp_id]
    unless subapp_id
      raise "missing subapp_id"
    else
      cookies[:last_subapp] = subapp_id#TODO check if this is required
    end
    
    @subapp = Subapp.find subapp_id
    
    raise "The subapp(id:#{@subapp.id}) is not permitted" unless @subapp.is_permitted?
    
    @launch.subapp = @subapp
    
    read_input_partial
    
    respond_to do |format|
      format.html { render :action => :edit}
      format.xml  { render :xml => @launch }
    end
  end
  
  def show
    edit
    render :action => :edit
  end

  # GET /launches/1/edit
  def edit
    @launch = Launch.find(params[:id])
    read_input_partial
  end
  

  # POST /launches
  # POST /launches.xml
  def create
    @launch = Launch.new(params[:launch])
    commit = unhumanize params[:commit]
    @launch.person = current_user
    return render :action => 'edit' unless @launch.valid? 
    save_ok = false
    case commit
    when "save"
      @launch.state = Launch::CREATED
      save_ok = @launch.save
    when "start"
      @launch.state = Launch::QUEUED
      save_ok = @launch.do_start
    else
      raise "unknown commit: #{commit}"
    end
    unless @launch.name.size > 0
      @launch.name = @launch.generated_name
      save_ok = @launch.save
    end
    #cookies[:last_subapp] = @launch.subapp.id
    read_input_partial
    respond_to do |format|
      if save_ok 
        flash.now[:notice] = "#{@launch.name} was successfully #{commit == 'save' ? 'created' : 'queued' }."
      end
      format.html { render :action => :edit }
    end
  end

  def update
    commit = unhumanize params[:commit]
    return clone_action if commit == 'clone'
    return transpose_action if commit == 'transpose' 
    @launch = Launch.find(params[:id])
    return edit unless @launch.valid?
    
    read_input_partial
    if ["save", "start"].include? commit
      update_ok = @launch.update_attributes(params[:launch])
    end
    @launch.action_call commit
    
    respond_to do |format|
      if update_ok
        flash[:notice] = 'Launch was successfully updated.'
        format.html { render :action => :edit }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def clone_action
    orig_launch = Launch.find(params[:id])
    clone = orig_launch.clone
    clone.state = Launch::NEW
    clone.person = current_user
    clone.parent = orig_launch
    [:name, :created_at, :updated_at, :start_time, :finish_time].each do |method|
      clone.send((method.to_s + "="), nil)
    end
    
    save_ok = clone.save#for getting the id
    if save_ok
      clone.name = clone.generated_name
      clone.state = Launch::CREATED
      save_ok = clone.save
      flash.now[:notice] = 'Launch was successfully cloned' if save_ok
    end
    
    @launch = clone
    read_input_partial
    respond_to do |format|
      format.html {render :action => "edit"}
    end
  end
  
  def transpose_action
    @launch = Launch.find(params[:id])
    new_subapp_name = params[:subapp_lookup]
    if @launch.subapp.name != new_subapp_name
      subapp = Subapp.find_by_name new_subapp_name
      unless subapp
        flash.now[:error] = 'Wrong sub-application name'
      else
        @launch.subapp = subapp
        if @launch.save
          flash.now[:notice] = 'Launch was successfully transposed'
        end
      end
    end
    read_input_partial
    respond_to do |format|
      format.html {render :action => "edit"}
    end
  end
  


  # DELETE /launches/1
  # DELETE /launches/1.xml
  def destroy
    @launch = Launch.find(params[:id])
    @launch.destroy
    p url_for(:controller => :launches, :action => :select, :orders => params[:orders], :launch_search => params[:launch_search])
    respond_to do |format|
      format.html { redirect_to(launches_url) }
      format.xml  { head :ok }
      format.js {redirect_to(:action => :select, :orders => params[:orders], :launch_search => params[:launch_search])}
    end
  end
  
  private
  def read_input_partial
    input_page = @launch.subapp.input_partial
    if input_page.nil? || input_page.strip.length == 0 #load default
      begin
        dir  = "app/views/input"
        file_name = "#{dir}/#{@launch.subapp.tech_name}.html.haml"
        raise "file not found #{file_name}" unless File.exist? file_name
        raise "illegal file path #{file_name}" unless (File.dirname(File.expand_path file_name) == File.expand_path(dir))
        input_page = IO.read(file_name)
      rescue  
        input_page = "No template found"
      end
    end
    @embedded_css = input_page[/EMBEDDED_STYLE(.*)EMBEDDED_STYLE/m, 1] rescue ""
    engine = Haml::Engine.new(input_page, :suppress_eval => false)
    @input_html = engine.render
  end
  
  
end
