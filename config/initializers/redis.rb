pool_size = 10
redis_url = Rails.application.credentials.dig(:redis, :url)

REDIS_CONN_POOL = if Rails.env.test?
  MockRedis.new
else
  ConnectionPool.new(size: pool_size) { Redis.new(url: redis_url) }
end
