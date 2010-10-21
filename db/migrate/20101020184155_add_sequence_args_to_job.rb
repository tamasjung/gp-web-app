class AddSequenceArgsToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :sequence_args, :string
  end

  def self.down
    remove_column :jobs, :sequence_args
  end
end
