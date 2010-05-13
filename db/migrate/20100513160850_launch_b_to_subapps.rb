class LaunchBToSubapps < ActiveRecord::Migration
  def self.up
    add_column :launches, :subapp_id, :integer
  end

  def self.down
    remove_column :launches, :subapp_id
  end
end
