class Product < ApplicationRecord
  has_many :product_has_languages, dependent: :destroy
  has_many :languages, through: :product_has_languages
  has_many :product_has_platforms, dependent: :destroy
  has_many :platforms, through: :product_has_platforms
  has_many :has_sales, dependent: :destroy
  has_many :sales, through: :has_sales
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_one_attached :image

  validates :platforms, :languages, presence: true, on: :save
  validates_associated :platforms, :languages, presence: true, on: :save
  validates :name, :price, :description, :stock, :provider, :shipping_cost, presence: true
  validates :name, uniqueness: true
  validates :has_free_shipping, inclusion: { in: [true, false] }

  # TODO: Find a better solution...- Status: Done, moved the logic to a new service

  # after_create :save_platforms, :save_languages

  # attr_writer :languages, :platforms

  # def self.update_platforms(product, platforms)
  #   old_platforms = ProductHasPlatform.where(product_id: product.id).pluck(:platform_id)
  #   platforms_to_delete = old_platforms - platforms

  #   platforms_to_delete.each do |platform_id|
  #     ProductHasPlatform.find_by(platform_id: platform_id, product_id: product.id).destroy
  #   end

  #   platforms.each do |platform_id|
  #     ProductHasPlatform.find_or_create_by(platform_id: platform_id, product_id: product.id)
  #   end
  # end

  # def self.update_languages(product, languages)
  #   old_langs = ProductHasLanguage.where(product_id: product.id).pluck(:language_id)
  #   langs_to_delete = old_langs - languages

  #   langs_to_delete.each do |language_id|
  #     ProductHasLanguage.find_by(language_id: language_id, product_id: product.id).destroy
  #   end

  #   languages.each do |language_id|
  #     ProductHasLanguage.find_or_create_by(language_id: language_id, product_id: product.id)
  #   end
  # end

  # def save_languages
  #   return errors.add(:languages, I18n.t('activerecord.errors.models.product.attributes.languages.blank')) if @languages.nil?

  #   @languages.each do |language_id|
  #     ProductHasLanguage.create(language_id: language_id, product_id: id)
  #   end
  # end

  # def save_platforms
  #   return errors.add(:languages, I18n.t('activerecord.errors.models.product.attributes.platforms.blank')) if @platforms.nil?

  #   @platforms.each do |platform_id|
  #     ProductHasPlatform.create(platform_id: platform_id, product_id: id)
  #   end
  # end
end
