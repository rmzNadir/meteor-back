class Api::CartsController < ApplicationController
  include CurrentUserConcern
  before_action :set_cart, only: %i[show update]

  # GET /carts/1
  def show
    render json: {
      success: true,
      msg: 'Cart found',
      cart_updated_at: @cart.updated_at,
      cart_items: ActiveModel::Serializer::CollectionSerializer.new(@cart.cart_items, each_serializer: CartItemSerializer)
    }
  end

  # PATCH/PUT /carts/1

  def update
    if CartsServices::Relations.new(@cart, cart_params).call(create: false)
      render json: {
        success: true,
        msg: 'Cart successfully updated',
        cart_updated_at: @cart.updated_at,
        cart_items: ActiveModel::Serializer::CollectionSerializer.new(@cart.cart_items, each_serializer: CartItemSerializer)
      }
    else
      render json: {
        success: false,
        msg: 'Something went wrong',
        errors: @cart.errors
      }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = Cart.find_by(user_id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      msg: "Cart not found for user with id #{params[:id]}",
    }
  end

  # Only allow a list of trusted parameters through.
  def cart_params
    params.permit(products: [:id, :quantity])
  end
end
