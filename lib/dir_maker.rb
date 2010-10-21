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