class JobExecutor
  
  include AppLogger
  
  attr_accessor :job_id, :sequence_defs
  
  def initializer()
  end
  
  def perform
    job = Job.find job_id
    if(job.state == Job::CREATED)
      job.state = Job::SENDING
      job.save!
      start job
    else
      logger.debug("Job was skipped #{inspect_part job, :id, :state}")
    end
  end
  
  def start(job)
    command_args = job.launch.settings_adapter.command_args
    executable = Rails.root.join("lib", "script", "dummy_exec.rb ") +  job.launch.subapp.executable.to_s + " " + command_args.to_s
    JobDirs.new.create_job_dirs job
    job_interface = JobInterface.new job_id
    pid = job_interface.submit(executable)
    job.address = pid
    job.state = Job::SENT
    job.save!
  end
  
end