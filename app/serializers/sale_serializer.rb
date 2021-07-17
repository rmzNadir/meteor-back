class SaleSerializer < ActiveModel::Serializer
  attributes :id, :total, :subtotal, :shipping_total, :address, :payment_method, :payment_info, :products

  # has_many :products, serializer: ProductSerializer
  belongs_to :user, serializer: UserSerializerLight

  def products
    ActiveModel::Serializer::CollectionSerializer.new(object.has_sales, each_serializer: HasSaleSerializer)
  end
end
