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
    if([Launch::CREATED, Launch::SENDING].member? launch.state)
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

    launch_dirs = LaunchDirs.new(launch)
    launch_dirs.ensure_dirs
    
    generate_sent_files launch, launch_dirs
    
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
  
  def generate_sent_files(launch, launch_dirs)
    files = launch.settings_adapter.files
    if(files)
      sent_dir = launch_dirs.dirs.sent_dir_path
      files.each do |file|
        file_path = File.join sent_dir, file.name
        File.open(file_path, "w") do |f|
          f.write file.content
        end
      end
    end
    #TODO create subapp files
    
  end
  
end