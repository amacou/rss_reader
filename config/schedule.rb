# env :PATH, ENV['PATH']
# env :GEM_PATH, ENV['GEM_PATH']
# env :rvm_prefix, ENV['rvm_prefix']
# env :rvm_path, ENV['rvm_path']
# env :rvm_bin_path, ENV['rvm_bin_path']
# env :rvm_version, ENV['rvm_version']
# env :MY_RUBY_HOME, ENV['MY_RUBY_HOME']
# env :GEM_HOME, ENV['GEM_HOME']
# env :RAILS_ENV, 'production'
# env :EXECJS_RUNTIME, 'Node'


# job_type :rbenv_bundle_runner, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && bundle exec rails runner -e :environment ':task' :output"
# job_type :rvm_bundle_runner, "source \"$HOME/.rvm/environments/ruby-2.1.1\" && cd :path && bundle exec rails runner -e :environment \":task\" :output"


# set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}

# every 10.minutes do
#  rbenv_bundle_runner "Feed.pull_all", :environment => "production"
#  rvm_bundle_runner "Feed.pull_all", :environment => "production"
# end
