class Person < ActiveRecord::Base
  
  ROLES = %w/researcher senior admin/
  
  attr_protected :remote_id
  attr_readonly :remote_id
  has_many :subapps
  has_many :launches
  has_one :preference, :dependent => :destroy
  validates_uniqueness_of :remote_id, :allow_nil => false
  validates_presence_of :nickname, :on => :update
  
  def display_name
    self.nickname || "invalid user: id = #{self.id}!"
  end
  
  def has_role?(role_name)
    raise 'invalid role: #{role_name}' unless ROLES.include? role_name.to_s
    (self.roles || '').include? "|#{role_name}|"
  end
  
  def role_list
    result = []
    ROLES.each do |role|
      result << role if !roles.nil? && roles.include?("|#{role}|")
    end
    result
  end
  
  def add_role(role)
    list = role_list
    unless list.include? role
      list << role
      self.roles = "|" + list.join('|') + "|"
    end
  end
  
  def remove_role(role)
    list = role_list
    list.delete role
    self.roles = "|#{list.join('|')}|"
  end
  
  def has_remote_id?
    not self.remote_id.nil?
  end
  
  def current_dependents
    result = [Subapp, Launch].reduce(0) do |memo, model|
      count = model.count :conditions => {:person_id => self.id}
      logger.debug "#{model} has #{count} dependent(s)" if count > 0
      memo + count
    end
  end
  
  def before_destroy
    raise 'Cannot destroy a person with existing dependents' if current_dependents   > 0
  end
end
