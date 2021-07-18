class Api::OrdersController < ApplicationController
  include CurrentUserConcern
  include Rails::Pagination

  # GET /orders
  def index
    sales = SaleQuery.new(policy_scope(Sale)).relation.search_with_params(search_params, @current_user).order(created_at: :desc)
    paginate json: sales, per_page: params[:per_page], each_serializer: SaleSerializer
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @sale = Sale.find(params[:id])
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
