#!/usr/bin/env ruby

require 'sequence_resolver'

args = ARGV.clone
executable = args.shift

outputs = []

system('gcc -Wall -ansi -pedantic 3D_r3bp_lce_3.c -o 3D_r3bp_lce_3 -lm')

system('chmod +x 3D_r3bp_lce_3')

iterate_parallel args do |values, args|
  parametric_args = args.join(' ')
  p "parametric arguments: #{parametric_args}"
  command_args = substitute_seq_values(parametric_args, values)
  output_file = nil
  reg_exp_match = /-o\S+\s+(\S+)/.match(command_args)
  if reg_exp_match
    output_file = reg_exp_match[1]
  else
    p "invalid command args: #{args}, values: #{values} exiting"
    exit 1
  end
  outputs << output_file
  command_line = './' + executable + " " + command_args
  p "Executing the following:"
  p command_line
  system(command_line)
end


system('tar cf outputs.tar ' + outputs.join)