class ShortenedUrlsController < ApplicationController
  def create
    destination_url = normalized_url_parameter

    shorted_url = ShortenedUrl.find_or_initialize_by(url: destination_url)

    if shorted_url.save
      render plain: shortened_url_url(shorted_url)
    else
      render_error_message(shorted_url.errors.full_messages)
    end
  end

  def show
    params_unique_key = params.require(:unique_key)

    full_url = Rails.cache.fetch(params_unique_key, expires_in: 2.days) do
      ShortenedUrl.find_by!(unique_key: params_unique_key).url
    end

    ShortenedUrlShowCounter.perform_later(params_unique_key)

    render plain: full_url
  end

  def stats
    shortened_url = ShortenedUrl.find_by!(unique_key: params.require(:unique_key))

    render plain: shortened_url.use_count.to_s
  end

  private

  def normalized_url_parameter
    normalize_url escape_url_parameter
  end

  def escape_url_parameter
    CGI.escape(params.require(:url).to_s)
  end

  def normalize_url(url)
    URI.parse(url.to_s).normalize.to_s
  end
end
