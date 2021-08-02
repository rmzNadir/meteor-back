class AddDisabledToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :disabled, :boolean, default: false
  end
end
