class CreateSubapps < ActiveRecord::Migration
  def self.up
    create_table :subapps do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :subapps
  end
end
