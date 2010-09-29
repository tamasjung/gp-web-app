require 'fileutils'

class JobInterfaceFork
   
  include AppLogger
  include FileUtils

  def initialize(job_id)
    @job_id = job_id
    @job_dirs = JobDirs.new
  end
  
  def submit(command_line)
    job = Job.find @job_id
    job.address = Process.pid
    job_dirs = JobDirs.new
    sent_dir = (job_dirs.base_dirs_for job.launch).sent_dir_path
    job_base_path = job_dirs.job_base_path job
    
    fork do    
      #accessing the job inside the fork block caused exception, most of the time, it was not predictable 
      job_dir = File.join(job_base_path, "pid_" + Process.pid.to_s)
      Dir.mkdir job_dir
      cp_r Dir.glob(sent_dir + "/*"), job_dir  
      Dir.chdir(job_dir) do
        system command_line + " > output.txt 2> err.txt ; echo $? > exit.txt"
      end
    end
  end
end