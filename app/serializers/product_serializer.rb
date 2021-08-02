class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :price, :description, :stock, :provider, :has_free_shipping, :shipping_cost, :last_bought_at, :created_at, :image, :times_bought, :disabled

  has_many :languages, serializer: LanguageSerializer
  has_many :platforms, serializer: PlatformSerializer

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
