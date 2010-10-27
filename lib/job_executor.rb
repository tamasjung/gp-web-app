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
    command_line = Rails.root.join("lib", "script", "dummy_exec.rb ").to_s +  job.launch.subapp.executable.to_s + " " + command_args.to_s
    job.command_line = command_line.to_s
    job.save!
    job_dirs = JobDirs.new(job)
    job_dirs.ensure_job_root
    job_dirs.copy_sent_dir
    job_interface = JobInterface.new @job_id
    pid = job_interface.submit
    job.address = pid
    job.state = Job::SENT
    job.save!
  end
  
  def refresh_state
    job = Job.find @job_id
    unless job.stable?
      job_interface = JobInterface.new job.id
      running = job_interface.running?
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
  
  def restart
    job = Job.find @job_id
    clean_dir job
    job.state = Job::CREATED
    job.save!
    start
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