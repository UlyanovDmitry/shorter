sidekiq_redis_config = YAML.safe_load(ERB.new(File.read('config/redis-sidekiq.yml')).result, aliases: true)
  .with_indifferent_access
  .fetch(Rails.env, {})

Sidekiq.configure_server do |config|
  config.redis = sidekiq_redis_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_redis_config
end
