class AddStateToSubapp < ActiveRecord::Migration
  def self.up
    add_column :subapps, :state, :string
  end

  def self.down
    remove_column :subapps, :state
  end
end
