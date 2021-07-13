class AddAddressToSales < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :address, :string
  end
end
