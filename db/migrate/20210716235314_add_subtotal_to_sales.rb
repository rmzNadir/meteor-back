class AddSubtotalToSales < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :subtotal, :integer
  end
end
