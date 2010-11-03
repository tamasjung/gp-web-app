class DropApplicationFiles < ActiveRecord::Migration
  def self.up
    drop_table :application_files
  end

  def self.down
  end
end
