require 'sequence_manager'
require 'dependency_context'
require 'fileutils'

class LaunchExecutor
  
  include AppLogger
  
  dependencies :local_sequence_limit, :sync_or_async, :launch_base_dir
  
  def initialize(launch_id)
    @launch_id = launch_id
    logger.info "Launch created #{launch_id}" 
  end
  
  def perform
    logger.info "Launch perform begins #{@launch_id}"
    launch = Launch.find @launch_id
    if(launch.state == Launch::CREATED)
      launch.state = Launch::SENDING
      launch.save!
      logger.debug "Launch state saved to #{Launch::SENDING}"
      start launch
    else
      logger.debug "Launch does not perform, its state is #{launch.state}"
    end
  end
  
  def start(launch)
    logger.debug "LaunchExecutor start begins"

    JobDirs.new.create_base_dirs_for(launch)
    
    settings = launch.settings_adapter
    seqs = settings.sequences || []
    seq_man = SequenceManager.new(local_sequence_limit)
    seq_man.iterate_locally(seqs) do |seqdefs|
      job = Job.new
      job.launch = launch
      job.state = Job::CREATED
      job.save!
      job_executor = JobExecutor.new()
      job_executor.job_id = job.id
      job_executor.sequence_defs = seqdefs
      job_executor.send sync_or_async, :perform
    end 

  end
end