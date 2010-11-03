class AddVersionToApplicationFiles < ActiveRecord::Migration
  def self.up
    add_column :application_files, :version, :string
  end

  def self.down
    remove_column :application_files, :version
  end
end
