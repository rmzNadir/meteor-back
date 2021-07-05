class CreateProductHasPlatforms < ActiveRecord::Migration[6.1]
  def change
    create_table :product_has_platforms do |t|
      t.references :product, null: false, foreign_key: true
      t.references :platform, null: false, foreign_key: true

      t.timestamps
    end
  end
end
