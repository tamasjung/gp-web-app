class JobExecutor
  
  include AppLogger
  
  
  def initialize(job_id)
    @job_id = job_id
  end
  
  def start
    job = Job.find @job_id
    if([Job::CREATED, Job::SENDING].member? job.state)
      job.state = Job::SENDING
      job.save!
      start_job job
    else
      logger.debug("Job was skipped #{inspect_part job, :id, :state}")
    end
  end
  
  def start_job(job)
    sequence_args = job.sequence_args
    command_args = job.launch.settings_adapter.command_args + " " + (sequence_args || "")
    command_line = command_args.to_s
    job.command_line = command_line.to_s
    job.save!
    job_dirs = JobDirs.new(job)
    job_dirs.ensure_job_root
    job_dirs.copy_sent_dir
    job_interface = JobInterface.new @job_id
    pid = job_interface.submit
    job.address = pid
    if pid
      job.state = Job::SENT
    else
      job.state = Job::UNSENT
    end
    job.save!
  end
  
  def refresh_state
    JobInterface.new(@job_id).refresh_state
  end
  
  def restart
    job = Job.find @job_id
    clean_dir job
    job.state = Job::CREATED
    job.remote_state = nil
    job.save!
    launch = job.launch
    launch.state = Launch::SENDING
    launch.save!
    start
    launch.state = Launch::SENT
    launch.save!
  end

  def stop
    job = Job.find @job_id
    (JobInterface.new job.id).stop
  end
  
  def clean_dir(job)
    job_root = JobDirs.new(job).job_root
    FileUtils.rm_rf job_root
  end
  
end