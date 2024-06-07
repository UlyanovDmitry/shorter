class ClickCounter < ApplicationJob
  def perform(short_url)
    shortened_url = Link.find_by!(unique_key: short_url)

    shortened_url.increment_usage_count
  end
end
