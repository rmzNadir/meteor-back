class Api::RegistrationsController < ApplicationController
  def create
    user = User.create(permitted_params)

    if user.errors.empty?
      session[:user_id] = user.id
      render json: {
        success: true,
        msg: 'User successfully created',
        user: UserSerializer.new(user)
      }
    else
      render json: { success: false, msg: 'Something went wrong', errors: user.errors }
    end
  end

  private

  def permitted_params
    params.permit(:name, :last_name, :email, :password, :password_confirmation)
  end
end
