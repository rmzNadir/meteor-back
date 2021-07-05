class ProductsController < ApplicationController
  include CurrentUserConcern
  before_action :set_product, only: %i[show update destroy]

  # GET /products
  def index
    @products = Product.all
    render json: @products, each_serializer: ProductSerializer
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
    @product.languages = params[:languages] if params[:languages].present?
    @product.platforms = params[:platforms] if params[:platforms].present?

    if @product.save && @product.errors.empty?
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
    update_languages if params[:languages].present?
    update_platforms if params[:platforms].present?

    if @product.update(product_params)

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
    @product.destroy
    render json: {
      success: true,
      msg: 'Product successfully destroyed',
    }
  end

  def catalogue
    languages = Language.all
    platforms = Platform.all

    render json: {
      success: true,
      msg: 'Catalogues found',
      catalogues: {
        languages: LanguageSerializer.new(languages),
        platforms: PlatformSerializer.new(platforms)
      }
    }
  end

  private

  def set_product
    @product = Product.find(params[:id])

    return unless @product.nil?

    render json: {
      success: false,
      msg: 'Product not found',
    }
  end

  def product_params
    params.permit(:name, :price, :description, :stock, :provider, :has_free_shipping, :shipping_cost, :last_bought_at)
  end

  # This has to be here otherwise the product isn't updated when it gets sent to the frontend
  # Dogshit tier code, should refactor this into a service / Better solution for the many to many relationship

  def update_platforms
    old_platforms = ProductHasPlatform.where(product_id: @product.id).pluck(:platform_id)
    platforms_to_delete = old_platforms - params[:platforms]

    platforms_to_delete.each do |platform_id|
      ProductHasPlatform.find_by(platform_id: platform_id, product_id: @product.id).destroy
    end

    params[:platforms].each do |platform_id|
      ProductHasPlatform.find_or_create_by(platform_id: platform_id, product_id: @product.id)
    end
  end

  def update_languages
    old_langs = ProductHasLanguage.where(product_id: @product.id).pluck(:language_id)
    langs_to_delete = old_langs - params[:languages]

    langs_to_delete.each do |language_id|
      ProductHasLanguage.find_by(language_id: language_id, product_id: @product.id).destroy
    end

    params[:languages].each do |language_id|
      ProductHasLanguage.find_or_create_by(language_id: language_id, product_id: @product.id)
    end
  end
end
