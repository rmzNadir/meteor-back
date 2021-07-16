class CartItemSerializer < ActiveModel::Serializer
  attributes :quantity

  # Merge product values with cart item values
  def attributes(options = {}, reload = false) # rubocop:disable Style/OptionalBooleanParameter
    data = super
    data.reverse_merge! ActiveModel::Serializer.adapter.new(CartProductSerializer.new(object.product)).serializable_hash
    data
  end
end
