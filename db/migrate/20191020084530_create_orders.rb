class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :admin_id
      t.string  :city_name
      t.string  :start_date
      t.string  :end_date
      t.string  :status
      t.string  :customer_name
      t.string  :customer_phone_number
      t.string  :address_province
      t.string  :address_city
      t.string  :location_title
      t.string  :location_address
      t.string  :location_details
      t.string  :referral_name
      t.string  :referral_phone_number
      t.timestamps
    end
    add_index :orders, :start_date

    create_table :products do |t|
      t.string  :type
      t.float   :price
      t.string  :title
      t.string  :city_name
      t.string  :start_date
      t.string  :end_date
      t.text    :description
      t.string  :front_image
      t.string  :detailed_image
      t.boolean :active
      t.timestamps
    end
    add_index :products, :type

    create_table :purchased_items do |t|
      t.integer  :order_id
      t.integer  :product_id
      t.integer  :quantity
      t.float  :price
      t.timestamps
    end
    add_index :purchased_items, :order_id

    create_table :order_payment_records do |t|
      t.integer  :order_id
      t.integer  :payment_method_id
      t.string   :payment_method_name
      t.float    :cost
      t.boolean  :active
      t.datetime :timestamp
      t.string   :out_trade_no
      t.string   :transaction_id
    end
    add_index :order_payment_records, :order_id

    create_table :arrangers do |t|
      t.integer  :base_order_count, default: 0
      t.string  :name
      t.string  :phone_number
      t.boolean :active
      t.timestamps
    end

    create_table :order_arranger_assignments do |t|
      t.integer  :order_id
      t.integer  :arranger_id
      t.float  :amount, default: 0
    end
    add_index :order_arranger_assignments, :order_id
    add_index :order_arranger_assignments, :arranger_id

  end
end
