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

env 'PATH', ENV['PATH']

job_type :crawler, 'cd /home/ec2-user/node_apps/solars/current/crawler && /usr/bin/env bundle exec ruby :task :output'

every 10.minutes do
  set :output, -> { "> /var/log/solars.log 2>&1" } # TODO: log rotation
  crawler "app/solar_parse.rb"
end

every :day, at: "0:25 am"  do
  set :output, -> { "> /var/log/solars-dump.log 2>&1" } # TODO: log rotation
  command "/bin/sh /root/bin/mongodbbackup.sh"
end
