class CartsServices::Relations
  def initialize(cart, params)
    @cart = cart
    @params = params
  end

  def call(create: true)
    if create
      nil
    else
      update_relations
    end
  end

  def update_relations
    # if @params[:products].nil?
    #   @cart.errors.add(:sales, I18n.t('activerecord.errors.models.cart.attributes.products.blank'))
    #   return false
    # end

    products = @params[:products]

    old_products = CartItem.where(cart_id: @cart.id).pluck(:product_id)
    products_to_delete = old_products - products

    products_to_delete.each do |product_id|
      CartItem.find_by(product_id: product_id, cart_id: @cart.id).destroy
    end

    products.each do |product|
      car_item = CartItem.find_or_initialize_by(product_id: product[:id], cart_id: @cart.id )
      car_item.quantity = product[:quantity]
      car_item.save
    end
    true
  end
end
