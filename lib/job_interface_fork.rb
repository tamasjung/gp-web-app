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
    command_line = Rails.root.join("lib", "script", "dummy_exec.rb ").to_s +  job.launch.subapp.executable.to_s + " " +job.command_line
    logger.debug "fork follows"
    pid = fork do    
      #accessing the job inside the fork block caused exception, most of the time, it was not predictable 
      logger.debug "fork began"
      working_dir = job_dirs.job_root
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
  
  def refresh_state
    job = Job.find @job_id
    unless job.stable?
      running = running? job
      case job.state
      when Job::SENT
        job.state = Job::FINISHED unless running
        job.save!
      when Job::STOPPING
        job.state = Job::STOPPED unless running
        job.save!
      end
    end
  end
  
  def running?(job)
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