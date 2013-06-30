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

#set :output, "/path/to/my/cron_log.log"
job_type :rbenv_bundle_runner, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && bundle exec rails runner -e :environment ':task' :output"

set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}

every 20.minutes do
  rbenv_bundle_runner "Feed.pull_all", :environment => "development"
#  command "cd /Users/amacou/work/ror/rss_reader && /Users/amacou/.rbenv/shims/bundle exec rails runner -e development 'Feed.pull_all' >> log/cron.log 2>> log/error.log"
#  runner "Feed.pull_all", :environment => "development"
end
