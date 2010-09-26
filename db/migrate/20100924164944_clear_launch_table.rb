class ClearLaunchTable < ActiveRecord::Migration
  def self.up
    Launch.delete_all
  end

  def self.down
  end
end
