class LinksController < ApplicationController
  def create
    destination_url = normalized_url_parameter

    link = Link.find_or_initialize_by(url: destination_url)

    if link.save
      render json: { url: link_url(link) }
    else
      render_error_message(link.errors.full_messages)
    end
  end

  def show
    original_url = Rails.cache.fetch(params_url_key, expires_in: 2.days) do
      Link.find_by!(unique_key: params_url_key).url
    end

    ClickCounter.perform_later(params_url_key)

    redirect_to CGI.unescape(original_url), allow_other_host: true
  end

  def stats
    shortened_url = Link.find_by!(unique_key: params_url_key)

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
