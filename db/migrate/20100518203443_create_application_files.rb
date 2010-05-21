class CreateApplicationFiles < ActiveRecord::Migration
  def self.up
    create_table :application_files do |t|
      t.string :name
      t.boolean :is_executable
      t.binary :bytes

      t.timestamps
    end
  end

  def self.down
    drop_table :application_files
  end
end
