module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    private

    def respond_with(current_user, _opts = {})
      render json: {
        status: {
          code: 200, message: 'Logged in successfully.',
          data: { user: UserSerializer.new(current_user).as_json }
        }
      }, status: :ok
    end

    def respond_to_on_destroy
      current_user = current_user_by_jwt_payload if request.headers['Authorization'].present?

      if current_user
        render json: { status: 200, message: 'Logged out successfully.' }, status: :ok
      else
        render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
      end
    end

    def current_user_by_jwt_payload
      jwt_payload = JWT.decode(
        request.headers['Authorization'].split.last,
        Rails.application.credentials.devise_jwt_secret_key!
      ).first
      User.find(jwt_payload['sub'])
    end
  end
end
