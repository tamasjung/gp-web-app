class SomePeopleFieldAreOptional < ActiveRecord::Migration
  def self.up
    #allow them to be null
    change_column :people, :login, :string, :default => nil, :null => true
    change_column :people, :crypted_password, :string, :default => nil, :null => true
    change_column :people, :password_salt, :string, :default => nil, :null => true
  end

  def self.down
    change_column :people, :login, :string, :default => nil, :null => false
    change_column :people, :crypted_password, :string, :default => nil, :null => false
    change_column :people, :password_salt, :string, :default => nil, :null => false

  end
end
