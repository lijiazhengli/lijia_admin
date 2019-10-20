class AddItemTypeToOrderArranger < ActiveRecord::Migration[6.0]
  def change
  	add_column :order_arranger_assignments, :item_type, :string, limit: 20
  end
end
