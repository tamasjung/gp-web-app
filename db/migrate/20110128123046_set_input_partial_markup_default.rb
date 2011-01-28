class SetInputPartialMarkupDefault < ActiveRecord::Migration
  def self.up
    Subapp.update_all("input_partial_markup = 'haml'")
  end

  def self.down
  end
end
