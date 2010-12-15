require 'test_helper'

class SubappTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "cannot destroy subapp" do
    assert_raise RuntimeError do
      Subapp.find(1).destroy
    end
    subapps(:two).destroy
    assert_nil Subapp.find_by_id 2
  end
end
