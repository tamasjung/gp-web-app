class AddRefreshingToLaunch < ActiveRecord::Migration
  def self.up
    add_column :launches, :refreshing, :boolean
  end

  def self.down
    remove_column :launches, :refreshing
  end
end
