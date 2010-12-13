require 'test/unit' 
require 'lib/serial_name' 
require 'ostruct'

class SerialNameMock
  
  include SerialName
  attr_accessor :id
    
end
  

class TestSerialName < Test::Unit::TestCase  
  
  def target
    result = SerialNameMock.new
    result.id = 3
    result
  end
  
  def test_end_num
    obj = target
    result = obj.generate_unique_name 'asdf1-1'
    assert_equal 'asdf1-3', result
  end
  
  def test_no_end_num
    obj = target
    result = obj.generate_unique_name 'asdf'
    assert_equal 'asdf-3', result
  end
  
end