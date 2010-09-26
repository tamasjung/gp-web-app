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
module GpConfig
  
end