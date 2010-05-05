class CreateLaunches < ActiveRecord::Migration
  def self.up
    create_table :launches do |t|
      t.string :name
      t.text :settings
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :launches
  end
end
