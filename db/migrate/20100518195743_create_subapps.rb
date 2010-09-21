class CreateSubapps < ActiveRecord::Migration
  def self.up
    drop_table :subapps
    create_table :subapps do |t|
      t.string :name
      t.text :input_partial
      t.text :settings
      t.text :executable

      t.timestamps
    end
  end

  def self.down
    drop_table :subapps
    create_table :subapps
  end
end
