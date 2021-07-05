class CreateLanguages < ActiveRecord::Migration[6.1]
  def change
    create_table :languages do |t|
      t.integer :name

      t.timestamps
    end
  end
end
