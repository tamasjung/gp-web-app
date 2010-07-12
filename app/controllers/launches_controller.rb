class LaunchesController < ApplicationController
  # GET /launches
  # GET /launches.xml
  def index
    @launches = Launch.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @launches }
    end
  end

  # GET /launches/1
  # GET /launches/1.xml
  def show
    @launch = Launch.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @launch }
    end
  end

  # GET /launches/new
  # GET /launches/new.xml
  def new
    
    @launch = Launch.new
    
    subapp_id = params[:subapp_id]
    subapp_id ||= cookies[:last_subapp]
    unless subapp_id
      raise "missing subapp_id"
    else
      cookies[:last_subapp] = subapp_id
    end
    
    
    @subapp = Subapp.find subapp_id
    @launch.subapp = @subapp
    read_input_partial
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @launch }
    end
  end

  # GET /launches/1/edit
  def edit
    @launch = Launch.find(params[:id])
    cookies[:last_subapp] = @launch.subapp.id
    read_input_partial
  end

  # POST /launches
  # POST /launches.xml
  def create
    @launch = Launch.new(params[:launch])
    save_ok = @launch.save
    unless @launch.name.size > 0
      @launch.name = @launch.subapp.name + "-" + @launch.id.to_s#generate a name
      save_ok = @launch.save
    end
    cookies[:last_subapp] = @launch.subapp.id
    read_input_partial
    respond_to do |format|
      if save_ok 
        flash[:notice] = 'Launch was successfully created.'
        format.html { redirect_to(@launch) }
        format.xml  { render :xml => @launch, :status => :created, :location => @launch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @launch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /launches/1
  # PUT /launches/1.xml
  def update
    @launch = Launch.find(params[:id])
    cookies[:last_subapp] = @launch.subapp.id
    read_input_partial
    respond_to do |format|
      if @launch.update_attributes(params[:launch])
        flash[:notice] = 'Launch was successfully updated.'
        format.html { redirect_to(@launch) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @launch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /launches/1
  # DELETE /launches/1.xml
  def destroy
    @launch = Launch.find(params[:id])
    @launch.destroy

    respond_to do |format|
      format.html { redirect_to(launches_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def read_input_partial
    begin
      dir  = "app/views/input"
      file_name = "#{dir}/#{@launch.subapp.tech_name}.html.haml"
      raise "file not found #{file_name}" unless File.exist? file_name
      raise "illegal file path" unless (File.dirname(File.expand_path file_name) == File.expand_path(dir))
      input_page = IO.read(file_name)
    rescue  
      input_page = "No template found"
    end
    @embedded_css = input_page[/EMBEDDED_STYLE(.*)EMBEDDED_STYLE/m, 1] rescue ""
    engine = Haml::Engine.new(input_page, :suppress_eval => false)
    @input_html = engine.render
  end
  
  
end
