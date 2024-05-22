class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_parameter_missing(exception)
    render_error_message(
      "Отсутствует обязательный параметр '#{exception.param}'",
      status: :bad_request
    )
  end

  def render_not_found(_exception)
    render_error_message "Couldn't find URL", status: :not_found
  end

  def render_error_message(message, status: :internal_server_error)
    render plain: message, status:
  end
end
