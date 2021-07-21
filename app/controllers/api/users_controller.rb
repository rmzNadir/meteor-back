class Api::UsersController < ApplicationController
  include CurrentUserConcern
  include Rails::Pagination
  before_action :set_user, only: %i[show update destroy]

  # GET /usersr
  def index
    @users = UserQuery.new(policy_scope(User)).relation.search_with_params(search_params).order(created_at: :desc)
    paginate json: @users, per_page: params[:per_page], each_serializer: UserSerializer
  end

  # GET /users/1
  def show
    render json: {
      success: true,
      msg: 'User found',
      user: UserSerializer.new(@user)
    }
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)

      render json: {
        success: true,
        msg: 'User successfully updated',
        user: UserSerializer.new(@user)
      }
    else
      render json: {
        success: false,
        msg: 'Something went wrong',
        errors: @user.errors
      }
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    render json: {
      success: true,
      msg: 'User successfully destroyed',
    }
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      msg: 'User not found',
    }
  end

  def user_params
    # Yeah... had to do this cuz rails wont recognize js null as nil
    if params[:image] == 'DELETE'
      return params.permit(:email, :name, :last_name, :role, :password).with_defaults(image: nil)
    end

    params.permit(:email, :name, :last_name, :role, :image, :password)
  end

  def search_params
    params.permit(
      :q
    )
  end
end
