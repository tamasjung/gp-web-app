class AddInputPartialMarkupToSubapps < ActiveRecord::Migration
  def self.up
    add_column :subapps, :input_partial_markup, :string
  end

  def self.down
    remove_column :subapps, :input_partial_markup
  end
end
