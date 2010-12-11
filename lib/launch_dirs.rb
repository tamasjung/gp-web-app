require 'dir_maker'


class LaunchDirs
  
  include DirMaker
  
  dependencies :launch_base_dir, :launch_dir_mod, :launch_base_url
  
  def initialize(launch)
    @launch_id = launch.id
  end

  def dirs
    launch_dir = File.join launch_base_dir, @launch_id.to_s
    return HashAccessor.new({
      :launch_root => launch_dir,
      :sent_dir_path => (File.join launch_dir, 'sent'),
      :jobs_dir_path => (File.join launch_dir, 'jobs'),
      :publish_dir_path => (File.join launch_dir, 'publish')
    })
  end
  
  def launch_root_url
    launch_base_url + "/" + @launch_id.to_s #keep it in sync with the above
  end
  
  def launch_publish_url
    launch_base_url + "/" + @launch_id.to_s + "/publish"  #keep it in sync with the above
  end
  
  def ensure_dirs
    
    _dirs = dirs
    
    raise "launch_base_dir - #{launch_base_dir} - directory does not exist" unless (isDir launch_base_dir)
    
    [_dirs.launch_root, _dirs.sent_dir_path, _dirs.jobs_dir_path, _dirs.publish_dir_path].each do |path|
      ensure_dir path, launch_dir_mod
    end
  end
end


    