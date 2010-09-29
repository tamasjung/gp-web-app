require 'ostruct'

class Sequence < OpenStruct
  
  def size
    ((self.end - self.start)/self.diff).abs.floor
  end
  
  def <=>(other)
    self.size <=> other.size
  end
  
end
    

class SequenceManager
  
  def initialize(the_limit)
    @limit = the_limit
  end
  
  def iterate_locally(seqs)
    yield
  end
  
  def divide(seqs)
    
    #TBD a smarter algorithm?
    
    seqs_in_limit = seqs.map do |seq|
      Sequence.new seq
    end.select do |sequence|
      sequence.size <= @limit
    end.sort
    
    selected_seqs = []
    remaining_seqs = []
    index = 0
    production = 1
    while index < seqs_in_limit.size
      seq = seqs_in_limit[index]
      size = seq.size
      if(production * size < @limit)
        production *= size
        selected_seqs << seq
      else
        remaining_seqs << seq
      end
      index += 1
    end
    if(selected_seqs.size == 0)
      
    end
    return OpenStruct.new :selected_sequencies => selected_seqs, :remaining_sequencies => remaining_seqs
  end
  
end