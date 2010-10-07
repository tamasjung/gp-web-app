class Preference < ActiveRecord::Base
  
  belongs_to :person
  
  def store(prefs_struct)
    prefs = prefs_struct.to_yaml
  end
  
  def load
    YAML.load prefs
  end
  
end
