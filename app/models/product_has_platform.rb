class ProductHasPlatform < ApplicationRecord
  belongs_to :product
  belongs_to :platform
end
