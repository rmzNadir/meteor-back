class Sale < ApplicationRecord
  belongs_to :user
  has_many :has_sales, dependent: :destroy
  has_many :products, through: :has_sales
  enum payment_method: { credit_card: 0, debit_card: 1 }

  # TODO: Encrypt payment details

  validates :user, :payment_method, :payment_info, :payment_info_expiration, :payment_info_code, :address, presence: true

  # after_create :save_products

  # attr_writer :products

  # def self.update_products(sale, products)
  #   old_products = HasSale.where(sale_id: sale.id).pluck(:product_id)
  #   products_to_delete = old_products - products

  #   products_to_delete.each do |product_id|
  #     HasSale.find_by(product_id: product_id, sale_id: sale.id).destroy
  #   end

  #   products.each do |product_id|
  #     HasSale.find_or_create_by(product_id: product_id, sale_id: sale.id)
  #   end
  # end

  # def self.update_product_stock(sale)
  #   sale.has_sales.each do |has_sale|
  #     new_stock = has_sale.product.stock - has_sale.quantity

  #     has_sale.product.update(stock: new_stock)
  #   end
  # end

  # private

  # def save_products
  #   return errors.add(:sales, I18n.t('activerecord.errors.models.sale.attributes.products.blank')) if @products.nil?

  #   @products.each do |product|
  #     if HasSale.create(product_id: product[:id], sale_id: id, quantity: product[:quantity] )
  #       Product.find(product[:id]).update(last_bought_at: DateTime.now)
  #     end
  #   end

  #   calculate_total
  # end

  # def calculate_total
  #   total = 0
  #   has_sales.each do |has_sale|
  #     total += has_sale.quantity * has_sale.product.price
  #   end

  #   calculate_shipping(total)
  # end

  # # Shipping cost is free on totals equal or higher than 250 MXN, otherwise shipping cost will be set
  # # to the highest shipping cost present in all of the sale's products
  # def calculate_shipping(total)
  #   shipping = 0

  #   if total < 250
  #     has_sales.each do |has_sale|
  #       product_shipping_cost = has_sale.product.shipping_cost
  #       shipping =  product_shipping_cost > shipping ? product_shipping_cost : shipping
  #     end
  #   end

  #   update!(total: total, shipping_total: shipping)
  # end
end
