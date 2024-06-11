pool_size = 10
REDIS_URL = ENV.fetch('REDIS_URL') { 'redis://redis/0' }

REDIS_CONN_POOL = if Rails.env.test?
  MockRedis.new
else
  ConnectionPool.new(size: pool_size) { Redis.new(url: REDIS_URL) }
end
