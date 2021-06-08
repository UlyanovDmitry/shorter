# frozen_string_literal: true

class ShortenedUrlShowCounter < ApplicationJob
  def perform(short_url)
    shortened_url = ShortenedUrl.find_by!(unique_key: short_url)

    shortened_url.increment_usage_count
  end
end
