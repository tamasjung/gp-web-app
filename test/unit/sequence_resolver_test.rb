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
    argv = "%qqq AaAaA %(e) ---seq qqq 1 10 1 BbBbB ---seq yyy 2 4 2 %(fixed 5 10 yyy) CcCcC ---seqval e 11 ---seqval u 3".split(' ')
    iterate_parallel(argv) do |values, args|
      results << substitute_seq_values(args.join(' '), values)
    end
    p results
    assert results.include? "7.0 AaAaA 11 BbBbB 00004.0000000000 CcCcC"
  end
  
  def teeeeest_invalid_args#exists the main thread as well
    results = []
    argv = "3D_r3bp_lce_3  -mu 0.001 -Navg 50 -eps 10e-10 -Tmax 1000 -ac -xi [1,0,0,0,0,0] -P1 [1,0,0,0] -P2 [%(a),0,0,0,0,0] -oI output_a_%(fixed 4 14 a).out ---seq  7.0 0.0 1.0".split(' ')
    iterate_parallel(argv) do |values, args|
      results << substitute_seq_values(args.join(' '), values)
    end
    p results
    assert results.size == 0
  end
    
end