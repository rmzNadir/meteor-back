class Platform < ApplicationRecord
  has_many :product_has_platforms, dependent: :destroy
  has_many :products, through: :product_has_platforms
end
