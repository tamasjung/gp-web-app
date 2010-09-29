class JobDirs
  
  dependencies :launch_base_dir, :launch_base_dir_permission
  
  def initialize()
   
  end
  
  def job_base_path(job)
    dirs = base_dirs_for job.launch
    result = File.join dirs.jobs_dir_path, job.id.to_s
    result
  end
  
  def job_path(job)
    result = File.join job_base_path(job), job.address_path
  end
  
  def create_job_dir(job)
    Dir.mkdir job_path(job), launch_base_dir_permission
  end
  
  def create_job_dirs(job)
    Dir.mkdir job_base_path(job), launch_base_dir_permission
  end
  
  def base_dirs_for(launch)
    launch_dir = File.join launch_base_dir, launch.id.to_s
    return HashAccessor.new({
      :launch_dir => launch_dir,
      :sent_dir_path => (File.join launch_dir, 'sent'),
      :jobs_dir_path => (File.join launch_dir, 'jobs')
    })
  end
  
  def create_base_dirs_for(launch)
    
    dirs = base_dirs_for launch
    
    raise "launch_base_dir - #{launch_base_dir} - directory does not exist" unless (File.exist? launch_base_dir) && (File.directory? launch_base_dir)
    
    [dirs.launch_dir, dirs.sent_dir_path, dirs.jobs_dir_path].each do |path|
      Dir.mkdir path, launch_base_dir_permission
    end
  end
end