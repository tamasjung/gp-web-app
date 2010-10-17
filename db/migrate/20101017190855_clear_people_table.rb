class ClearPeopleTable < ActiveRecord::Migration
  def self.up
    Person.delete_all
  end

  def self.down
  end
end
