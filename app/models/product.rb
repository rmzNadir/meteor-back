class Product < ApplicationRecord
  has_many :product_has_languages, dependent: :destroy
  has_many :languages, through: :product_has_languages
  has_many :product_has_platforms, dependent: :destroy
  has_many :platforms, through: :product_has_platforms

  validates :platforms, :languages, presence: true, on: :update
  validates_associated :platforms, :languages, presence: true, on: :update
  validates :name, :price, :description, :stock, :provider, :shipping_cost, presence: true
  validates :has_free_shipping, inclusion: { in: [true, false] }

  after_create :save_languages, :save_platforms

  attr_writer :languages, :platforms

  private

  def save_languages
    @languages.each do |language_id|
      ProductHasLanguage.create(language_id: language_id, product_id: id)
    end
  end

  def save_platforms
    @platforms.each do |platform_id|
      ProductHasPlatform.create(platform_id: platform_id, product_id: id)
    end
  end

 
end
