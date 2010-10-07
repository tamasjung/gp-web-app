class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.integer :person_id
      t.string :prefs

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
