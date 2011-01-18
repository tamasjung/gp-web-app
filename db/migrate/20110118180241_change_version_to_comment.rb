class ChangeVersionToComment < ActiveRecord::Migration
  def self.up
    rename_column :application_files, :version, :comment
  end

  def self.down
    rename_column :application_files, :comment, :version
  end
end
