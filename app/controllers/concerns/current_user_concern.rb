module CurrentUserConcern
  include Pundit
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  def pundit_user
    @current_user
  end

  def set_current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
      if @current_user.nil?
        render json: { unauthorized: true, success: false, msg: "Can't identify current user" }
      end

      @current_user
    else
      render json: { unauthorized: true, success: false, msg: "User isn't logged in" }
    end
  end
end
