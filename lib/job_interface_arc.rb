require 'arc_client_r'

class JobInterfaceArc
   
  include AppLogger
  include FileUtils

  def initialize(job_id)
    @job_id = job_id
  end
  
  def submit
    job = Job.find @job_id
    job_dirs = JobDirs.new(job)
    command_line = job.command_line
    
    logger.debug "submit follows"
    
    working_dir = job_dirs.job_root
    arc_client = ArcClientR.new
    arc_client.submit
      

  end
  
  def running?
    job = Job.find @job_id
    result = false
    if job.address
      has_pid = (`ps -o pid= -p #{(Job.find @job_id).address}`.length > 0)
      result = has_pid
    end
    return result
  end
  
  def stop
    job = Job.find @job_id
    job.state = Job::STOPPING
    job.save!
    #Process.kill(:KILL, job.address.to_i) rescue 0 #dangerous, we should check if we are in the same "uptime session"
    job.state = Job::STOPPED
    job.save!
  end
   
end