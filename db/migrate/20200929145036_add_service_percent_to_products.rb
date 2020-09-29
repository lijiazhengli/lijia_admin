class AddServicePercentToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :service_percent, :float, default: 1
  end
end
