class AddAdvanceDaysToProduct < ActiveRecord::Migration[6.0]
  def change
  	add_column :products, :advance_days, :integer, default: 1
  end
end
