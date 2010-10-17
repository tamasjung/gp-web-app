class AddSingleToLaunch < ActiveRecord::Migration
  def self.up
    add_column :launches, :single, :boolean
  end

  def self.down
    remove_column :launches, :single
  end
end
