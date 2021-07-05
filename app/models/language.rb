class Language < ApplicationRecord
  has_many :product_has_languages, dependent: :destroy
  has_many :products, through: :product_has_languages
end
