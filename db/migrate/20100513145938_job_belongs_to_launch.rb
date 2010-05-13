class JobBelongsToLaunch < ActiveRecord::Migration
  def self.up
    add_column :jobs, :launch_id, :integer
  end

  def self.down
    remove_column :jobs, :launch_id
  end
end
