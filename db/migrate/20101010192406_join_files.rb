class JoinFiles < ActiveRecord::Migration
  def self.up
    create_table :application_files_subapps, :id => false do |t| 
      t.integer :applications_file_id, :null => false 
      t.integer :subapp_id, :null => false
    end
    
    create_table :input_files_launches, :id => false do |t| 
      t.integer :input_file_id, :null => false 
      t.integer :launch_id, :null => false
    end
  end

  def self.down
    drop_table :application_files_subapps
    drop_table :input_files_launches
  end
end
