class AddParentIdToLaunch < ActiveRecord::Migration
  def self.up
    add_column :launches, :parent_id, :integer
  end

  def self.down
    remove_column :launches, :parent_id
  end
end
