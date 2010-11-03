require 'launch_dirs'
require 'fileutils'
class JobDirs
  
  include DirMaker
  include FileUtils
  
  
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

  def job_root_url
    [@launch_dirs.launch_root_url, "jobs", @job_id.to_s].join '/'
  end
  
  def copy_sent_dir
    working_dir = job_root
    sent_dir = launch_dirs.dirs.sent_dir_path
    cp_r Dir.glob(sent_dir + "/*"), working_dir
  end
  


end