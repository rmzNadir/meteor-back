class SalesServices::Relations
  def initialize(sale, params)
    @sale = sale
    @products = params[:products]
  end

  def call(create: true)
    if create
      create_relations
    else
      update_relations
    end
  end

  def create_relations
    return errors.add(:sales, I18n.t('activerecord.errors.models.sale.attributes.products.blank')) if @products.nil?

    @products.each do |prod|
      next unless HasSale.create(product_id: prod[:id], sale_id: @sale.id, quantity: prod[:quantity] )

      product = Product.find(prod[:id])
      product.update(last_bought_at: DateTime.now, times_bought: product.times_bought + prod[:quantity])
    end

    calculate_subtotal
  end

  def update_relations
    old_products = HasSale.where(sale_id: @sale.id).pluck(:product_id)
    products_to_delete = old_products - @products

    products_to_delete.each do |product_id|
      HasSale.find_by(product_id: product_id, sale_id: @sale.id).destroy
    end

    @products.each do |product_id|
      HasSale.find_or_create_by(product_id: product_id, sale_id: @sale.id)
    end
  end

  private

  def calculate_subtotal
    subtotal = 0
    @sale.has_sales.each do |has_sale|
      subtotal += has_sale.quantity * has_sale.product.price

      new_stock = has_sale.product.stock - has_sale.quantity

      has_sale.product.update(stock: new_stock)
    end

    calculate_shipping(subtotal)
  end

  # Shipping cost is free on subtotals equal or higher than 250 MXN, otherwise it will be set
  # to the highest shipping cost present in all of the sale's products
  def calculate_shipping(subtotal)
    shipping = 0

    if subtotal < 250
      @sale.has_sales.each do |has_sale|
        product_shipping_cost = has_sale.product.shipping_cost
        shipping = product_shipping_cost > shipping ? product_shipping_cost : shipping
      end
    end

    @sale.update(subtotal: subtotal, shipping_total: shipping, total: subtotal + shipping)
  end
end
