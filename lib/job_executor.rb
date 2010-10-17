class JobExecutor
  
  include AppLogger
  
  attr_accessor :job_id, :sequence_defs
  
  def initializer()
  end
  
  def start
    job = Job.find job_id
    if([Job::CREATED, Job::SENDING].member? job.state)
      job.state = Job::SENDING
      job.save!
      start job
    else
      logger.debug("Job was skipped #{inspect_part job, :id, :state}")
    end
  end
  
  def start_job(job)
    sequence_args = sequence_defs.map{|seq| seq.to_arg}.join(' ')
    command_args = job.launch.settings_adapter.command_args + " " + sequence_args
    command_line = Rails.root.join("lib", "script", "dummy_exec.rb ") +  job.launch.subapp.executable.to_s + " " + command_args.to_s
    JobDirs.new(job).ensure_job_root
    job_interface = JobInterface.new job_id
    pid = job_interface.submit(command_line)
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
      when Job::STOPPING
        job.state = Job::STOPPED unless running
      end
      job.save!
    end
  end
  
  def stop
    job = Job.find @job_id
    (JobInterface.new job.id).stop
  end
  
end