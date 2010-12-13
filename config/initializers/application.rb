#This is the main environment independent configuration module for this gridportal appication.

#TODO search a better place for this
class ActiveRecord::Base
  def self.enum_field(name, arr)
    arr.each do |item|
      class_eval "#{item}='#{item}'"
    end
    class_eval "#{name.upcase}_LIST = arr"
    class_eval "def #{name}=(the_name)
      raise 'invalid #{name}' if !#{name.upcase}_LIST.include? the_name
      write_attribute(:#{name}, the_name)
    end"
  end
end



module AppLogger
  def logger
    if defined?(RAILS_DEFAULT_LOGGER)
      RAILS_DEFAULT_LOGGER
    else
      nil
    end
  end
end
  
class HashAccessor
  
  def initialize(hash)
    hash.each do |key, value|
      self.class.instance_eval do
        attr_accessor key
      end
      self.send key.to_s + "=", value
    end
  end
  
end

def unhumanize(str)
  str.to_s.downcase.gsub(/ +/,'_')
end

def inspect_part(obj, *props)
  props.map do |prop| (obj.send prop).inspect end.join ', '
end

def write_file(dir, file_name, content, mod = nil)
  file_path = File.join dir, file_name
  File.open(file_path, "w") do |f|
    f.write content
  end
end

#TODO into different file
$dependency_context = DependencyContext.new({
  :remote_logout_url => '/Shibboleth.sso/Logout',
  :launch_base_dir => File.join(Rails.root, 'public', 'system', 'launches'),
  :launch_base_url => "/system/launches",
  :launch_dir_mod => 0755,
  :local_sequence_limit => 10,
  :sync_or_async => :send_later
  #:sync_or_async => :send
})


#JobInterface = JobInterfaceFork
JobInterface = JobInterfaceArc

require_dependency 'launch_executor'
require_dependency 'job_executor'