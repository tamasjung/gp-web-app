#!/usr/bin/env ruby

STDERR.write "this is only a dummy run"
[
  ["pid", Process.pid],
  ["command_args", ARGV.join(', ')]
].each do |row|
  p row.join(': ')
end
p 'sleep begins'
sleep 100
p 'sleep ends'


