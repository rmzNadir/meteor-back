class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :description, :stock, :provider, :has_free_shipping, :shipping_cost, :last_bought_at

  has_many :languages, serializer: LanguageSerializer
  has_many :platforms, serializer: PlatformSerializer
end
