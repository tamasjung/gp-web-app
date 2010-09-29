require 'test_helper'

class SequenceManagerTest < ActiveSupport::TestCase
  
  def divide_sequences(seqs, limit)
    
    manager = SequenceManager.new(limit)
    result = manager.divide(seqs)
    (result.selected_sequencies.reduce 0 do |memo, seq|
      memo + seq.size
    end)
    
  end
  
  test "one simple seq" do
    seq_size = divide_sequences([{:start => 0, :end => 10, :diff => 1}], 100)
    assert seq_size < 100
    assert seq_size == 10
  end
  
  test "empty array" do
    seq_size = divide_sequences([], 100)
    assert seq_size == 0
  end

end