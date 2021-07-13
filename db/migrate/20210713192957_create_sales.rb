class CreateSales < ActiveRecord::Migration[6.1]
  def change
    create_table :sales do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total
      t.integer :payment_method
      t.string :payment_info

      t.timestamps
    end
  end
end
