class AddPersonIdToLaunch < ActiveRecord::Migration
  def self.up
    add_column :launches, :person_id, :integer
    drop_table :people_launches
    drop_table :people_subapps
  end

  def self.down
    remove_column :launches, :person_id
  end
end
