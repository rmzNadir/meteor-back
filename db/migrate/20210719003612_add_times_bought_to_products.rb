class AddTimesBoughtToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :times_bought, :integer, default: 0
  end
end
