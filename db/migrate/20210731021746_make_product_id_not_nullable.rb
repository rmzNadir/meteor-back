class MakeProductIdNotNullable < ActiveRecord::Migration[6.1]
  def change
    change_column :has_sales, :product_id, :bigint, null: false
  end
end
