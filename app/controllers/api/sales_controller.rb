class Api::SalesController < ApplicationController
  include CurrentUserConcern
  include Rails::Pagination
  before_action :set_sale, only: %i[show update destroy]
  before_action :check_params, only: [:create, :update]

  # GET /sales
  def index
    sales = Sale.all.order(created_at: :desc)
    paginate json: sales, per_page: params[:per_page], each_serializer: SaleSerializer
  end

  # GET /sales/1
  def show
    render json: {
      success: true,
      msg: 'Sale found',
      sale: SaleSerializer.new(@sale)
    }
  end

  # POST /sales
  def create
    @sale = Sale.new(sale_params)
    @sale.user_id = @current_user.id
    @sale.products = params[:products]

    if @sale.save && @sale.errors.empty?
      Sale.update_product_stock(@sale)

      UserNotifierMailer.send_sale_confirmation(@current_user, @sale).deliver

      render json: {
        success: true,
        msg: 'Sale successfully saved',
        sale: SaleSerializer.new(@sale)
      }
    else
      render json: {
        success: false,
        msg: 'Something went wrong',
        errors: @sale.errors
      }
    end
  end

  # PATCH/PUT /sales/1
  # TODO: FINISH
  def update
    if @sale.update(sale_params)
      Sale.update_products(@sale, params[:products])

      render json: {
        success: true,
        msg: 'Sale successfully updated',
        product: SaleSerializer.new(@sale)
      }
    else
      render json: {
        success: false,
        msg: 'Something went wrong',
        errors: @sale.errors
      }
    end
  end

  # DELETE /sales/1
  def destroy
    @sale.destroy
    render json: {
      success: true,
      msg: 'Sale successfully destroyed',
    }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = Sale.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      msg: 'Sale not found',
    }
  end

  def check_params
    render json: { success: false, msg: 'Missing products' } if params[:products].blank?
  end

  # Only allow a list of trusted parameters through.
  def sale_params
    params.permit(:total, :payment_method, :payment_info, :address)
  end
end
