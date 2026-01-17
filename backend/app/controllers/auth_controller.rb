class AuthController < ApplicationController
  skip_before_action :authorize_request, only: %i[login signup]

  def login
    @user = User.find_by_email(auth_params[:email])
    if @user&.authenticate(auth_params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token, user: @user.as_json(except: :password_digest) }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def signup
    @user = User.new(user_params)
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token, user: @user.as_json(except: :password_digest) }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end

