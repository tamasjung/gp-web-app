class AddParentIdToSubapp < ActiveRecord::Migration
  def self.up
    add_column :subapps, :parent_id, :integer
  end

  def self.down
    remove_column :subapps, :parent_id
  end
end
