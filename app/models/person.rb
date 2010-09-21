class Person < ActiveRecord::Base
  has_and_belongs_to_many :subapps
  has_and_belongs_to_many :launches
  
  def display_name
    self.nick
  end
  
  def has_role?(role_name)
    (self.roles || '').include? "|#{role_name}|"
  end
end
