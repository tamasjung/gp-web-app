require 'erb'
require 'arc_client_r'

class JobInterfaceArc
   
  include AppLogger
  include FileUtils
  
  JOB_LIST_FILE_NAME = ".job_list.xml"

  def initialize(job_id)
    @job_id = job_id
  end
  
  def joblist(job)
    job_dirs = JobDirs.new job
    result = File.join job_dirs.job_root, JOB_LIST_FILE_NAME
    result
  end
  
  def backup_joblist(job)
    joblist_file = joblist(job)
    cp joblist_file, joblist_file + '.backup.xml'
  end
  
  def submit
    job = Job.find @job_id
    job_dirs = JobDirs.new(job)
    
    logger.debug "submit follows"
    
    working_dir = job_dirs.job_root
    
    files = job.launch.all_files_info
    
    template = job.launch.subapp.jsdl
    
    jsdl = ERB.new(template).result(binding)
    
    arc_client = ArcClientR.new
    message, result = arc_client.submit ["-e", jsdl, "-j", joblist(job)]
    logger.debug message
    result
  end
  
  def refresh_state
    job = Job.find @job_id
    arc_client = ArcClientR.new
    message, stat = arc_client.stat(["-j", joblist(job), job.address])
    logger.debug message if message
    arc_state = stat.upcase rescue nil
    case arc_state
    when 'FINISHED', 'FAILED'
      job_dirs = JobDirs.new job
      working_dir = job_dirs.job_root
      backup_joblist job
      get_message, get_result = arc_client.get(["-D", working_dir, "-j", joblist(job), job.address])
      logger.debug get_message if get_message
      logger.debug get_result
      if get_result == 0
        job.state = arc_state
      end
      job.save!
    end
  end
  
  def stop
    logger.error "Stop is not implemented yet"
  end
   
end