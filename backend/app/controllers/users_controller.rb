class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users, only: [:id, :name, :email]
  end

  def me
    render json: current_user.as_json(only: [:id, :name, :email, :role])
  end

  def update_profile
    if current_user.update(user_params)
      render json: current_user.as_json(only: [:id, :name, :email, :role])
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :password, :password_confirmation, :avatar)
  end
end
