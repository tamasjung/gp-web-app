class FillOutPersonIdOfSubapp < ActiveRecord::Migration
  def self.up
    person = (Person.find_by_login 'tamas') || Person.first 
    Subapp.update_all ("person_id = #{person.id}")
  end

  def self.down
    Subapp.update_all ("person_id = NULL")
  end
end
