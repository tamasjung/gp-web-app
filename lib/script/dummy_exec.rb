#!/usr/bin/env ruby

STDERR.write "this is only a mock"
p ""
[
  ["pid", Process.pid],
  ["working dir", `pwd`],
  ["command_args", ARGV.join(' ')],
  ["files", `ls -Am`]
].each do |row|
  p row.join(': ')
end




