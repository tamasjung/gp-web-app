class AddRemoteStateToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :remote_state, :string
  end

  def self.down
    remove_column :jobs, :remote_state
  end
end
