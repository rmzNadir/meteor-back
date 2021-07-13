class HasSaleSerializer < ActiveModel::Serializer
  attributes :id, :name, :unit_price, :quantity

  def id
    object.product_id
  end

  def name
    object.product[:name]
  end

  def unit_price
    object.product[:price]
  end
end
