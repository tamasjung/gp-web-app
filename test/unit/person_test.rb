require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "rem0te_id without password" do
    p = Person.new
    
    
    p.remote_id = 'asdf'
    p.save!
    assert true
  end
  
  test "destroy" do 
    assert_raise RuntimeError do
      Person.find(1).destroy
    end
    Person.find(2).destroy
  end
  
  test "add role" do
    p = Person.find(1)
    p.add_role 'admin'
    assert_equal "|admin|", p.roles
  end
  

    
end
