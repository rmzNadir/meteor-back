class AddShippingTotalToSales < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :shipping_total, :integer
  end
end
