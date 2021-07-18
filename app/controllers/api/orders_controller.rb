class Api::OrdersController < ApplicationController
  include CurrentUserConcern
  include Rails::Pagination
  before_action :set_order, only: [:show]

  # GET /orders
  def index
    orders = SaleQuery.new(policy_scope(Sale)).relation.search_with_params(search_params, @current_user).order(created_at: :desc)
    paginate json: orders, per_page: params[:per_page], each_serializer: SaleSerializer
  end

  # GET /orders/1
  def show
    render json: {
      success: true,
      msg: 'Order found',
      order: SaleSerializer.new(@order)
    }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Sale.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      msg: 'Order not found',
    }
  end

  def search_params
    params.permit(
      :q
    )
  end
end
