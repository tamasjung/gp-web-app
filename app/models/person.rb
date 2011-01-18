class Person < ActiveRecord::Base
  acts_as_authentic do |conf|
    conf.session_class = UserSession
    [
      :merge_validates_length_of_email_field_options,
      :merge_validates_format_of_email_field_options,
      :merge_validates_format_of_login_field_options,
      :merge_validates_length_of_login_field_options,
      :merge_validates_length_of_password_field_options,
      :merge_validates_confirmation_of_password_field_options
      ].each do |meth|
      conf.send meth, {:unless => :has_remote_id?}
    end
  end
  
  ROLES = %w/researcher senior admin/

  
  attr_protected :remote_id
  attr_readonly :login, :remote_id
  has_many :subapps
  has_many :launches
  has_one :preference
  validates_uniqueness_of :remote_id, :allow_nil => true
  
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
    unless role_list.include? role
      self.roles = "|#{role_list.join('|')}|#{role}|"
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
    result = [Subapp, Launch, Preference].reduce(0) do |memo, model|
      count = model.count :conditions => {:person_id => self.id}
      logger.debug "#{model} has #{count} dependent(s)" if count > 0
      memo + count
    end
  end
  
  def before_destroy
    raise 'Cannot destroy a person with existing dependents' if current_dependents   > 0
  end
end
