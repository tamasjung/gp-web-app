require 'test/unit' 
require 'lib/script/sequence_resolver' 

class TestSequenceResolver < Test::Unit::TestCase
  
  def test_processor 
    assert_nothing_raised do
      number_of_processors
    end
  end 
  
  def test_fixed_format
    assert_equal "0001.23457", fixed_format(4, 5, 1.23456789)
    assert_equal "10000.00000", fixed_format(3, 5, 10000)
  end
  
  def test_command_line_subst
    results = []
    argv = "$qqq AaAaA $(e) ---seq qqq 1 10 1 BbBbB ---seq yyy 2 4 2 $(fixed 5 10 yyy) CcCcC ---seqval e 11 ---seqval u 3".split(' ')
    iterate_parallel(argv) do |values, args|
      results << substitute_seq_values(args.join(' '), values)
    end
    assert results.include? "7.0 AaAaA 11 BbBbB 00004.0000000000 CcCcC"
  end
end