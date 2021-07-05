class SessionsController < ApplicationController
  include CurrentUserConcern
  skip_before_action :set_current_user, only: [:create]

  def create
    user = User.find_by(email: params[:email]).try(:authenticate, params[:password])

    if user
      session[:user_id] = user.id

      render json: {
        success: true,
        msg: 'User successfully logged in',
        user: UserSerializer.new(user)
      }
    else
      render json: { success: false, msg: 'Check your credentials' }
    end
  end

  def logged_in
    if @current_user
      render json: {
        success: true,
        msg: 'User is authenticated',
        user: UserSerializer.new(@current_user)
      }
    else
      render json: { success: false, msg: 'User is not authenticated' }
    end
  end

  def logout
    reset_session

    render json: {
      success: true,
      msg: 'User successfully logged out',
    }
  end
end
