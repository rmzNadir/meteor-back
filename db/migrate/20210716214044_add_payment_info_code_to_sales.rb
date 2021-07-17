class AddPaymentInfoCodeToSales < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :payment_info_code, :string, limit: 4
  end
end
