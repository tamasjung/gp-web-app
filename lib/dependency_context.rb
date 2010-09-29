# For substitute the whole dependency context mess with manual dependency setting write this:
# class Object
#   def self.dependencies(*deps)
#     self.instance_eval do 
#       attr_accessor *deps
#     end
#   end
# end

class DependencyContext 
  
  def initialize(init_hash = {})
    @hash = init_hash
  end
  
  def add(key, value = nil, &block)
    raise self.class + ".add: key is nil" unless key
    if(value)
      @hash[key] = value
    else
      if block
        @hash[key] = block
      else
        raise self.class + ".add: neither value nor block was given"
      end
    end
  end
  
  def merge(hash)
    @hash.merge hash
  end
  
  def get(instance, dependency)
    result = @hash[dependency]
    if result.is_a? Proc
      result.call(instance)
    else
      result
    end
  end 
end

class Object
  def self.dependencies(*deps)
    deps.each do |dependency|
      self.class_eval "def #{dependency}; $dependency_context.get(self, :#{dependency}) end"
    end
  end
end


# 
# Usage:
# class A
#   dependencies :bbb, :ccc
# end
# 
# 
# $context.add(:bbb, 'bvalue')
# $context.add :ccc do |instance| instance.to_s end
#   
# $context.merge({
#   :ccc => "cccval",
#   :ddd => "dddval"
# })
