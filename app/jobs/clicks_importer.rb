class ClicksImporter < ApplicationJob
  queue_as :default

  BATCH_SIZE = 1000

  def perform
    REDIS_CONN_POOL.with do |conn|
      move_data_from_redis(conn)
    end
  end

  private

  def move_data_from_redis(redis)
    click_batch = []
    while (click_data = item_first(redis))
      click_batch << JSON.parse(click_data)

      if click_batch.size >= BATCH_SIZE
        db_import(click_batch, redis)
        click_batch = []
      end
    end
    db_import(click_batch, redis) if click_batch.present?
  end

  def item_first(conn)
    conn.lpop(ClickRedisImport::REDIS_CLICKS_KEY)
  end

  def db_import(click_batch, redis)
    return if click_batch.empty?

    import_result = Click.import(click_batch.map { |click| Click.new(click) }, validate: false)
    return_failed_data(import_result.failed_instances.attributes, redis) if import_result.failed_instances.any?
  rescue StandardError
    return_failed_data(click_batch, redis)
    raise
  end

  def return_failed_data(click_batch, redis)
    click_batch.each do |click|
      redis.lpush(ClickRedisImport::REDIS_CLICKS_KEY, click.to_json)
    end
  end
end
