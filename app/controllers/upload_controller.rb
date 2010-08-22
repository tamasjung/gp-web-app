class UploadController < ApplicationController
  def index
    @input_file ||= InputFile.new
    @upload_result = "\'\'"
    render(:layout => 'layouts/clear')
  end
  
  def create
    @input_file ||= InputFile.new
    #@input_file.update_attributes(params[:input_file])
    @upload_result = ActiveSupport::JSON.encode(params[:input_file][:bytes].read)
    render(:layout => 'layouts/clear', :action => 'index')
  end

end
