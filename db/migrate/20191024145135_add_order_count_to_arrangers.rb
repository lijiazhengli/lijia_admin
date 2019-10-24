class AddOrderCountToArrangers < ActiveRecord::Migration[6.0]
  def change
  	add_column :arrangers, :orders_count, :integer, default: 0
  	add_index :arrangers, :orders_count
  end
end
