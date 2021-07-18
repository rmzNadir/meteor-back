class Api::ListingsController < ApplicationController
  include Rails::Pagination
  before_action :set_product, only: [:show]

  # GET /listings
  def index
    @products = ProductQuery.new.relation.search_with_params(search_params).order(created_at: :desc)
    paginate json: @products, per_page: params[:per_page], each_serializer: ProductSerializer
  end

  # GET /listings/1
  def show
    render json: {
      success: true,
      msg: 'Product found',
      product: ProductSerializer.new(@product)
    }
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      msg: 'Product not found',
    }
  end

  def search_params
    params.permit(
      :q
    )
  end
end
