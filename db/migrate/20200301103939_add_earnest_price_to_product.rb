class AddEarnestPriceToProduct < ActiveRecord::Migration[6.0]
  def change
  	add_column :products, :earnest_price, :float
  	add_column :products, :max_count, :integer
  end
end
