class CreateInputFiles < ActiveRecord::Migration
  def self.up
    create_table :input_files do |t|
      t.string :name
      t.binary :bytes

      t.timestamps
    end
  end

  def self.down
    drop_table :input_files
  end
end
