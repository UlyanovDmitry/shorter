class LinksController < ApplicationController
  respond_to :json

  def show
    original_url = Rails.cache.fetch(params_url_key, expires_in: 2.days) do
      ActiveRecord::Base.connected_to(role: :reading) do
        Link.find_by!(unique_key: params_url_key).url
      end
    end

    ClickRedisImport.new(link_id: params_url_key, request:).call

    redirect_to CGI.unescape(original_url), allow_other_host: true
  end

  private

  def params_url_key
    @params_url_key ||= params.require(:unique_key)
  end
end
