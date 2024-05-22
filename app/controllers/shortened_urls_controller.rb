class ShortenedUrlsController < ApplicationController
  def create
    destination_url = normalized_url_parameter

    shorted_url = ShortenedUrl.find_or_initialize_by(url: destination_url)

    if shorted_url.save
      render json: { url: shortened_url_url(shorted_url) }
    else
      render_error_message(shorted_url.errors.full_messages)
    end
  end

  def show
    original_url = Rails.cache.fetch(params_url_key, expires_in: 2.days) do
      ShortenedUrl.find_by!(unique_key: params_url_key).url
    end

    ShortenedUrlShowCounter.perform_later(params_url_key)

    redirect_to CGI.unescape(original_url), allow_other_host: true
  end

  def stats
    shortened_url = ShortenedUrl.find_by!(unique_key: params_url_key)

    render json: { url_key: params_url_key, count: shortened_url.use_count.to_s }
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

  def params_url_key
    @params_url_key ||= params.require(:unique_key)
  end
end
