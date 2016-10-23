set :output, '/var/log/cron.log'
job_type :rbenv_rake, %Q{export PATH=/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && bundle exec rake :task --silent :output }

every 24.hours do
  rbenv_rake 'woo_api:load_spots'
end

every 5.minutes do
  rbenv_rake 'woo_api:load_new_sessions'
end
