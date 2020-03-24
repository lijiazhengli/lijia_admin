class CreateDeliveryOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :delivery_orders do |t|
      t.integer  :order_id
      t.string   :status, default: 'new'
      t.string   :express_name
      t.string   :express_no, limit: 100
      t.timestamps
    end

    add_index :delivery_orders, :order_id
    add_index :delivery_orders, :express_no
    add_column :purchased_items, :delivery_order_id, :integer
  end
end