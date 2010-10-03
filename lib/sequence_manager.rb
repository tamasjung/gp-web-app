require 'ostruct'

class Sequence < HashAccessor
  
  def initialize(hash)
    super(hash)
    @max = @max.to_f
    @start = @start.to_f
    @diff = @diff.to_f
  end
  
  def size
    ((self.max - self.start)/self.diff).abs.floor + 1
  end
  
  def <=>(other)
    self.size <=> other.size
  end
  
  def to_arg
    "---seq #{name} #{start} #{max} #{diff}"
  end
  
end

class SequenceValue < HashAccessor
  def to_arg
    "---seqval #{name} #{value}"
  end
end

class SequenceManager
  
  def initialize(the_limit)
    @limit = the_limit
  end
 
  def struct_and_sort(seqs)
    seqs_in_limit = seqs.map do |seq|
      Sequence.new seq
    end.sort.reverse
  end
  
  def iterate_locally(unordered_seqs, &block)
    
    seqs = unordered_seqs.sort.reverse
    
    limited_seqs, limited_prod = search_biggest_smaller_prod seqs, @limit
    
    big_divider = false
    
    if(seqs.size > 0 && seqs[0].size > @limit)
      biggest_seq = seqs[0]
      proportion = biggest_seq.size/@limit.to_f
      subseq_length = proportion.ceil
      subseqs_size = (biggest_seq.size / subseq_length).ceil
      if(subseqs_size > limited_prod)#if the biggest is big enough we divide it instead
        big_divider = true
        remaining_seqs = seqs[1..-1]
        start = biggest_seq.start
        step = subseq_length * biggest_seq.diff
        (subseqs_size).times do |i|
          seq_start = start + i * step
          seq_max = seq_start + step - (biggest_seq.diff/2.0)
          seq_max = biggest_seq.max if((seq_max - biggest_seq.max)/biggest_seq.diff > 0)  
          subseq = Sequence.new :start => seq_start, :end => seq_max, :diff => biggest_seq.diff
          job_seq = remaining_seqs + [subseq]
          block.call job_seq
        end
      end
    end
    unless big_divider
      multi_iterator(limited_seqs, seqs - limited_seqs, &block)
    end
  end
  
  def multi_iterator(seq_defs, seq_values, &block)
    if(seq_defs.size > 0)
      next_seq = seq_defs[-1]
      new_seq_defs = seq_defs[0...-1]
      next_seq.size.times do |i|
        value = SequenceValue.new :name=>next_seq.name, :value=>(next_seq.start + i * next_seq.diff)
        new_seq_values = seq_values + [value]
        multi_iterator(new_seq_defs, new_seq_values, &block)
      end
    else
      block.call seq_values
    end
  end
  
  
  def search_biggest_smaller_prod(seqs, limit)
    array = []
    prod = 1
    seqs.each_with_index do |seq, idx|
      if(seq.size <= limit)
        part_limit = limit/seq.size
        part_array, part_prod = search_biggest_smaller_prod seqs[(idx+1)..-1], part_limit
        part_prod *= seq.size
        if(part_prod > prod)
          prod = part_prod
          array = [seq] + part_array
        end
      end
    end
    [array, prod]
  end
  
end