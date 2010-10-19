class AddCommandLineToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :command_line, :string
  end

  def self.down
    remove_column :jobs, :command_line
  end
end
