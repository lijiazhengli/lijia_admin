class AddPositionToProduct < ActiveRecord::Migration[6.0]
  def change
  	add_column :products, :position, :integer, default: 999
  end
end
