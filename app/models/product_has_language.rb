class ProductHasLanguage < ApplicationRecord
  belongs_to :product
  belongs_to :language
end
