class ApplicationFilesController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /application_files
  # GET /application_files.xml
  def index
    @application_files = ApplicationFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @application_files }
    end
  end

  # GET /application_files/1
  # GET /application_files/1.xml
  def show
    @application_file = ApplicationFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @application_file }
    end
  end
  
  def bytes
    file = ApplicationFile.find params[:id]
    send_data(file.bytes, :filename => file.name)
  end

  # GET /application_files/new
  # GET /application_files/new.xml
  def new
    @application_file = ApplicationFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @application_file }
    end
  end

  # GET /application_files/1/edit
  def edit
    @application_file = ApplicationFile.find(params[:id])
  end

  # POST /application_files
  # POST /application_files.xml
  def create
    @application_file = ApplicationFile.new(params[:application_file])
    
    subapp_id = params[:subapp_id]
    subapp = nil
    save_ok = false
    begin
    ApplicationFile.transaction do 
      save_ok = @application_file.save!
      subapp = Subapp.find subapp_id
      @application_file.subapps << subapp
    end
    rescue ActiveResource::ResourceInvalid
    end

    respond_to do |format|
      if @application_file.save
        if subapp_id
          format.html { redirect_to :controller => :subapps, :action => :edit, :id => subapp_id, :notice => "ApplicationFile was successfully added"}
        else
          format.html { redirect_to(@application_file, :notice => 'ApplicationFile was successfully created.') }
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /application_files/1
  # PUT /application_files/1.xml
  def update
    @application_file = ApplicationFile.find(params[:id])

    respond_to do |format|
      if @application_file.update_attributes(params[:application_file])
        format.html { redirect_to(@application_file, :notice => 'ApplicationFile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @application_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /application_files/1
  # DELETE /application_files/1.xml
  def destroy
    @application_file = ApplicationFile.find(params[:id])
    @application_file.destroy

    respond_to do |format|
      format.html { redirect_to(application_files_url) }
      format.xml  { head :ok }
    end
  end
end
