class HasSaleSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :unit_price, :quantity, :image

  def id
    object.product_id
  end

  def name
    object.product[:name]
  end

  def unit_price
    object.product[:price]
  end

  def image
    return unless object.product.image.attached?

    {
      id: object.product.image.id,
      filename: object.product.image.blob.filename,
      content_type: object.product.image.blob.content_type,
      url: url_for(object.product.image),
      created_at: object.product.image.created_at
    }
  end
end
