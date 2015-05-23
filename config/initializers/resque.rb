
if ENV['REDISCLOUD_URL']
  Resque.redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
else
  Resque.redis = 'localhost:6379'
end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
