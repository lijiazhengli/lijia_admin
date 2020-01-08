class AddMinCountToProduct < ActiveRecord::Migration[6.0]
  def change
  	add_column :products, :count_string, :string
  end
end
