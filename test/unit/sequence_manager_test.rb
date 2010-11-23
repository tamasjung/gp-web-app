#require 'test_helper'

require 'test/unit'
require 'config/environment'
require 'active_support/test_case'


class SequenceManagerTest < ::Test::Unit::TestCase
  
  extend ActiveSupport::Testing::Declarative
  
  def collect(seq_hashes, limit)
    result = []
    seqs = seq_hashes.map do |h|
      Sequence.new h
    end
    manager = SequenceManager.new(limit)
    manager.iterate_locally(seqs) do |seqdefs|
      result << seqdefs
    end
    result
  end
  
  def search(seq_arrays, limit)
    
    seqs = seq_arrays.map do |arr|
      Sequence.new :start => arr[0], :max => arr[1], :diff => arr[2]
    end.sort.reverse
    manager = SequenceManager.new(limit)
    result = manager.search_biggest_smaller_prod(seqs, limit)
    result
  end
  
  test "the smallest sequence size 1" do
    seq = Sequence.new :start=>0.5, :max => 0.5, :diff => 1
    assert_equal 1, seq.size
  end
  
  test "sequence size 1" do
    seq = Sequence.new :start=>0.5, :max => 1, :diff => 1
    assert_equal 1, seq.size
  end
  
  test "one simple seq" do
    seqdefs = collect([{:name => 'a', :start => 0.5, :max => 10, :diff => 1}], 11)
    assert_equal 10, seqdefs.size
  end

  test "one simple seq with strings" do
    seqdefs = collect([{:name => 'a', :start => '0.5', :max => '10', :diff => '1'}], 11)
    assert_equal 10, seqdefs.size
  end


  test "one simple big seq" do
    seqdefs = collect([{:name => 'a', :start => 0.5, :max => 10, :diff => 1}], 5)
    p seqdefs
    assert_equal 5, seqdefs.size
  end

  
  test "empty array" do
    seqdefs = collect([], 100)
    assert_equal [[]], seqdefs
    assert_equal 1, seqdefs.size
    assert_equal 0, seqdefs[0].size
  end
  
  test "the biggest is better" do
    seqdefs = collect([
      {:name => 'a', :start => 0.5, :max => 10, :diff => 1},
      {:name => 'b', :start => 10.5, :max => 20, :diff => 1},
      {:name => 'biggest', :start => 0.5, :max => 200, :diff => 1}
    ], 100)
    assert_equal 100, seqdefs.size
  end
  
  test "the biggest is not better" do
    seqdefs = collect([
      {:name => 'a', :start => 0.5, :max => 10, :diff => 1},
      {:name => 'b', :start => 10.5, :max => 20, :diff => 1},
      {:name => 'biggest', :start => 0.5, :max => 99, :diff => 1}
    ], 100)
    
    assert_equal 100, seqdefs.size  
  end
  
  test "small collect check" do
    seqdefs = collect([
      {:name => 'a', :start => 0.5, :max => 2, :diff => 1},
      {:name => 'b', :start => 3.5, :max => 5, :diff => 1}
    ], 100)
    expected_line = "---seqval a 0.5 ---seqval b 3.5|---seqval a 0.5 ---seqval b 4.5|---seqval a 1.5 ---seqval b 3.5|---seqval a 1.5 ---seqval b 4.5"
    actual_line = seqdefs.map{|seqs| seqs.map{|seq| seq.to_arg}.join(' ')}.join('|')
    assert_equal 4, seqdefs.size
    assert_equal expected_line, actual_line
  end  
  
  test "big collect check" do
    seqdefs = collect([
      {:name => 'small', :start => 0.5, :max => 2, :diff => 1},
      {:name => 'big', :start => 1000.5, :max => 1003, :diff => 1}
    ], 3)
    expected_line = "---seq small 0.5 2.0 1.0 ---seqval big 1000.5|---seq small 0.5 2.0 1.0 ---seqval big 1001.5|---seq small 0.5 2.0 1.0 ---seqval big 1002.5"
    actual_line = seqdefs.map{|seqs| seqs.map{|seq| seq.to_arg}.join(' ')}.join('|')
    assert_equal 3, seqdefs.size
    assert_equal expected_line, actual_line  
  end  
  
  test "base search" do
    result, prod = search [[0,10.5, 1], [0, 100.5, 1]], 20
    assert result.size == 1
    assert result[0].max = 10.5
  end
  
  test "search handles empty array, zero limit" do
    result, prod = (search [], 0) + (search [], 10)
    assert_equal 0, result.size
  end
  
  test "search two small" do
    result, prod = search [
      [0.5, 10, 1],
      [0.5, 10, 1],
      [0.5, 99, 1]
      ], 100
    assert_equal 2, result.size
    assert result[0].max == result[1].max
  end
  
  test "search one big" do
    result, prod = search [
      [0.5, 10, 1],
      [0.5, 10, 1],
      [0.5, 100, 1]
      ], 100
    
    assert_equal 1, result.size
    assert result[0].max == 100
  end
  
  test "max was missing is fixed" do
    seqdefs = collect([
      {:name => 'a', :start => 1, :max => 11.5, :diff => 1}
    ], 5)
    expected_line = "---seq a 1.0 3.5 1.0|---seq a 4.0 6.5 1.0|---seq a 7.0 9.5 1.0"
    actual_line = seqdefs.map{|seqs| seqs.map{|seq| seq.to_arg}.join(' ')}.join('|')
    assert_equal 3, seqdefs.size
    assert_equal expected_line, actual_line
  end
  
end