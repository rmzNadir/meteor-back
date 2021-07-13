class CreateHasSales < ActiveRecord::Migration[6.1]
  def change
    create_table :has_sales do |t|
      t.references :product, null: false, foreign_key: true
      t.references :sale, null: false, foreign_key: true

      t.timestamps
    end
  end
end
