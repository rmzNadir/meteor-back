class AddQuantityToHasSales < ActiveRecord::Migration[6.1]
  def change
    add_column :has_sales, :quantity, :integer
  end
end
