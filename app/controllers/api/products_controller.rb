class Api::ProductsController < ApplicationController
  include CurrentUserConcern
  include Rails::Pagination
  before_action :set_product, only: %i[show update destroy]
  # before_action :check_params, only: [:create, :update]

  # GET /products
  def index
    products = ProductQuery.new.relation.search_with_params(search_params).order(created_at: :desc)

    if params[:download].present? && params[:download] == "true"
      report = XlsxExport::Products.new(products).call
      send_data report.to_stream.read, filename: "Reporte-productos-#{Time.zone.today}.xlsx"
    else
      paginate json: products, per_page: params[:per_page], each_serializer: ProductSerializer
    end
  end

  # GET /products/1
  def show
    render json: {
      success: true,
      msg: 'Product found',
      product: ProductSerializer.new(@product)
    }
  end

  # POST /products
  def create
    @product = Product.new(product_params)
    # @product.languages = params[:languages].split(',')
    # @product.platforms = params[:platforms].split(',')

    if @product.save
      ProductsServices::Relations.new(@product, params).call
      render json: {
        success: true,
        msg: 'Product successfully saved',
        product: ProductSerializer.new(@product)
      }
    else
      render json: {
        success: false,
        msg: 'Something went wrong',
        errors: @product.errors
      }
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      ProductsServices::Relations.new(@product, params).call(create: false)
      # Product.update_languages(@product, params[:languages].split(','))
      # Product.update_platforms(@product, params[:platforms].split(','))

      render json: {
        success: true,
        msg: 'Product successfully updated',
        product: ProductSerializer.new(@product)
      }
    else
      render json: {
        success: false,
        msg: 'Something went wrong',
        errors: @product.errors
      }
    end
  end

  # DELETE /products/1
  def destroy
    product_status = @product[:disabled]
    if @product.update(disabled: !product_status)
      render json: {
        success: true,
        msg: 'Product successfully disabled',
        product: ProductSerializer.new(@product)
      }
    else
      render json: {
        success: false,
        msg: 'Something went wrong',
        errors: @product.errors
      }
    end
  end

  def cards
    render json: {
      success: true,
      msg: 'Cards info',
      cards: ProductsServices::Dashboard.new.call
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

  def check_params
    render json: { success: false, msg: 'Missing languages/platforms' } unless params[:languages].present? && params[:platforms].present?
  end

  def product_params
    params.permit(:name, :price, :description, :stock, :provider, :has_free_shipping, :shipping_cost, :last_bought_at, :image)
  end

  def search_params
    params.permit(
      :q
    )
  end
end
