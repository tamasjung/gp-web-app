require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "remite_id without password" do
    p = Person.new
    
    
    p.remote_id = 'asdf'
    p p.has_remote_id?
    p.save!
    assert true
  end
end
