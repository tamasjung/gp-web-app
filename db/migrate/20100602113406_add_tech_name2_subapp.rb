class AddTechName2Subapp < ActiveRecord::Migration
  def self.up
    add_column :subapps, :tech_name, :string
  end

  def self.down
    remove_column :subapps, :tech_name
  end
end
