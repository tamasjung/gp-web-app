require 'launch_dirs'

class JobDirs
  
  include DirMaker
  
  dependencies :launch_base_dir, :launch_dir_mod
  
  attr_reader :job, :launch_dirs
  
  def initialize(job)
   @job_id = job.id
   @launch_id = job.launch.id
   @launch_dirs = LaunchDirs.new(job.launch)
   @job_address = job.address
  end
  
  def job_root
    dirs = @launch_dirs.dirs
    result = File.join dirs.jobs_dir_path, @job_id.to_s
    result
  end
  
  def ensure_job_root
    ensure_dir job_root, launch_dir_mod
  end
  
  def working_dir(pid)
    result = File.join job_root, pid.to_s
    result
  end

  def job_root_url
    @launch_dirs.launch_root_url + "/" + @job_id.to_s + (@job_address.nil? ? "" : ("/" + @job_address.to_s))
  end
  
  def ensure_working_dir(pid)
    result_path = working_dir(pid)
    ensure_dir result_path, launch_dir_mod
    result_path
  end

end