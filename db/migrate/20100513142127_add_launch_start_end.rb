class AddLaunchStartEnd < ActiveRecord::Migration
  def self.up
    add_column :launches, :start_time, :timestamp
    add_column :launches, :finish_time, :timestamp
  end

  def self.down
    remove_column :launches, :start_time
    remove_column :launches, :finish_time
  end
end
