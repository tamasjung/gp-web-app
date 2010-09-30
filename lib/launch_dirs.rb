module DirMaker
  def ensure_dir(path, mode)
    unless isDir(path)
      Dir.mkdir path, mode
    else
      unless File.stat(path).mode == mode
        raise "could not change mode for #{path}" unless (1 == File.chmod(mode, path))
      end
    end
  end
  
  def isDir(path)
    (File.exist? path) && (File.directory? path)
  end
  
end
    

class LaunchDirs
  
  include DirMaker
  
  dependencies :launch_base_dir, :launch_dir_mod
  
  def initialize(launch)
    @launch_id = launch.id
  end

  def dirs
    launch_dir = File.join launch_base_dir, @launch_id.to_s
    return HashAccessor.new({
      :launch_root => launch_dir,
      :sent_dir_path => (File.join launch_dir, 'sent'),
      :jobs_dir_path => (File.join launch_dir, 'jobs')
    })
  end
  
  def ensure_dirs
    
    _dirs = dirs
    
    raise "launch_base_dir - #{launch_base_dir} - directory does not exist" unless (isDir launch_base_dir)
    
    [_dirs.launch_root, _dirs.sent_dir_path, _dirs.jobs_dir_path].each do |path|
      ensure_dir path, launch_dir_mod
    end
  end
end


    