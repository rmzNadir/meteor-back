class Api::UsersController < ApplicationController
  include CurrentUserConcern
  include Rails::Pagination
  before_action :set_user, only: %i[show update destroy]
  before_action :not_default_user, only: [:update]

  # GET /users
  def index
    users = UserQuery.new(policy_scope(User)).relation.search_with_params(search_params).order(created_at: :desc)

    if params[:download].present? && params[:download] == "true"
      report = XlsxExport::Users.new(users).call
      send_data report.to_stream.read, filename: "Reporte-usuarios-#{Time.zone.today}.xlsx"
    else
      paginate json: users, per_page: params[:per_page], each_serializer: UserSerializer
    end
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
    can_update = true
    is_password_update = params[:current_password].present?

    if is_password_update
      can_update = @user.authenticate(params[:current_password])
    end

    if can_update && @user.update(user_params)
      render json: {
        success: true,
        msg: 'User successfully updated',
        user: UserSerializer.new(@user),
        password_updated: is_password_update && can_update
      }
    elsif !can_update
      render json: {
        success: false,
        msg: 'Something went wrong',
        errors: { base: [I18n.t('activerecord.errors.models.user.attributes.password.wrong')] },
        password_updated: false
      }
    else
      render json: {
        success: false,
        msg: 'Something went wrong',
        errors: @user.errors,
        password_updated: false
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

  def not_default_user
    return unless ['normal@user.com', 'manager@user.com', 'admin@user.com'].include? params[:email]

    render json: {
      success: false,
      msg: 'Something went wrong',
      errors: { base: [I18n.t('activerecord.errors.models.user.default')] },
      password_updated: false
    }
  end

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
