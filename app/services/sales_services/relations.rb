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

    @products.each do |product|
      if HasSale.create(product_id: product[:id], sale_id: @sale.id, quantity: product[:quantity] )
        Product.find(product[:id]).update(last_bought_at: DateTime.now)
      end
    end

    calculate_total
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

  def calculate_total
    total = 0
    @sale.has_sales.each do |has_sale|
      total += has_sale.quantity * has_sale.product.price

      new_stock = has_sale.product.stock - has_sale.quantity

      has_sale.product.update(stock: new_stock)
    end

    calculate_shipping(total)
  end

  # Shipping cost is free on totals equal or higher than 250 MXN, otherwise shipping cost will be set
  # to the highest shipping cost present in all of the sale's products
  def calculate_shipping(total)
    shipping = 0

    if total < 250
      @sale.has_sales.each do |has_sale|
        product_shipping_cost = has_sale.product.shipping_cost
        shipping = product_shipping_cost > shipping ? product_shipping_cost : shipping
      end
    end

    @sale.update(total: total, shipping_total: shipping)
  end
end
