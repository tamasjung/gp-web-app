require 'test_helper'

class HashAcessorTest < ActiveSupport::TestCase
  
  
  
  test "one accessor" do 
    assert HashAccessor.new({:a => 11}).a == 11
  end
  
  test "empty accessor" do
    
    assert HashAccessor.new({}).instance_variables.size == 0
  end

end