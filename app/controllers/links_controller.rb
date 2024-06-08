class LinksController < ApplicationController
  respond_to :json

  def show
    original_url = Rails.cache.fetch(params_url_key, expires_in: 2.days) do
      Link.find_by!(unique_key: params_url_key).url
    end

    ClickCounter.perform_later(params_url_key)

    redirect_to CGI.unescape(original_url), allow_other_host: true
  end

  private

  def params_url_key
    @params_url_key ||= params.require(:unique_key)
  end
end
