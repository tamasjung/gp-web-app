class JobsController < ApplicationController
  
  load_and_authorize_resource
  
  def select
    search_string = params[:job_search]
    options = {:page => params[:page], :order => params[:orders]}
    options[:page] ||= 1
    if search_string
      begin
        parser = FilterParser.new(:job, [:state], {:portal => 'id'})
        options.merge!(parser.parse(search_string)) 
      end
    end
    launch_id = params[:launch_id]
    if launch_id
      cond = options[:conditions] 
      if cond
        cond[0] += ' AND launch_id = :launch_id'
        cond[1][:launch_id] = launch_id
      else
        options[:conditions] = {:launch_id => launch_id}
      end
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




end
