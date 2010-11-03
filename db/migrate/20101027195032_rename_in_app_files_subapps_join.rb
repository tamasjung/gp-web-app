class RenameInAppFilesSubappsJoin < ActiveRecord::Migration
  def self.up
    rename_column(:application_files_subapps, :applications_file_id, :application_file_id)
  end

  def self.down
    rename_column(:application_files_subapps, :application_file_id, :applications_file_id)
  end
end
