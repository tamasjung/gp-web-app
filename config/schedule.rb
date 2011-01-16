# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
every :reboot do
  #command File.expand_path(File.dirname(__FILE__) + "/script/delayed_job start")
  #rake 'jobs:work'
  command "cd #{File.expand_path(File.dirname(__FILE__) + "..")}; export RAILS_ENV=production; script/delayed_job -n 10 start"
end

every 1.minute do 
  runner 'p "hello #{Time.new}"', :output => 'exp.out'
end