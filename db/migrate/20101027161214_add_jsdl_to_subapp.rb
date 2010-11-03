class AddJsdlToSubapp < ActiveRecord::Migration
  def self.up
    add_column :subapps, :jsdl, :text
  end

  def self.down
    remove_column :subapps, :jsdl
  end
end
