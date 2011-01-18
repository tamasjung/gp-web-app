require 'test/unit' 
require 'lib/filter_parser' 

class TestFilterParser < Test::Unit::TestCase
  
  #TODO loads of tests because of the security danger
  
  def target
    @parser = FilterParser.new :foo_table, [:name, :state]
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
    parser = FilterParser.new :foo_table, [:name], :user => 'people.nickname'
    result = parser.parse str
  
    assert_equal "people.nickname like :p0", result[:conditions][0]
    assert_equal "person", result[:include][0]
    
  end
  
  def test_subs2
    
    str = "user like me"
    parser = FilterParser.new :person, [:name], :user => 'people.nickname'
    result = parser.parse str
  
    assert_equal "people.nickname like :p0", result[:conditions][0]
    assert_equal 0, result[:include].size
    
  end
  
  def test_bug
    str = "created_at = 2010-10-05 13:45:52 and creator like fire"
    parser = FilterParser.new(:launch, [:name, :state], {:creator => 'people.nickname', :created_at => 'launches.created_at'})
    result = parser.parse str
  
    assert_equal "launches.created_at = :p0 and people.nickname like :p1", result[:conditions][0]
    assert_equal 1, result[:include].size
  end
  
  def test_empty
    str = ""
    parser = FilterParser.new(:launch, [:name, :state], {:creator => 'people.nickname', :created_at => 'launches.created_at'})
    result = parser.parse str
  
    assert_equal "", result[:conditions][0]
    assert_equal 0, result[:include].size
  end
  
end