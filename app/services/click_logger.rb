class ClickLogger
  attr_reader :request, :link_id

  REDIS_CLICKS_KEY = 'clicks'.freeze
  REDIS_URL = Rails.application.credentials.dig(:redis, :url)

  def initialize(link_id:, request:)
    @link_id = link_id
    @request = request
  end

  def call
    REDIS_CONN_POOL.with do |conn|
      conn.rpush(REDIS_CLICKS_KEY, click_data.to_json)
    end
  end

  private

  def click_data
    {
      link_id:,
      ip: request.remote_ip,
      user_agent: request.user_agent,
      timestamp: Time.now.to_i
    }
  end
end
