class SubappsController < ApplicationController
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
