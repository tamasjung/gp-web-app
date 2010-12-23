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

  
  def start
    logger.info "Launch start begins #{@launch_id}"
    launch = Launch.find @launch_id
    if([Launch::QUEUED].include? launch.state)
      launch.state = Launch::SENDING
      launch.save!
      logger.debug "Launch state saved to #{Launch::SENDING}"
      start_launch launch
      launch.state = Launch::SENT
      launch.save!
    else
      logger.debug "Launch does not start, its state is #{launch.state}"
    end
  end
  
  def start_launch(launch)
    logger.debug "LaunchExecutor start begins"

    launch_dirs = LaunchDirs.new(launch)
    launch_dirs.ensure_dirs
    
    generate_sent_files launch, launch_dirs
    
    settings = launch.settings_adapter
    seqs = settings.sequences || []
    seq_man = SequenceManager.new(local_sequence_limit)
    number_of_jobs = 0
    send_method = launch.single ? :send : sync_or_async
    seq_man.iterate_locally(seqs) do |seqdefs|
      job = Job.new
      job.launch = launch
      job.state = Job::CREATED
      job.sequence_args = seqdefs.map{|seq| seq.to_arg}.join(' ')
      job.save!
      job_executor = JobExecutor.new(job.id)
      job_executor.send send_method, :start
      number_of_jobs += 1
    end
    logger.debug "Number of jobs created: #{number_of_jobs}"
  end
  
  def restart
    clean_dir
    launch = Launch.find @launch_id
    launch.jobs.delete_all
    launch.state = Launch::QUEUED
    launch.save!
    start
  end
  
  def refresh_state
    logger.debug "LaunchExecutor#refresh_state begins"
    launch = Launch.find @launch_id
    return if launch.stable?
    begin
      launch.refreshing = true
      launch.save!
      launch.jobs.each do |job|
        unless job.stable?
          #TBD running in paralel using the the work_queue gem?
          JobExecutor.new(job.id).refresh_state
        end
      end
      launch.check_state
      if launch.state == Launch::FINISHED
        post_finish launch
      end
    ensure
      launch.refreshing = false
      launch.save!
      logger.debug "LaunchExecutor#refresh_state ends"
    end
  end
  
  def post_finish(launch)
    publish_dir = LaunchDirs.new(launch).dirs.publish_dir_path
    Dir.chdir(publish_dir) do
      system %q[find ../jobs -name 'outputs.tar' -exec tar xf {} \;]
      if launch.settings_adapter.launch_params['compressed_publishing']
        system %q[tar --remove-files -c -z -f result.tar.gz *]
      end
      system('chmod -R a+rX .')
    end
  end
  
  def stop
    launch = Launch.find @launch_id
    launch.jobs.each do |job|
      JobExecutor.new(job.id).stop
    end
  end
    
  def destroy
    clean_dir
    Launch.destroy @launch_id
  end
  
  def clean_dir
    launch_dirs = LaunchDirs.new(Launch.find @launch_id)
    FileUtils.rm_rf launch_dirs.dirs.launch_root
  end
  
  def generate_sent_files(launch, launch_dirs)
    files = launch.settings_adapter.files
    if(files)
      sent_dir = launch_dirs.dirs.sent_dir_path
      files.each do |file|
        write_file sent_dir, file.name, file.content
      end
    end
    launch.subapp.application_files.each do |file|
      write_file sent_dir, file.name, file.bytes
    end
    
  end
  

  
end