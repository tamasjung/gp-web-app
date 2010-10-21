require 'test_helper'

class LaunchTest < ActiveSupport::TestCase
  
  # Replace this with your real tests.
  test "cloning without exception" do
    l = Launch.find 1
    l.clone
  end
  
  test "cloning without exception2" do
    l = Launch.find 2
    l.clone
  end
  
  test "settings launch_params is null" do 
    sa = SettingsAdapter.new '{launch_params: null}'
    sa.sequences
  end
  
end
