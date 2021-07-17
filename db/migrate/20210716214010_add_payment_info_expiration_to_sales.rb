class AddPaymentInfoExpirationToSales < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :payment_info_expiration, :string, limit: 5
  end
end
