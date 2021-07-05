class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.string :description
      t.integer :stock
      t.string :provider
      t.boolean :has_free_shipping
      t.integer :shipping_cost
      t.timestamp :last_bought_at

      t.timestamps
    end
  end
end
