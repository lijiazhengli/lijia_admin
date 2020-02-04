class AddCanPayToProducts < ActiveRecord::Migration[6.0]
  def change
  	add_column :products, :create_tenpay, :boolean, default: false
  end
end
