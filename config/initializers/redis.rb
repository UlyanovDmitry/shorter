pool_size = 100
redis_url = Rails.application.credentials.dig(:redis, :url)

REDIS_CONN_POOL = ConnectionPool.new(size: pool_size) do
  Redis.new(url: redis_url)
end
