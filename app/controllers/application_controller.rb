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
    render json: construct_error_body(message), status:
  end

  def construct_error_body(message)
    if message.is_a? Array
      { message:message.first.to_s, errors: message.map(&:to_s) }
    else
      { message: message.to_s }
    end
  end
end
