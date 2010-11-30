class FillOutStateOfSubapp < ActiveRecord::Migration
  def self.up
    Subapp.update_all ("state = '#{Subapp::PERMITTED}'")
  end

  def self.down
    Subapp.update_all ("state = NULL")
  end
end
