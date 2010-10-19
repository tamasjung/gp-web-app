require 'fileutils'

class JobInterfaceFork
   
  include AppLogger
  include FileUtils

  def initialize(job_id)
    @job_id = job_id
  end
  
  def submit
    job = Job.find @job_id
    job_dirs = JobDirs.new(job)
    command_line = job.command_line
    logger.debug "fork follows"
    pid = fork do    
      #accessing the job inside the fork block caused exception, most of the time, it was not predictable 
      logger.debug "fork began"
      pid = Process.pid
      working_dir = job_dirs.ensure_working_dir(pid)
      sent_dir = job_dirs.launch_dirs.dirs.sent_dir_path
      cp_r Dir.glob(sent_dir + "/*"), working_dir
      Dir.chdir(working_dir) do
        redirected_command_line = command_line + " > output.txt 2> err.txt ; echo $? > exit.txt"
        logger.debug "redirected_command_line: " + redirected_command_line
        system command_line + " > output.txt 2> err.txt ; echo $? > exit.txt"
      end
      #TODO setting job.state to Job::FINISHED
    end
    Process.detach(pid)
    pid
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