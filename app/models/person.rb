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
  
  

  
  attr_protected :password, :roles, :remote_id
  attr_readonly :login
  has_many :subapps
  has_many :launches
  has_one :preference
  validates_uniqueness_of :remote_id, :allow_nil => true
  
  def display_name
    self.nickname || self.login || self.remote_id
  end
  
  def has_role?(role_name)
    (self.roles || '').include? "|#{role_name}|"
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
