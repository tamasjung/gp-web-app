#!/usr/bin/env ruby

require 'sequence_resolver'

args = ARGV.clone
executable = args.shift

outputs = []

iterate_parallel args do |values, args|
  parametric_args = args.join(' ')
  p "parametric arguments: #{parametric_args}"
  command_args = substitute_seq_values(parametric_args, values)
  output_reg_exp_match = /--output\s+(result\S*)/.match(command_args)
  input_reg_exp_match = /--input\s+(input\S*)/.match(command_args)
  
  if (!output_reg_exp_match.nil?) && (!input_reg_exp_match.nil?)
    
    output_file = output_reg_exp_match[1]
    input_file = input_reg_exp_match[1]
    
    #
    #lets make the actual input file
    #input.dat is only a template containing sequence variables
    #which needs to be substituted
    #
    
    input = File.read 'input.dat'
    
    actual_input = substitute_seq_values input, values
    
    File.open(input_file, "w") do |file|
      file.write actual_input
    end
    
    outputs << output_file
    command_line = './' + executable + " " + command_args
    p "Executing the following:"
    p command_line
    system(command_line)
  else
    p "invalid command args: #{args}, values: #{values} exiting"
    exit 1
  end
end


system('tar cf outputs.tar ' + outputs.join(' '))