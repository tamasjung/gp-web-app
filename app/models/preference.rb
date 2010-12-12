class Preference < ActiveRecord::Base
  
  belongs_to :person
  
  def self.find_mine(user)
    result = self.find_by_person_id(user.id)
    unless result
      result = self.new
      result.person_id = user.id
      result.store({})
    end
    result
  end
  
  def store(prefs_struct)
    self.prefs = prefs_struct.to_yaml
    save!
  end
  
  def load
    result = YAML.load(prefs||'null')
    unless result
      self.pref = {}
      save!
    end
    result
  end
  
  def save_last_launch_search(str)
    data = load
    data[:last_launch_search] = str
    store data
  end
  
  def get_last_launch_search
    load[:last_launch_search]
  end
  
end
