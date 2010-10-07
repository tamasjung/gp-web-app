require 'test/unit' 
require 'lib/filter_parser' 

class TestFilterParser < Test::Unit::TestCase
  
  #TODO loads of tests because of the security danger
  
  def target
    @parser = FilterParser.new [:name, :state]
  end
  
  def test_blab_bla
    str = "name = blab blab bla and state like blue blue bl"
    result = target.parse str
  
    assert_equal 'name = :p0 and state like :p1', result[:conditions][0]
    assert_equal 'blab blab bla', result[:conditions][1][:p0]
    assert_equal '%blue blue bl%', result[:conditions][1][:p1]
  end
  
  def test_subs
    
    str = "user like me"
    parser = FilterParser.new [:name], :user => 'people.nick'
    result = parser.parse str
  
    assert_equal "people.nick like :p0", result[:conditions][0]
    p result
    assert_equal "people", result[:include][0]
    
  end
end