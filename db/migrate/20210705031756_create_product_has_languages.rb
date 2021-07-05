class CreateProductHasLanguages < ActiveRecord::Migration[6.1]
  def change
    create_table :product_has_languages do |t|
      t.references :product, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end
  end
end
