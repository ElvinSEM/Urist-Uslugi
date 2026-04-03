class Api::V1::AuthController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: :create

  def create
    user = User.find_for_database_authentication(email: params[:email])

    if user&.valid_password?(params[:password])
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: { token: token, user: Api::V1::UserSerializer.call(user) }
    else
      render json: { error: "invalid_credentials" }, status: :unauthorized
    end
  end

  def destroy
    head :no_content
  end
end
