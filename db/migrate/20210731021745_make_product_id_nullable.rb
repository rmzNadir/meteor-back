class MakeProductIdNullable < ActiveRecord::Migration[6.1]
  def change
    change_column :has_sales, :product_id, :bigint, null: true
  end
end
