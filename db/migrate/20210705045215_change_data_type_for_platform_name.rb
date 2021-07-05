class ChangeDataTypeForPlatformName < ActiveRecord::Migration[6.1]
  def self.up
    change_table :platforms do |t|
      t.change :name, :string
    end
  end
  def self.down
    change_table :platforms do |t|
      t.change :name, :integer
    end
  end
end
