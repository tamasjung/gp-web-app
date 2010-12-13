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
  has_and_belongs_to_many :subapps
  has_and_belongs_to_many :launches
  has_one :preference
  
  def display_name
    self.nickname || self.login || self.remote_id
  end
  
  def has_role?(role_name)
    (self.roles || '').include? "|#{role_name}|"
  end
  
  def has_remote_id?
    not self.remote_id.nil?
  end
end
