#!/usr/bin/env ruby


#next function from http://blog.robseaman.com/2009/7/11/detecting-the-number-of-processors-with-ruby
def number_of_processors
  if RUBY_PLATFORM =~ /linux/
    return `cat /proc/cpuinfo | grep processor | wc -l`.to_i
  elsif RUBY_PLATFORM =~ /darwin/
    return `sysctl -n hw.logicalcpu`.to_i
  elsif RUBY_PLATFORM =~ /win32/
    # this works for windows 2000 or greater
    require 'win32ole'
    wmi = WIN32OLE.connect("winmgmts://")
    wmi.ExecQuery("select * from Win32_ComputerSystem").each do |system| 
      begin
        processors = system.NumberOfLogicalProcessors
      rescue
        processors = 0
      end
      return [system.NumberOfProcessors, processors].max
    end
  end
  raise "can't determine 'number_of_processors' for '#{RUBY_PLATFORM}'"
end

def parse_sequences(argv)
  sequences = []
  values = []
  args = []
  idx = 0
  loop do 
    break unless idx < argv.size 
    case argv[idx]
    when "---seq"
      if(argv.size > (idx + 4))
        sequences.push({:name => argv[idx + 1], :start => argv[idx + 2], :max => argv[idx + 3], :diff => argv[idx + 4]})
        idx += 5
      else
        raise "missing sequence attributes #{argv[idx..-1]}"
      end
    when "---seqval"
      if(argv.size > (idx + 2))
        values.push({:name => argv[idx + 1], :value => argv[idx + 2]})
        idx += 3
      else
        raise "missing sequence value attributes #{argv[idx..-1]}"
      end
    else
      args.push argv[idx]
      idx += 1
    end
  end
  [sequences, values, args]
end

def seq_size(hash)
  ((hash[:max].to_f - hash[:start].to_f)/hash[:diff].to_f).abs.floor + 1
end

def multi_iterator(seq_defs, seq_values, *args, &block)
  if(seq_defs.size > 0)
    next_seq = seq_defs[-1]
    new_seq_defs = seq_defs[0...-1]
    seq_size(next_seq).times do |i|
      value = {:name=>next_seq[:name], :value=>(next_seq[:start].to_f + i * next_seq[:diff].to_f)}
      new_seq_values = seq_values + [value]
      multi_iterator(new_seq_defs, new_seq_values, *args, &block)
    end
  else
    block.call seq_values, *args
  end
end

def iterate_sequencies(argv, &block)
  sequences, values, args = parse_sequences argv
  multi_iterator(sequences, values, args, &block)
end

require 'thread'
def iterate_parallel(argv, &block)
  cpu_num = number_of_processors rescue 1
  queue = SizedQueue.new cpu_num
  quit = Object.new
  number_of_threads = cpu_num
  Thread.new do
    iterate_sequencies(argv) do |*args|
      queue.push args
    end
    queue.max = queue.size + number_of_threads + 1
    number_of_threads.times do
      queue.push quit
    end
  end
  threads = (1..number_of_threads).map do 
    Thread.new do
      loop do
        next_args = queue.pop
        break if next_args == quit
        block.call *next_args
      end
    end
  end
  threads.each(&:join)
end

def fixed_format(int_width, dec, val)
  result = sprintf("%0*.#{dec}f", int_width.to_i + dec.to_i + 1, val)#the "+1" is for the dot
  result
end

def substitute_seq_values(str, values)
  values.each do |value|
    name = value[:name]
    val = value[:value]
    str.gsub! "$" + name, val.to_s
    str.gsub! "$(#{name})", val.to_s
    str.gsub! /\$\(fixed\s+(\d+)\s+(\d+)\s+#{name}\s*\)/ do 
      fixed_format($1, $2, val)
    end
  end
  str
end

if __FILE__ == $0
  p parse_sequences ARGV
  iterate_parallel(ARGV) do |values, args|
    p "---------"
    p values
    p substitute_seq_values(args.join(' '), values)
  end
end



    