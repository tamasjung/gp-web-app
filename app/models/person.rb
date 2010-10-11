class Person < ActiveRecord::Base
  acts_as_authentic do |conf|
    conf.session_class = UserSession
  end
  has_and_belongs_to_many :subapps
  has_and_belongs_to_many :launches
  has_one :preference
  
  def display_name
    self.nick
  end
  
  def has_role?(role_name)
    (self.roles || '').include? "|#{role_name}|"
  end
end
