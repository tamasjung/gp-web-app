class Rename2nickname < ActiveRecord::Migration
  def self.up
    rename_column :people, :nick, :nickname
  end

  def self.down
    rename_column :people, :nickname, :nick
  end
end
