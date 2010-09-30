require 'fileutils'

class JobInterfaceFork
   
  include AppLogger
  include FileUtils

  def initialize(job_id)
    @job_id = job_id
  end
  
  def submit(command_line)
    job = Job.find @job_id
    job_dirs = JobDirs.new(job)
    
    fork do    
      #accessing the job inside the fork block caused exception, most of the time, it was not predictable 
      pid = Process.pid
      working_dir = job_dirs.ensure_working_dir(pid)
      sent_dir = job_dirs.launch_dirs.dirs.sent_dir_path
      cp_r Dir.glob(sent_dir + "/*"), working_dir
      Dir.chdir(working_dir) do
        system command_line + " > output.txt 2> err.txt ; echo $? > exit.txt"
      end
      #TODO setting job.state to Job::FINISHED
    end
  end
end