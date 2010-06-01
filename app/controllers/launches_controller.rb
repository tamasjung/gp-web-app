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
    read_partial
    @subapp = Subapp.find params[:subapp_id]
    @launch = Launch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @launch }
    end
  end

  # GET /launches/1/edit
  def edit
    @launch = Launch.find(params[:id])
  end

  # POST /launches
  # POST /launches.xml
  def create
    @launch = Launch.new(params[:launch])

    respond_to do |format|
      if @launch.save
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
  def read_partial
    input_page = IO.read("app/views/input/r3bp.html.haml")
    engine = Haml::Engine.new(input_page, :suppress_eval => true)
    @input_html = engine.render 
  end
end
