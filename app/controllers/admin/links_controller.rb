module Admin
  class LinksController < ApplicationController
    before_action :authenticate_user!
    respond_to :json

    def index
      links = user_links

      render json: links
    end

    def create
      destination_url = normalized_url_parameter

      link = user_links.find_or_initialize_by(url: destination_url)

      if link.save
        render json: link
      else
        render_error_message(link.errors.full_messages)
      end
    end

    def show
      link = user_links.find_by!(unique_key: params_url_key)

      render json: { url_key: params_url_key, count: link.use_count.to_s }
    end

    def destroy
      link = user_links.find_by!(unique_key: params_url_key)
      link.destroy
      render json: link
    end

    private

    def user_links
      current_user.links
    end

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
end
