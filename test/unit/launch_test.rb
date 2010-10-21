require 'test_helper'

class LaunchTest < ActiveSupport::TestCase
  
  
  
  # Replace this with your real tests.
  test "cloning without exception" do
    l = Launch.find 1
    l.clone
  end
end
