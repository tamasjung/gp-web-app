class MorePeopleFieldAreOptional < ActiveRecord::Migration
  def self.up
    change_column :people, :email, :string, :default => nil, :null => true
  end

  def self.down
    change_column :people, :password_salt, :string, :default => nil, :null => false
  end
end
