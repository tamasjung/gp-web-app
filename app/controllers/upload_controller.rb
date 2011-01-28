class UploadController < ApplicationController


  def index
    @input_file ||= InputFile.new
    @upload_result = "\'\'"
    render(:layout => 'layouts/clear')
  end
  
  def create
    authorize! :call, UploadController
    @input_file ||= InputFile.new
    #@input_file.update_attributes(params[:input_file])
    @upload_result = ActiveSupport::JSON.encode(params[:input_file][:bytes].read)
    render(:layout => 'layouts/clear', :action => 'index')
  end
  
  # TEMP_DIR = 'public/tmp'
  # 
  # def create_temp
  #   ext = params[:ext] || ''
  #   FileUtils.mkdir_p TEMP_DIR
  #   content = params[:temp_upload_input] 
  #   file_id = nil
  #   Tempfile.open(['temp', ext], TEMP_DIR) do |f| 
  #     f.chmod(0644)#TODO
  #     f.write content
  #     file_id = File.basename f.path
  #      
  #   end
  #   render :update do |page| 
  #     page.call 'addDownloadLink', file_id
  #   end
  # end
  
  #TODO useless if file in the public dir, only the mimetype should be set.
  # def get_temp
  #   id = params[:id]
  #   content = File.read File.join(TEMP_DIR, id)
  #   render :text => content, :status => 200
  #   
  # 
  # end

end
