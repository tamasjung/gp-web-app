class ClearLaunchAndJobTable < ActiveRecord::Migration
  def self.up
    Job.delete_all
    Launch.delete_all
  end

  def self.down
  end
end
