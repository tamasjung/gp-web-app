class SubappsController < ApplicationController
  
  def select
    search_string = params[:subapp_search]
    options = {:page => params[:page], :order => params[:orders]}
    if search_string
      begin
        parser = FilterParser.new(:subapp, [:name, :state], {:creator => 'people.login', :created_at => 'subapps.created_at'})
        options.merge!(parser.parse(search_string)) 
      end
    end
    @subapps = Subapp.paginate options
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'subapp_select', :partial => "select"
        end
      end
    end
  end
  
  def search_autocomplete
    value = params[:value]
    @results = FilterAutoComplete.new(Subapp, [:name, :state]).get_results(value)
    render :partial => '/layouts/search_autocomplete'
  end  
  
  def clone_action
    orig_subapp = Subapp.find(params[:id])
    clone = orig_subapp.clone
    clone.state = Subapp::CREATED
    clone.person = current_user
    clone.parent = orig_subapp
    [:created_at, :updated_at].each do |method|
      clone.send((method.to_s + "="), nil)
    end
    
    version_num = 1
    while true
      clone.name = orig_subapp.name + "." + version_num.to_s
      break unless Subapp.find_by_name clone.name
      version_num += 1
    end 
    
    files = orig_subapp.application_files.find(:all, :select => "id")
    clone.application_files << files
    
    save_ok = clone.save
    if save_ok
      flash.now[:notice] = 'Sub-application was successfully cloned' if save_ok
    end
    
    @subapp = clone
    respond_to do |format|
      format.html {render :action => "edit"}
    end
  end  
  
  def subapp_name_autocomplete
    value = params[:value]
    @results = Subapp.find :all, :select => :name, \
                            :conditions => ['name like ?', '%' + value + '%'] ,\
                            :order => 'name ASC', :limit => 10
                            
    @results.map! do |item| item.name end 
    render :partial => '/layouts/search_autocomplete'
  end
  
  
  # GET /subapps
  # GET /subapps.xml
  def index
    @subapps = Subapp.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subapps }
    end
  end

  # GET /subapps/1
  # GET /subapps/1.xml
  def show
    @subapp = Subapp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subapp }
      format.json { render :json => @subapp }
    end
  end

  # GET /subapps/new
  # GET /subapps/new.xml
  def new
    @subapp = Subapp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subapp }
    end
  end

  # GET /subapps/1/edit
  def edit
    @subapp = Subapp.find(params[:id])
  end
  
  def unlink
    edit
    application_file_id = params[:application_file_id]
    file = ApplicationFile.find application_file_id
    @subapp.application_files.delete file
    if file.subapps.count == 0
      file.destroy
    end
    render :action => :edit
  end

  # POST /subapps
  # POST /subapps.xml
  def create
    @subapp = Subapp.new(params[:subapp])

    respond_to do |format|
      if @subapp.save
        flash[:notice] = 'Subapp was successfully created.'
        format.html { redirect_to(@subapp) }
        format.xml  { render :xml => @subapp, :status => :created, :location => @subapp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subapp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subapps/1
  # PUT /subapps/1.xml
  def update
    @subapp = Subapp.find(params[:id])

    respond_to do |format|
      if @subapp.update_attributes(params[:subapp])
        flash[:notice] = 'Subapp was successfully updated.'
        format.html { redirect_to(@subapp) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subapp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subapps/1
  # DELETE /subapps/1.xml
  def destroy
    @subapp = Subapp.find(params[:id])
    @subapp.destroy

    respond_to do |format|
      format.html { redirect_to(subapps_url) }
      format.xml  { head :ok }
    end
  end
end
