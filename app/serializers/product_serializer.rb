class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :price, :description, :stock, :provider, :has_free_shipping, :shipping_cost, :last_bought_at, :created_at, :image

  has_many :languages, serializer: LanguageSerializer
  has_many :platforms, serializer: PlatformSerializer

  def image
    return unless object.image.attached?

    {
      filename: object.image.blob.filename,
      content_type: object.image.blob.content_type,
      url: rails_blob_path(object.image, only_path: true)
    }
  end
end
