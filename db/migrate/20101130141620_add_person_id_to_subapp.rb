class AddPersonIdToSubapp < ActiveRecord::Migration
  def self.up
    add_column :subapps, :person_id, :integer
  end

  def self.down
    remove_column :subapps, :person_id
  end
end
