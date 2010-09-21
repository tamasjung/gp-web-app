class AddRolesToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :roles, :string
  end

  def self.down
    remove_column :people, :roles
  end
end
