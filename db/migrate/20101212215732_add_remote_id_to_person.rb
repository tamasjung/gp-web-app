class AddRemoteIdToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :remote_id, :string
    add_index :people, :remote_id
  end

  def self.down
    remove_column :people, :remote_id
  end
end
