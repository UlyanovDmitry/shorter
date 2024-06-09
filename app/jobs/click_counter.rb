class ClickCounter < ApplicationJob
  def perform(short_url)
    Link.find_by!(unique_key: short_url).increment_usage_count
  end
end
