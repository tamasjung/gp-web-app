class JobsController < ApplicationController
  # GET /jobs
  # GET /jobs.xml
  def index
    @jobs = Job.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end
  
  def select
    search_string = params[:job_search]
    options = {:page => params[:page], :order => params[:orders]}
    options[:page] ||= 1
    if search_string
      begin
        parser = FilterParser.new(:job, [:address, :state])
        options.merge!(parser.parse(search_string)) 
      end
    end
    launch_id = params[:launch_id]
    if launch_id
      (options[:conditions] ||= {})[:launch_id] = launch_id
      @jobs = Job.paginate options
      @launch = Launch.find launch_id
    end
    respond_to do |format|
      format.js do
        if launch_id
          render :update do |page|
            page.replace_html 'jobs', :partial => "select"
          end
        else
          render :nothing => true
        end
      end
    end
  end
  
  def search_autocomplete
    value = params[:value]
    @results = FilterAutoComplete.new(Job, [:address, :state]).get_results(value)
    render :partial => '/layouts/search_autocomplete'
  end  
  
  def stop
    job_id = params[:id]
    (Job.find job_id).do_stop
    respond_js_message "The stop message was sent succesfully."
  end
  
  def restart
    job_id = params[:id]
    (Job.find job_id).do_restart
    respond_js_message "The restart message was sent successfully."
  end
  
  def respond_js_message(message)
    
    class << (js_helper = Object.new)
      include ActionView::Helpers::JavaScriptHelper
    end
    respond_to do |format|
      format.js do 
        render :js => "alert('#{js_helper.escape_javascript(message)}')"
      end
    end
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    @job = Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.save
        flash[:notice] = 'Job was successfully created.'
        format.html { redirect_to(@job) }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        flash[:notice] = 'Job was successfully updated.'
        format.html { redirect_to(@job) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
end
