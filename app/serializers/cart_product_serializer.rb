class CartProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :price, :description, :stock, :shipping_cost, :image

  def image
    return unless object.image.attached?

    {
      id: object.image.id,
      filename: object.image.blob.filename,
      content_type: object.image.blob.content_type,
      url: url_for(object.image),
      created_at: object.image.created_at
    }
  end
end
